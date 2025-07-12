import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print('AuthWrapper: isLoading: ${authProvider.isLoading}');
        print('AuthWrapper: isAuthenticated: ${authProvider.isAuthenticated}');
        print('AuthWrapper: user: ${authProvider.user?.name}');
        
        // Mostrar loading durante verificação inicial
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando...'),
                ],
              ),
            ),
          );
        }

        // Se autenticado, mostrar app principal
        if (authProvider.isAuthenticated) {
          print('AuthWrapper: Redirecionando para HomeScreen');
          return const HomeScreen();
        }

        // Se não autenticado, mostrar tela de login
        print('AuthWrapper: Mostrando LoginScreen');
        return const LoginScreen();
      },
    );
  }
}
