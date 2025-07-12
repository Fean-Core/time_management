# 🔐 Instruções de Teste - Sistema de Autenticação

## Como Testar o Login

O aplicativo agora possui um sistema de autenticação mock funcionando perfeitamente. Aqui estão as instruções para testar:

### 📱 Credenciais de Teste

Para testar o **LOGIN**, use qualquer uma das opções:

1. **Usuário Padrão:**
   - Email: `teste@email.com`
   - Senha: `123456`

2. **Qualquer Email Válido:**
   - Email: `qualquer.email@exemplo.com` (deve conter @)
   - Senha: `123456`

### 🆕 Teste de Registro

Para testar o **REGISTRO**, use qualquer dados:
- Nome: `Seu Nome`
- Email: `novo.usuario@teste.com`
- Senha: `123456`
- Confirmar senha: `123456`

**Nota:** O email `admin@teste.com` retornará erro de "email já cadastrado" para testar a validação.

### 🔄 Fluxo de Teste

1. **Inicie o aplicativo**
   - Você verá a tela de login

2. **Teste Login:**
   - Digite email e senha conforme acima
   - Clique em "Entrar"
   - Você deve ser redirecionado para o Dashboard

3. **Teste Registro:**
   - Na tela de login, clique em "Registre-se"
   - Preencha os dados de registro
   - Clique em "Criar Conta"
   - Você deve ser redirecionado automaticamente para o Dashboard

4. **Teste Logout:**
   - No Dashboard, abra o menu lateral (drawer)
   - Clique em "Sair"
   - Confirme o logout
   - Você deve voltar para a tela de login

5. **Teste Navegação:**
   - Use o bottom navigation para alternar entre as telas
   - Use o drawer para acessar opções do usuário

### ⚡ Funcionalidades Implementadas

- ✅ **Login com validação**
- ✅ **Registro de usuário**
- ✅ **Gestão de sessão**
- ✅ **Logout manual**
- ✅ **Interface responsiva**
- ✅ **Validação de formulários**
- ✅ **Tratamento de erros**
- ✅ **Loading states**

### 🛠️ Dados Mock

O sistema está configurado com dados mock para funcionar sem backend:

- **Delay de rede simulado:** 1 segundo para login/registro
- **Token JWT mock:** Gerado automaticamente
- **Preferências padrão:** Configuradas automaticamente
- **Persistência:** Usando SharedPreferences

### 🚀 Próximos Passos

1. **Integração com Backend Real:**
   - Altere `_useMockData = false` no AuthService
   - Configure a URL da API real
   - Implemente endpoints correspondentes

2. **Melhorias:**
   - Esqueci minha senha
   - Validação de email em tempo real
   - Foto de perfil
   - Configurações de usuário

### 📱 Execução

Para executar o app:

```bash
# No terminal
flutter run

# Ou para web
flutter run -d chrome
```

### 🐛 Solução de Problemas

Se o login não funcionar:
1. Verifique se está usando a senha `123456`
2. Verifique se o email contém `@`
3. Aguarde o loading aparecer e desaparecer
4. Verifique o console para erros

---

**🎉 O sistema de autenticação está totalmente funcional e pronto para uso!**
