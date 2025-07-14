import 'package:dio/dio.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  // Flag para usar dados mock quando o backend não estiver disponível
  static const bool _useMockData = false;

  /// Realizar login
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    if (_useMockData) {
      return _mockLogin(email, password);
    }

    try {
      print('🔐 Tentando login para: $email');
      print('🌐 URL do backend: ${ApiService.dio.options.baseUrl}');
      
      final response = await ApiService.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      print('✅ Login response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Adaptar a resposta da API para o formato esperado pelo modelo User
        final userApi = data['user'];
        final user = User(
          id: userApi['id'] ?? '',
          name: userApi['name'] ?? '',
          email: userApi['email'] ?? '',
          profileImageUrl: userApi['avatar'], // API usa 'avatar' em vez de 'profileImageUrl'
          createdAt: DateTime.now(), // API não retorna createdAt, usar data atual
          preferences: UserPreferences(
            enableNotifications: true,
            reminderMinutesBefore: 15,
            timeFormat: '24h',
            dateFormat: 'dd/MM/yyyy',
            enableSounds: true,
          ), // Usar preferências padrão
        );
        
        return {
          'user': user,
          'token': data['token'],
        };
      }
      return null;
    } on DioException catch (e) {
      print('❌ Erro no login - Tipo: ${e.type}');
      print('❌ Erro no login - Message: ${e.message}');
      print('❌ Erro no login - Response status: ${e.response?.statusCode}');
      print('❌ Erro no login - Response data: ${e.response?.data}');
      print('❌ Erro no login - Request URL: ${e.requestOptions.uri}');
      
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Timeout de conexão. Verifique sua internet.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Timeout ao receber dados. Verifique sua internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Erro de conexão. Verifique sua internet e tente novamente.');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Email ou senha inválidos');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Erro interno do servidor. Tente novamente em alguns minutos.');
      } else {
        throw Exception('Erro de conexão: ${e.message ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      print('❌ Erro inesperado no login: $e');
      throw Exception('Erro inesperado: $e');
    }
  }

  /// Realizar registro
  static Future<Map<String, dynamic>?> register(String name, String email, String password) async {
    if (_useMockData) {
      return _mockRegister(name, email, password);
    }

    try {
      print('📝 Tentando registro para: $email');
      print('👤 Nome: $name');
      print('🌐 URL do backend: ${ApiService.dio.options.baseUrl}');
      
      // Fazer a requisição com timeout específico para registro
      final response = await ApiService.dio.post('/auth/register', 
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        options: Options(
          receiveTimeout: const Duration(seconds: 30), // Timeout específico para registro
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      print('✅ Registro response status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        
        // Adaptar a resposta da API para o formato esperado pelo modelo User
        final userApi = data['user'];
        final user = User(
          id: userApi['id'] ?? '',
          name: userApi['name'] ?? '',
          email: userApi['email'] ?? '',
          profileImageUrl: userApi['avatar'],
          createdAt: DateTime.now(),
          preferences: UserPreferences(
            enableNotifications: true,
            reminderMinutesBefore: 15,
            timeFormat: '24h',
            dateFormat: 'dd/MM/yyyy',
            enableSounds: true,
          ),
        );
        
        return {
          'user': user,
          'token': data['token'],
        };
      }
      return null;
    } on DioException catch (e) {
      print('❌ Erro no registro - Tipo: ${e.type}');
      print('❌ Erro no registro - Message: ${e.message}');
      print('❌ Erro no registro - Response status: ${e.response?.statusCode}');
      print('❌ Erro no registro - Response data: ${e.response?.data}');
      print('❌ Erro no registro - Request URL: ${e.requestOptions.uri}');
      
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Timeout de conexão. Verifique sua internet e tente novamente.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Servidor demorou para responder. Tente novamente.');
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw Exception('Timeout ao enviar dados. Verifique sua internet.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Sem conexão com o servidor. Verifique sua internet.');
      } else if (e.response?.statusCode == 400) {
        // Verificar se é erro de email já existente ou validação
        final responseData = e.response?.data;
        if (responseData is Map && responseData['message'] != null) {
          final message = responseData['message'].toString();
          if (message.toLowerCase().contains('email')) {
            throw Exception('Este email já está cadastrado. Use outro email.');
          } else if (message.toLowerCase().contains('password')) {
            throw Exception('Senha deve ter pelo menos 6 caracteres.');
          } else {
            throw Exception('Dados inválidos: $message');
          }
        } else {
          throw Exception('Email já cadastrado ou dados inválidos.');
        }
      } else if (e.response?.statusCode == 422) {
        throw Exception('Dados inválidos. Verifique email e senha.');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Erro no servidor. Tente novamente em alguns minutos.');
      } else if (e.response?.statusCode == 503) {
        throw Exception('Servidor temporariamente indisponível. Tente mais tarde.');
      } else {
        throw Exception('Erro de conexão: ${e.message ?? 'Erro desconhecido'}');
      }
    } catch (e) {
      print('❌ Erro inesperado no registro: $e');
      throw Exception('Erro inesperado: $e');
    }
  }

  /// Obter usuário atual
  static Future<User?> getCurrentUser() async {
    if (_useMockData) {
      return _mockGetCurrentUser();
    }

    try {
      final response = await ApiService.dio.get('/auth/me');

      if (response.statusCode == 200) {
        final userApi = response.data;
        return User(
          id: userApi['id'] ?? '',
          name: userApi['name'] ?? '',
          email: userApi['email'] ?? '',
          profileImageUrl: userApi['avatar'],
          createdAt: DateTime.now(),
          preferences: UserPreferences(
            enableNotifications: true,
            reminderMinutesBefore: 15,
            timeFormat: '24h',
            dateFormat: 'dd/MM/yyyy',
            enableSounds: true,
          ),
        );
      }
      return null;
    } on DioException catch (e) {
      print('Erro ao obter usuário: ${e.message}');
      return null;
    }
  }

  /// Realizar logout
  static Future<void> logout() async {
    if (_useMockData) {
      return _mockLogout();
    }

    try {
      await ApiService.dio.post('/auth/logout');
    } on DioException catch (e) {
      print('Erro no logout: ${e.message}');
      // Mesmo com erro, consideramos logout bem-sucedido localmente
    }
  }

  /// Renovar token
  static Future<String?> refreshToken() async {
    if (_useMockData) {
      return _mockRefreshToken();
    }

    try {
      final response = await ApiService.dio.post('/auth/refresh');

      if (response.statusCode == 200) {
        return response.data['token'];
      }
      return null;
    } on DioException catch (e) {
      print('Erro ao renovar token: ${e.message}');
      return null;
    }
  }

  /// Verificar se email está disponível
  static Future<bool> isEmailAvailable(String email) async {
    if (_useMockData) {
      return _mockIsEmailAvailable(email);
    }

    try {
      final response = await ApiService.dio.get('/auth/check-email', queryParameters: {
        'email': email,
      });

      return response.data['available'] ?? false;
    } on DioException catch (e) {
      print('Erro ao verificar email: ${e.message}');
      return false;
    }
  }

  /// Solicitar redefinição de senha
  static Future<bool> requestPasswordReset(String email) async {
    if (_useMockData) {
      return _mockRequestPasswordReset(email);
    }

    try {
      final response = await ApiService.dio.post('/auth/forgot-password', data: {
        'email': email,
      });

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('Erro ao solicitar redefinição de senha: ${e.message}');
      return false;
    }
  }

  // ======== MÉTODOS MOCK ========

  /// Mock: Login
  static Future<Map<String, dynamic>?> _mockLogin(String email, String password) async {
    // Simular delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Validar credenciais mock
    if (email == 'teste@email.com' && password == '123456') {
      return {
        'user': User(
          id: '1',
          name: 'Usuário Teste',
          email: email,
          createdAt: DateTime.now(),
          preferences: UserPreferences(
            enableNotifications: true,
            reminderMinutesBefore: 15,
            timeFormat: '24h',
            dateFormat: 'dd/MM/yyyy',
            enableSounds: true,
          ),
        ),
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      };
    }

    // Qualquer email válido com senha "123456" funcionará
    if (email.contains('@') && password == '123456') {
      final name = email.split('@')[0].split('.').map((e) => 
        e[0].toUpperCase() + e.substring(1)).join(' ');
      
      return {
        'user': User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          email: email,
          createdAt: DateTime.now(),
          preferences: UserPreferences(
            enableNotifications: true,
            reminderMinutesBefore: 15,
            timeFormat: '24h',
            dateFormat: 'dd/MM/yyyy',
            enableSounds: true,
          ),
        ),
        'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      };
    }

    // Login inválido
    throw Exception('Email ou senha inválidos');
  }

  /// Mock: Registro
  static Future<Map<String, dynamic>?> _mockRegister(String name, String email, String password) async {
    // Simular delay de rede
    await Future.delayed(const Duration(seconds: 1));

    // Simular email já cadastrado
    if (email == 'admin@teste.com') {
      throw Exception('Email já cadastrado');
    }

    // Registrar usuário
    return {
      'user': User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        createdAt: DateTime.now(),
        preferences: UserPreferences(
          enableNotifications: true,
          reminderMinutesBefore: 15,
          timeFormat: '24h',
          dateFormat: 'dd/MM/yyyy',
          enableSounds: true,
        ),
      ),
      'token': 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  /// Mock: Obter usuário atual
  static Future<User?> _mockGetCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User(
      id: '1',
      name: 'Usuário Teste',
      email: 'teste@email.com',
      createdAt: DateTime.now(),
      preferences: UserPreferences(
        enableNotifications: true,
        reminderMinutesBefore: 15,
        timeFormat: '24h',
        dateFormat: 'dd/MM/yyyy',
        enableSounds: true,
      ),
    );
  }

  /// Mock: Logout
  static Future<void> _mockLogout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Simulação de logout bem-sucedido
  }

  /// Mock: Renovar token
  static Future<String?> _mockRefreshToken() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'mock_refreshed_token_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Mock: Verificar se email está disponível
  static Future<bool> _mockIsEmailAvailable(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return email != 'admin@teste.com'; // Admin já existe
  }

  /// Mock: Solicitar redefinição de senha
  static Future<bool> _mockRequestPasswordReset(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.contains('@'); // Simples validação de email
  }
}
