# 🚀 Como Resolver o Erro de CORS

## 🎯 Erro que você está vendo:
```
DioException [connection error]: The connection errored: 
The XMLHttpRequest onError callback was called.
```

## ✅ SOLUÇÕES RÁPIDAS (em ordem de preferência):

### 1. **MELHOR OPÇÃO: Desktop Flutter** ⭐
```bash
# Execute o script e escolha opção 1
./run_app.sh

# OU execute diretamente:
flutter run -d linux
```
**Por que funciona?** Desktop não tem limitações de CORS do navegador.

### 2. **Para desenvolvimento Web: Chrome sem CORS** 🔧
```bash
# Execute o script e escolha opção 4
./run_app.sh

# OU manualmente:
pkill chrome
google-chrome --disable-web-security --user-data-dir="/tmp/chrome_dev" &
flutter run -d chrome
```
**⚠️ APENAS para desenvolvimento!**

### 3. **Via VS Code** 🎮
- Pressione `F5` ou `Ctrl+F5`
- Escolha "🖥️ Flutter Desktop (Recomendado)"
- OU escolha "🔧 Flutter Web Debug (sem CORS)"

## 🔍 Verificando se o backend funciona:
```bash
# Teste o backend diretamente:
curl http://localhost:8080/api/tasks

# Se retornar dados ✅ = backend OK, problema é CORS
# Se retornar erro ❌ = backend não está rodando
```

## 🎭 O que é CORS?
CORS (Cross-Origin Resource Sharing) é uma política de segurança do navegador que bloqueia requisições entre domínios diferentes (ex: localhost:3000 → localhost:8080).

**Aplicações Desktop Flutter** não têm esse problema pois não usam navegador.

## 🛠️ Solução Definitiva (Backend Spring Boot):
Se você controla o backend, adicione esta configuração:

```java
@Configuration
@EnableWebMvc
public class CorsConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:*")
                .allowedMethods("*")
                .allowedHeaders("*");
    }
}
```

## 🚨 IMPORTANTE:
- ✅ Desktop Flutter = sem CORS, funciona sempre
- ⚠️ Web Flutter = precisa CORS configurado
- 🔧 Chrome sem segurança = apenas desenvolvimento
- 🚫 Nunca desabilite CORS em produção

## 📋 Checklist:
- [ ] Backend rodando? `curl http://localhost:8080/api/tasks`
- [ ] Testou desktop? `flutter run -d linux`
- [ ] Precisa web? Use script opção 4 ou configure CORS no backend

**Recomendação:** Use sempre Desktop Flutter para desenvolvimento!
