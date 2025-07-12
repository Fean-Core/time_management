import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkAuthStatus();
  }

  /// Verifica se o usuário está logado ao inicializar
  Future<void> _checkAuthStatus() async {
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        // Verificar se o token ainda é válido
        final userData = await AuthService.getCurrentUser();
        if (userData != null) {
          _user = userData;
          _isAuthenticated = true;
        } else {
          // Token inválido, limpar dados
          await _clearAuthData();
        }
      }
    } catch (e) {
      print('Erro ao verificar status de autenticação: $e');
      await _clearAuthData();
    } finally {
      _setLoading(false);
    }
  }

  /// Realizar login
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      print('AuthProvider: Iniciando login para $email');
      final result = await AuthService.login(email, password);
      print('AuthProvider: Resultado do login: $result');
      
      if (result != null) {
        _user = result['user'];
        _isAuthenticated = true;
        
        // Salvar token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', result['token']);
        
        print('AuthProvider: Login bem-sucedido. isAuthenticated: $_isAuthenticated');
        print('AuthProvider: User: ${_user?.name}');
        
        notifyListeners();
        return true;
      } else {
        _setError('Email ou senha inválidos');
        print('AuthProvider: Login falhou - resultado nulo');
        return false;
      }
    } catch (e) {
      _setError('Erro ao fazer login: ${e.toString()}');
      print('AuthProvider: Exceção no login: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Realizar registro
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final result = await AuthService.register(name, email, password);
      
      if (result != null) {
        _user = result['user'];
        _isAuthenticated = true;
        
        // Salvar token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', result['token']);
        
        notifyListeners();
        return true;
      } else {
        _setError('Erro ao criar conta');
        return false;
      }
    } catch (e) {
      _setError('Erro ao registrar: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Realizar logout
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await AuthService.logout();
      await _clearAuthData();
    } catch (e) {
      print('Erro ao fazer logout: $e');
      await _clearAuthData();
    } finally {
      _setLoading(false);
    }
  }

  /// Limpar dados de autenticação
  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Definir estado de carregamento
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Definir erro
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Limpar erro
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
