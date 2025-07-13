import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initialLoadingComplete = false;

  @override
  void initState() {
    super.initState();
    // Delay mínimo para garantir que a verificação de auth seja concluída
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _initialLoadingComplete = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print('🔄 AuthWrapper: Rebuild detectado');
        print('🔄 AuthWrapper: isLoading: ${authProvider.isLoading}');
        print('🔄 AuthWrapper: isAuthenticated: ${authProvider.isAuthenticated}');
        print('🔄 AuthWrapper: user: ${authProvider.user?.name}');
        print('🔄 AuthWrapper: error: ${authProvider.error}');
        print('🔄 AuthWrapper: initialLoadingComplete: $_initialLoadingComplete');
        
        // Mostrar loading durante verificação inicial ou se ainda não completou o loading inicial
        if (authProvider.isLoading || !_initialLoadingComplete) {
          print('⏳ AuthWrapper: Mostrando loading...');
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Verificando autenticação...'),
                ],
              ),
            ),
          );
        }

        // Se autenticado, mostrar app principal
        if (authProvider.isAuthenticated && authProvider.user != null) {
          print('✅ AuthWrapper: Usuário autenticado - Redirecionando para HomeScreen');
          print('✅ AuthWrapper: User data: ${authProvider.user?.email}');
          return const HomeScreen();
        }

        // Se não autenticado, mostrar tela de login
        print('🔑 AuthWrapper: Usuário não autenticado - Mostrando LoginScreen');
        return const LoginScreen();
      },
    );
  }
}
