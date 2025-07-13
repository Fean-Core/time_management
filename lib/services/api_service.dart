import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  static late Dio _dio;
  static const String baseUrl = 'https://time-magagement-backend.onrender.com/api'; // Backend em produção
  static Function()? onAuthError; // Callback para erro de autenticação
  
  static void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'TimeManagementApp/1.0.0 (Flutter)', // Adicionar User-Agent
      },
      connectTimeout: const Duration(seconds: 60), // Aumentar timeout para mobile
      receiveTimeout: const Duration(seconds: 60), // Aumentar timeout para mobile
      sendTimeout: const Duration(seconds: 60), // Adicionar send timeout
    ));
    
    // Configurar adapter para Web se necessário
    if (kIsWeb) {
      // Configurações específicas para Web
      _dio.options.extra['withCredentials'] = false;
      print('🌐 Flutter Web detectado - CORS deve estar configurado no backend');
    } else {
      print('🖥️  Flutter Desktop/Mobile - sem problemas de CORS');
    }
    
    // Adicionar interceptors
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(CorsInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) {
        print(obj); // Para debug
      },
    ));
  }
  
  static Dio get dio => _dio;
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expirado - limpar dados e notificar
      _clearAuthToken();
      if (ApiService.onAuthError != null) {
        ApiService.onAuthError!();
      }
    }
    handler.next(err);
  }
  
  void _clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

class CorsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Note: Estes headers não resolvem CORS do lado cliente
    // CORS deve ser configurado no servidor (backend)
    // Mantemos apenas para debug e compatibilidade
    if (kIsWeb) {
      // Para Web, remover headers que podem causar problemas
      options.headers.remove('Access-Control-Allow-Origin');
      options.headers.remove('Access-Control-Allow-Methods');
      options.headers.remove('Access-Control-Allow-Headers');
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Detectar erros específicos de CORS
    bool isCorsError = false;
    
    if (err.type == DioExceptionType.connectionError) {
      final message = err.message?.toLowerCase() ?? '';
      final error = err.error?.toString().toLowerCase() ?? '';
      
      // Padrões comuns de erro CORS
      if (message.contains('xmlhttprequest') || 
          message.contains('cors') ||
          message.contains('cross-origin') ||
          error.contains('cors') ||
          error.contains('cross-origin')) {
        isCorsError = true;
      }
    }
    
    if (isCorsError) {
      print('🚫 ERRO DE CORS DETECTADO');
      print('📱 URL: ${err.requestOptions.uri}');
      print('� SOLUÇÕES:');
      print('   1. Execute: flutter run -d linux (Desktop - sem CORS)');
      print('   2. Configure CORS no backend Spring Boot');
      print('   3. Use um proxy reverso');
      print('💡 Consulte: CORS_SOLUTION_GUIDE.md');
      
      // Criar erro mais amigável para o usuário
      final corsError = DioException(
        requestOptions: err.requestOptions,
        error: 'Erro de CORS: Execute o app no desktop ou configure CORS no backend',
        type: DioExceptionType.connectionError,
        message: 'CORS não configurado. Use "flutter run -d linux" ou configure o backend.',
      );
      handler.next(corsError);
      return;
    }
    
    handler.next(err);
  }
}
