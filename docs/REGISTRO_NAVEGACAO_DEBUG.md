# Debug - Registro e Navegação

## Problema Identificado
Usuário criado com sucesso, mas app não sai da tela de registro.

## Correções Aplicadas

### 1. Correção de Imports no main.dart
- ✅ Adicionadas importações das telas: `AuthWrapper`, `LoginScreen`, `RegisterScreen`, `HomeScreen`, `TasksScreen`
- ✅ Corrigido nome do projeto no `pubspec.yaml` de "Time Management" para "time_management"

### 2. Melhorias no AuthProvider
- ✅ Logs mais detalhados durante o registro
- ✅ Melhor controle do estado `isLoading`
- ✅ Garantia de notificação de mudança de estado (`notifyListeners`)

### 3. Navegação Mais Robusta na RegisterScreen
- ✅ Verificação dupla do estado de autenticação após registro
- ✅ Navegação para `/home` se autenticado, senão fallback para `/` (AuthWrapper)
- ✅ Logs detalhados para debug

### 4. Configurações de Timeout e Error Handling
- ✅ Timeout de 45s na tela de registro
- ✅ Timeout de 30s no AuthService.register
- ✅ Tratamento detalhado de erros

## Como Testar

### 1. Compilar e Executar
```bash
cd /home/m496839/workspace/projects/Personal/apps/time_management
flutter clean
flutter pub get
flutter run -d linux
```

### 2. Testar Fluxo de Registro
1. Abrir app → deve mostrar SplashScreen → AuthWrapper → LoginScreen
2. Clicar em "Criar conta" → RegisterScreen
3. Preencher dados:
   - Nome: Teste Usuario
   - Email: teste@example.com
   - Senha: 123456
   - Confirmar senha: 123456
4. Clicar "Criar Conta"
5. **ESPERADO**: Após registro bem-sucedido → navegar para HomeScreen

### 3. Logs para Monitorar
Verificar no console do Flutter:
```
🚀 AuthProvider: Iniciando registro para teste@example.com
📝 Tentando registro para: teste@example.com
✅ Registro response status: 201
✅ AuthProvider: Usuário registrado com sucesso
✅ AuthProvider: isAuthenticated = true
✅ Registro bem-sucedido - Verificando estado de autenticação
✅ Estado autenticado confirmado - Navegando para home
```

### 4. Cenários de Teste

#### Registro Bem-Sucedido
- ✅ App navega para HomeScreen
- ✅ AuthWrapper detecta usuário autenticado
- ✅ Token salvo no SharedPreferences

#### Email Já Existente
- ✅ Mensagem: "Este email já está cadastrado. Use outro email."
- ✅ App permanece na tela de registro
- ✅ Loading desabilitado

#### Sem Internet
- ✅ Mensagem: "Sem conexão com o servidor. Verifique sua internet."
- ✅ Timeout após 45s

#### Servidor Offline
- ✅ Timeout após 45s
- ✅ Mensagem: "Timeout: Servidor demorou para responder. Tente novamente."

## Arquivos Modificados
1. `/lib/main.dart` - Imports das telas
2. `/lib/providers/auth_provider.dart` - Melhor controle de estado
3. `/lib/screens/register_screen.dart` - Navegação robusta
4. `/pubspec.yaml` - Nome do projeto corrigido

## Próximos Passos se Ainda Não Funcionar
1. Verificar se AuthWrapper está recebendo as notificações
2. Adicionar mais logs no AuthWrapper
3. Verificar se o token está sendo salvo corretamente
4. Testar navegação direta para `/home`
5. Verificar ciclo de vida do Consumer<AuthProvider>

## Comandos Úteis para Debug
```bash
# Hot reload durante teste
r

# Hot restart
R

# Ver logs detalhados
flutter logs

# Limpar cache se necessário
flutter clean && flutter pub get
```
