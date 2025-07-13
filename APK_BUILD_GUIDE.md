# 🚀 Guia de Build APK - Time Management App

## Problema Identificado
O APK não estava funcionando corretamente devido a problemas de configuração de rede no Android e timeouts inadequados para conexões móveis.

## ✅ Correções Aplicadas

### 1. Network Security Config
- ✅ Adicionado `network_security_config.xml`
- ✅ Configurado `android:networkSecurityConfig` no AndroidManifest
- ✅ Permitido tráfego HTTPS para o domínio de produção
- ✅ Adicionado `android:usesCleartextTraffic="true"`

### 2. Permissões Android
- ✅ `INTERNET` permission
- ✅ `ACCESS_NETWORK_STATE` permission

### 3. Configuração API Service
- ✅ Aumentado timeouts para 60 segundos (ideal para mobile)
- ✅ Adicionado `sendTimeout`
- ✅ Configurado User-Agent customizado
- ✅ Melhorado tratamento de erros com logs detalhados

### 4. Logs de Debug
- ✅ Logs detalhados no AuthService
- ✅ Identificação de tipos de erro de conexão
- ✅ Mensagens de erro específicas por tipo

## 📱 Como Gerar o APK Corrigido

### 1. Limpar Build Anterior
```bash
flutter clean
flutter pub get
```

### 2. Gerar APK Release
```bash
flutter build apk --release
```

### 3. Localizar APK
O APK estará em:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 4. Instalar no Celular
```bash
# Via ADB (se conectado via USB)
adb install build/app/outputs/flutter-apk/app-release.apk

# Ou transfira o arquivo manualmente para o celular
```

## 🔍 Debug no Celular

### Como Ver os Logs
1. Conecte o celular via USB
2. Ative o Debug USB
3. Execute: `adb logcat | grep flutter`

### Logs Esperados
- `🔐 Tentando login para: email@exemplo.com`
- `🌐 URL do backend: https://time-magagement-backend.onrender.com/api`
- `✅ Login response status: 200`

### Possíveis Erros e Soluções

#### Erro: "Timeout de conexão"
- **Causa**: Internet lenta ou instável
- **Solução**: Tentar em rede WiFi estável

#### Erro: "Erro de conexão"
- **Causa**: Backend offline ou DNS não resolvendo
- **Solução**: Verificar se o backend está online

#### Erro: "Certificado SSL inválido"
- **Causa**: Problemas com certificado HTTPS
- **Solução**: Verificar configuração SSL do backend

## 🎯 Próximos Passos

### Se Ainda Não Funcionar:
1. **Verificar Backend Online**:
   ```bash
   curl https://time-magagement-backend.onrender.com/api/health
   ```

2. **Testar Modo Debug**:
   ```bash
   flutter run --debug # Para ver logs em tempo real
   ```

3. **Fallback para Mock**:
   - Se necessário, alterar `_useMockData = true` temporariamente

## 📋 Checklist Final

- [ ] Backend em produção funcionando
- [ ] Network Security Config aplicado
- [ ] Timeouts aumentados para 60s
- [ ] Permissões de internet configuradas
- [ ] APK gerado com `flutter build apk --release`
- [ ] APK instalado no celular
- [ ] Logs verificados via `adb logcat`

## 🆘 Se Persistir o Problema

1. **Compartilhe os logs**:
   ```bash
   adb logcat | grep -E "(flutter|TimeManagement)" > logs.txt
   ```

2. **Verifique conectividade**:
   - Teste em WiFi e dados móveis
   - Verifique se outros apps acessam internet

3. **Teste modo debug**:
   ```bash
   flutter install # Instala debug version no celular
   ```

---

**✨ Com essas correções, o APK deve funcionar corretamente no celular!**
