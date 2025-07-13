# Correção do Logout por Erro de Servidor (500)

## Problema Identificado
O usuário estava sendo deslogado quando o servidor retornava erro 500, mesmo tendo dados válidos salvos localmente.

### Log do Problema:
```
🔄 AuthWrapper: isAuthenticated: true
🔄 AuthWrapper: user: Francisco
DioException [bad response]: status code of 500
❌ AuthProvider: Token inválido, limpando dados
🔑 AuthWrapper: Usuário não autenticado - Mostrando LoginScreen
```

## Causa Raiz
A lógica original não diferenciava entre tipos de erro:
- **Erro 500 (Server Error)**: Problema do servidor, token pode estar válido
- **Erro 401 (Unauthorized)**: Token realmente inválido
- **Erro de Rede**: Conexão indisponível

**Resultado**: Qualquer erro causava logout, mesmo quando o problema era do servidor.

## Soluções Implementadas

### 1. Categorização de Erros no AuthService
**Antes**: Erro genérico
```dart
} catch (e) {
  print('Erro ao obter usuário: ${e.message}');
  return null;
}
```

**Agora**: Exceções específicas
```dart
} catch (e) {
  if (e.toString().contains('401')) {
    throw Exception('UNAUTHORIZED');      // Token inválido
  } else if (e.toString().contains('500')) {
    throw Exception('SERVER_ERROR');      // Problema do servidor
  } else if (e.toString().contains('network')) {
    throw Exception('NETWORK_ERROR');     // Problema de rede
  } else {
    throw Exception('UNKNOWN_ERROR: $e');
  }
}
```

### 2. Lógica Inteligente no AuthProvider
**Antes**: Qualquer erro = logout
```dart
} catch (e) {
  print('❌ AuthProvider: Token inválido, limpando dados');
  await _clearAuthData();
}
```

**Agora**: Tratamento por tipo de erro
```dart
} catch (e) {
  String errorMsg = e.toString();
  
  if (errorMsg.contains('SERVER_ERROR') || errorMsg.contains('NETWORK_ERROR')) {
    // 🔒 MANTER LOGIN LOCAL - Problema do servidor/rede
    print('⚠️ Erro de servidor/rede, mantendo login local');
    print('⚠️ Usuário ${_user?.name} permanece logado offline');
    // NÃO limpar dados
    
  } else if (errorMsg.contains('UNAUTHORIZED')) {
    // 🚪 FAZER LOGOUT - Token realmente inválido
    print('❌ Token expirado/inválido (401), fazendo logout');
    await _clearAuthData();
    
  } else if (_user == null) {
    // 🗑️ LIMPAR - Erro sem dados locais
    await _clearAuthData();
    
  } else {
    // 🔒 MANTER - Erro desconhecido mas com dados locais
    print('⚠️ Erro desconhecido, mantendo login local');
  }
}
```

## Fluxo Corrigido

### Cenário: Servidor com Erro 500
```
1. F5 → AuthProvider inicia verificação
2. Carrega dados locais → Usuário logado ✅
3. Verifica servidor → Erro 500 🔥
4. ANTES: Logout automático ❌
   AGORA: Mantém login local ✅
5. Usuário continua usando o app offline
```

### Cenário: Token Expirado (401)
```
1. F5 → AuthProvider inicia verificação
2. Carrega dados locais → Usuário logado temporariamente
3. Verifica servidor → Erro 401 (Unauthorized)
4. Logout automático ✅ (comportamento correto)
5. Mostra tela de login
```

### Cenário: Problema de Rede
```
1. F5 → AuthProvider inicia verificação
2. Carrega dados locais → Usuário logado ✅
3. Verifica servidor → Erro de rede 🌐
4. Mantém login local ✅
5. Usuário continua usando o app offline
```

## Arquivos Modificados

### `/lib/services/auth_service.dart`
- ✅ `getCurrentUser()`: Categorização específica de erros
- ✅ Exceções nomeadas: `SERVER_ERROR`, `UNAUTHORIZED`, `NETWORK_ERROR`
- ✅ Logs detalhados para debug

### `/lib/providers/auth_provider.dart`
- ✅ `_checkAuthStatus()`: Lógica inteligente por tipo de erro
- ✅ Mantém login local em erros de servidor/rede
- ✅ Logout apenas em erros de autenticação (401)

## Benefícios

### ✅ **Experiência Mais Robusta**
- Usuário não é deslogado por problemas do servidor
- App funciona offline com dados locais
- Logout apenas quando realmente necessário

### ✅ **Melhor Debugging**
- Logs específicos por tipo de erro
- Fácil identificação de problemas
- Comportamento previsível

### ✅ **Tolerância a Falhas**
- Resiliência a problemas temporários do servidor
- Graceful degradation para modo offline
- Experiência consistente

## Logs Esperados Agora

### Servidor com Erro 500:
```
🔍 AuthService: Verificando usuário atual...
❌ AuthService.getCurrentUser: Erro - DioException [500]
⚠️ AuthProvider: Erro de servidor/rede, mantendo login local
⚠️ AuthProvider: Usuário Francisco permanece logado offline
✅ AuthWrapper: Usuário autenticado - Redirecionando para HomeScreen
```

### Token Expirado (401):
```
🔍 AuthService: Verificando usuário atual...
❌ AuthService.getCurrentUser: Erro - DioException [401]
❌ AuthProvider: Token expirado/inválido (401), fazendo logout
🗑️ AuthProvider: Dados de autenticação limpos
🔑 AuthWrapper: Usuário não autenticado - Mostrando LoginScreen
```

## Status
✅ **Implementado**: Tratamento inteligente de erros de servidor  
✅ **Testado**: Sem erros de compilação  
🔄 **Em Teste**: Verificação com erro 500 real do servidor  

O usuário agora deve permanecer logado mesmo quando o servidor retorna erro 500, mantendo uma experiência mais robusta e tolerante a falhas.
