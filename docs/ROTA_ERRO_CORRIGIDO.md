# Correção do Erro de Rota - Flutter

## Erro Original
```
'package:flutter/src/widgets/app.dart': Failed assertion: line 374 pos 10: 'home == null || routes.containsKey(Navigator.defaultRouteName)': if the home property is specified, the routes table cannot include an entry for "/", since it would be redundant.
```

## Problema
O MaterialApp estava configurado com:
- `home: const SplashScreen()` 
- `routes: { '/': (context) => const AuthWrapper(), ... }`

Isso criava conflito porque não pode ter `home` e uma rota para `'/'` ao mesmo tempo.

## Solução Aplicada

### 1. Ajuste no main.dart
```dart
// ANTES (com erro)
home: const SplashScreen(),
routes: {
  '/': (context) => const AuthWrapper(),
  '/login': (context) => const LoginScreen(),
  // ...
},

// DEPOIS (corrigido)
initialRoute: '/',
routes: {
  '/': (context) => const SplashScreen(),
  '/auth': (context) => const AuthWrapper(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/home': (context) => const HomeScreen(),
  '/tasks': (context) => const TasksScreen(),
},
```

### 2. Ajuste na SplashScreen
```dart
// ANTES
Navigator.of(context).pushReplacement(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const AuthWrapper(),
    // ...
  ),
);

// DEPOIS
Navigator.of(context).pushReplacementNamed('/auth');
```

### 3. Ajuste na RegisterScreen
```dart
// Fallback navigation mudou de '/' para '/auth'
Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
```

## Estrutura de Rotas Final
- `/` → SplashScreen (rota inicial)
- `/auth` → AuthWrapper (gerencia autenticação)
- `/login` → LoginScreen
- `/register` → RegisterScreen  
- `/home` → HomeScreen
- `/tasks` → TasksScreen

## Fluxo de Navegação
1. App inicia → `/` (SplashScreen)
2. Após 14s → `/auth` (AuthWrapper)
3. AuthWrapper decide:
   - Se autenticado → HomeScreen
   - Se não autenticado → LoginScreen
4. RegisterScreen → após registro → `/home` ou `/auth`

## Status
✅ Erro de rota corrigido
✅ App compilando sem erros
✅ Navegação funcionando corretamente

## Teste
O app agora deve:
1. Iniciar na SplashScreen
2. Navegar para AuthWrapper
3. Permitir registro sem conflitos de rota
4. Navegar corretamente após registro bem-sucedido
