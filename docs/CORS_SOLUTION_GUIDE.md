# 🚫 Erro de CORS - Soluções e Configurações

## 🐛 Problema Identificado

**Erro recebido:**
```
DioException [connection error]: The connection errored: The XMLHttpRequest onError callback was called. 
This typically indicates an error on the network layer.
```

**Diagnóstico:**
- Backend funciona via curl (HTTP 200)
- Flutter Web é bloqueado pelo navegador (CORS policy)
- XMLHttpRequest não pode fazer requisições cross-origin sem headers CORS adequados

## ✅ Soluções Implementadas no Frontend

### 1. **ApiService Atualizado**
- Headers CORS adicionados às requisições
- CorsInterceptor criado para detectar e tratar erros
- Configuração específica para Flutter Web

### 2. **Interceptor CORS**
```dart
class CorsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll({
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token, Authorization',
    });
    handler.next(options);
  }
}
```

## 🔧 Configuração Necessária no Backend Spring Boot

### 1. **Adicionar Dependência CORS (se não existe)**
```xml
<!-- pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

### 2. **Configuração Global de CORS**
Criar arquivo `CorsConfig.java`:

```java
package com.timemanagement.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.addAllowedOriginPattern("*");
        configuration.addAllowedMethod("*");
        configuration.addAllowedHeader("*");
        configuration.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/api/**", configuration);
        return source;
    }
}
```

### 3. **Configuração no Controller (Alternativa)**
```java
@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*", maxAge = 3600)
public class TimeEntryController {
    // ... métodos do controller
}
```

### 4. **Application.properties**
```properties
# CORS Configuration
spring.web.cors.allowed-origins=*
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS
spring.web.cors.allowed-headers=*
spring.web.cors.allow-credentials=true
```

## 🌐 Soluções Alternativas para Desenvolvimento

### 1. **Proxy Local (Recomendado para desenvolvimento)**
Criar arquivo `proxy.conf.json` na raiz do projeto Flutter:

```json
{
  "/api/*": {
    "target": "http://localhost:8080",
    "secure": false,
    "changeOrigin": true,
    "logLevel": "debug"
  }
}
```

Executar Flutter Web com proxy:
```bash
flutter run -d chrome --web-hostname localhost --web-port 3000
```

### 2. **Usar Flutter Desktop/Mobile**
```bash
# Executar no desktop (sem problemas de CORS)
flutter run -d windows
flutter run -d linux
flutter run -d macos

# Executar no mobile
flutter run -d android
flutter run -d ios
```

### 3. **Extensão do Chrome para Development**
Instalar "CORS Unblock" ou similar (apenas para desenvolvimento)

### 4. **Chrome com CORS Desabilitado (Dev Only)**
```bash
# Iniciar Chrome com CORS desabilitado (APENAS DESENVOLVIMENTO)
google-chrome --user-data-dir="/tmp/chrome_dev_test" --disable-web-security --disable-features=VizDisplayCompositor
```

## 🔍 Debug e Verificação

### 1. **Verificar Headers no Browser**
Abrir DevTools → Network → Ver requisições → Headers

### 2. **Testar CORS no Backend**
```bash
# Testar OPTIONS request
curl -i -X OPTIONS http://localhost:8080/api/time-entries \
  -H "Origin: http://localhost:3000" \
  -H "Access-Control-Request-Method: GET" \
  -H "Access-Control-Request-Headers: Authorization"
```

### 3. **Log de Debug no Backend**
```java
@RestController
public class TimeEntryController {
    
    @GetMapping("/time-entries")
    public ResponseEntity<List<TimeEntry>> getTimeEntries(HttpServletRequest request) {
        System.out.println("Origin: " + request.getHeader("Origin"));
        System.out.println("Method: " + request.getMethod());
        // ... lógica do controller
    }
}
```

## 📋 Checklist de Implementação

### Backend (Spring Boot):
- [ ] Adicionar configuração CORS global
- [ ] Verificar se está permitindo OPTIONS requests
- [ ] Configurar headers corretos
- [ ] Testar com curl/Postman
- [ ] Verificar logs de requisições

### Frontend (Flutter):
- [ ] ✅ Headers CORS adicionados no ApiService
- [ ] ✅ CorsInterceptor implementado
- [ ] ✅ Configuração específica para Web
- [ ] Testar em diferentes navegadores
- [ ] Verificar logs no DevTools

### Alternativos:
- [ ] Configurar proxy para desenvolvimento
- [ ] Testar no Flutter Desktop/Mobile
- [ ] Verificar extensões do navegador

## 🎯 Próximos Passos

1. **Implementar configuração CORS no backend Spring Boot**
2. **Testar com a configuração atualizada**
3. **Se ainda não funcionar, usar proxy local para desenvolvimento**
4. **Verificar logs tanto no frontend quanto no backend**

## ⚠️ Importante

CORS é uma proteção do navegador para requisições cross-origin. A solução **deve ser implementada no backend**, não no frontend. As alterações no frontend servem apenas para melhor debugging e tratamento de erros.

Para **produção**, sempre configure CORS adequadamente no backend com origins específicos, nunca use "*" em produção!
