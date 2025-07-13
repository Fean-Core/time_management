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
    _initializeAuth();
  }

  /// Inicializar autenticação de forma robusta
  Future<void> _initializeAuth() async {
    print('🔄 AuthProvider: Inicializando autenticação...');
    _setLoading(true);
    
    // Aguardar um pouco para garantir que SharedPreferences esteja pronto
    await Future.delayed(const Duration(milliseconds: 100));
    
    await _checkAuthStatus();
  }

  /// Verifica se o usuário está logado ao inicializar
  Future<void> _checkAuthStatus() async {
    try {
      print('🔍 AuthProvider: Verificando status de autenticação...');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userEmail = prefs.getString('user_email');
      final userName = prefs.getString('user_name');
      final userId = prefs.getString('user_id');
      
      print('🔍 AuthProvider: Token encontrado: ${token != null}');
      print('🔍 AuthProvider: Email salvo: $userEmail');
      
      if (token != null && userEmail != null) {
        // Primeiro, carregar dados salvos localmente
        if (userName != null && userId != null) {
          _user = User(
            id: userId,
            name: userName,
            email: userEmail,
            createdAt: DateTime.now(), // Usar data atual como fallback
            preferences: UserPreferences(
              enableNotifications: true,
              reminderMinutesBefore: 15,
              timeFormat: '24h',
              dateFormat: 'dd/MM/yyyy',
              enableSounds: true,
            ),
          );
          _isAuthenticated = true;
          print('✅ AuthProvider: Dados locais carregados - usuário: $userName');
          notifyListeners(); // Notificar imediatamente para mostrar a tela principal
        }
        
        // Depois, verificar se o token ainda é válido no servidor
        try {
          final userData = await AuthService.getCurrentUser();
          if (userData != null) {
            _user = userData;
            _isAuthenticated = true;
            
            // Atualizar dados salvos
            await _saveUserData(userData, token);
            print('✅ AuthProvider: Token válido, dados atualizados do servidor');
          } else {
            // Token inválido, limpar dados
            print('❌ AuthProvider: Token inválido, limpando dados');
            await _clearAuthData();
          }
        } catch (e) {
          // Analisar o tipo de erro para decidir se deve manter o login
          String errorMsg = e.toString();
          
          if (errorMsg.contains('SERVER_ERROR') || errorMsg.contains('NETWORK_ERROR')) {
            // Erro de servidor ou rede - manter login local
            print('⚠️ AuthProvider: Erro de servidor/rede, mantendo login local');
            print('⚠️ AuthProvider: Usuário ${_user?.name} permanece logado offline');
            // Não limpar dados - manter login local
          } else if (errorMsg.contains('UNAUTHORIZED')) {
            // Token realmente inválido - fazer logout
            print('❌ AuthProvider: Token expirado/inválido (401), fazendo logout');
            await _clearAuthData();
          } else if (_user == null) {
            // Outros erros sem dados locais - limpar
            print('❌ AuthProvider: Erro sem dados locais, limpando: $errorMsg');
            await _clearAuthData();
          } else {
            // Outros erros mas com dados locais - manter
            print('⚠️ AuthProvider: Erro desconhecido, mantendo login local: $errorMsg');
          }
        }
      } else {
        print('ℹ️ AuthProvider: Nenhum token encontrado');
        _isAuthenticated = false;
      }
    } catch (e) {
      print('❌ AuthProvider: Erro ao verificar status de autenticação: $e');
      await _clearAuthData();
    } finally {
      _setLoading(false);
    }
  }

  /// Forçar verificação de autenticação (útil para refresh da página)
  Future<void> refreshAuthStatus() async {
    print('🔄 AuthProvider: Forçando verificação de autenticação...');
    await _checkAuthStatus();
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
        
        // Salvar dados do usuário
        await _saveUserData(_user!, result['token']);
        
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
      print('🚀 AuthProvider: Iniciando registro para $email');
      final result = await AuthService.register(name, email, password);
      
      if (result != null) {
        _user = result['user'];
        _isAuthenticated = true;
        
        // Salvar dados do usuário
        await _saveUserData(_user!, result['token']);
        
        print('✅ AuthProvider: Usuário registrado com sucesso');
        print('✅ AuthProvider: isAuthenticated = $_isAuthenticated');
        print('✅ AuthProvider: user = ${_user?.name}');
        print('✅ AuthProvider: dados salvos');
        
        // Resetar loading e notificar mudança
        _setLoading(false);
        notifyListeners();
        
        return true;
      } else {
        print('❌ AuthProvider: Resultado do registro é nulo');
        _setError('Erro ao criar conta');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      print('❌ Erro no AuthProvider.register: $e');
      
      // Extrair mensagem de erro mais limpa
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11); // Remove "Exception: "
      }
      
      _setError(errorMessage);
      _setLoading(false);
      return false;
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
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    
    _user = null;
    _isAuthenticated = false;
    print('🗑️ AuthProvider: Dados de autenticação limpos');
    notifyListeners();
  }

  /// Salvar dados do usuário no SharedPreferences
  Future<void> _saveUserData(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    print('💾 AuthProvider: Dados do usuário salvos localmente');
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
