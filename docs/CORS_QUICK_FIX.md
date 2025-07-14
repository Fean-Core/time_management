# 🚀 CORS Quick Fix - Soluções Rápidas

## 🎯 Problema
Erro de CORS ao executar Flutter Web com backend Spring Boot local.

## ⚡ Soluções Rápidas

### 1. **SOLUÇÃO RECOMENDADA: Desktop Flutter**
```bash
# Execute sem problemas de CORS
flutter run -d linux
```

### 2. **Para desenvolvimento Web: Chrome com CORS desabilitado**
```bash
# Feche todas as janelas do Chrome primeiro
pkill chrome

# Execute o Chrome sem segurança CORS (APENAS PARA DESENVOLVIMENTO!)
google-chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --disable-features=VizDisplayCompositor
# OU
chromium --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --disable-features=VizDisplayCompositor

# Depois execute o Flutter Web
flutter run -d chrome
```

### 3. **Script Automático**
```bash
# Use o script fornecido
chmod +x run_app.sh
./run_app.sh
# Escolha opção 1 (Desktop) ou 4 (Chrome sem CORS)
```

## 🔧 Configuração Backend Spring Boot

Se você controla o backend, adicione esta classe:

```java
// CorsConfig.java
@Configuration
@EnableWebMvc
public class CorsConfig implements WebMvcConfigurer {
    
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:*") // Para desenvolvimento
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
```

## 🎭 Verificação Rápida

### Teste se o backend está funcionando:
```bash
curl -X GET http://localhost:8080/api/tasks \
  -H "Content-Type: application/json"
```

### Se retornar dados = backend OK, problema é CORS
### Se retornar erro = backend não está rodando

## 🚨 IMPORTANTE
- NUNCA desabilite CORS em produção
- Use Chrome sem segurança APENAS para desenvolvimento
- Solução definitiva: configurar CORS no backend
- Desktop Flutter não tem problemas de CORS

## 📋 Checklist de Troubleshooting
- [ ] Backend rodando em http://localhost:8080
- [ ] Teste curl funciona
- [ ] Flutter run -d linux funciona
- [ ] Se Web necessário: Chrome configurado ou CORS no backend
