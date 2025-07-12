# 📋 Time Management App - Resumo Completo dos Services

## 🔧 Visão Geral da Arquitetura de Services

O aplicativo possui 5 services principais que se comunicam com a API backend Spring Boot através do `ApiService` (baseado em Dio). Todos os services seguem o padrão RESTful e utilizam DTOs para entrada e modelos para resposta.

---

## 🔐 1. AuthService

### **Base URL**: `/api/auth`

#### **LOGIN**
- **Endpoint**: `POST /api/auth/login`
- **Entrada**: 
  ```dart
  {
    "email": String,
    "password": String
  }
  ```
- **Resposta**: 
  ```dart
  {
    "token": String,
    "user": {
      "id": String,
      "name": String,
      "email": String,
      "avatar": String?,
      "createdAt": DateTime,
      "preferences": Map<String, dynamic>?
    }
  }
  ```

#### **REGISTER**
- **Endpoint**: `POST /api/auth/register`
- **Entrada**: 
  ```dart
  {
    "name": String,
    "email": String,
    "password": String
  }
  ```
- **Resposta**: 
  ```dart
  {
    "token": String,
    "user": User // mesmo formato do login
  }
  ```

#### **REFRESH TOKEN**
- **Endpoint**: `POST /api/auth/refresh`
- **Entrada**: Token no header Authorization
- **Resposta**: 
  ```dart
  {
    "token": String,
    "user": User
  }
  ```

#### **LOGOUT**
- **Endpoint**: `POST /api/auth/logout`
- **Entrada**: Token no header Authorization
- **Resposta**: `void` (status 200)

---

## 📂 2. CategoryService

### **Base URL**: `/api/categories`

#### **GET ALL CATEGORIES**
- **Endpoint**: `GET /api/categories`
- **Entrada**: Token no header (automático)
- **Resposta**: 
  ```dart
  List<Category> // Array de categorias do usuário
  [
    {
      "id": String,
      "name": String,
      "color": String,
      "description": String?,
      "userId": String,
      "createdAt": DateTime,
      "updatedAt": DateTime
    }
  ]
  ```

#### **GET CATEGORY BY ID**
- **Endpoint**: `GET /api/categories/{id}`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `Category` (objeto único)

#### **CREATE CATEGORY**
- **Endpoint**: `POST /api/categories`
- **Entrada**: 
  ```dart
  CreateCategoryRequest {
    "name": String,
    "color": String,
    "description": String? // opcional
  }
  ```
- **Resposta**: `Category` (categoria criada com ID gerado)

#### **UPDATE CATEGORY**
- **Endpoint**: `PUT /api/categories/{id}`
- **Entrada**: 
  ```dart
  UpdateCategoryRequest {
    "name": String?, // opcional
    "color": String?, // opcional  
    "description": String? // opcional
  }
  ```
- **Resposta**: `Category` (categoria atualizada)

#### **DELETE CATEGORY**
- **Endpoint**: `DELETE /api/categories/{id}`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `void` (status 200)

#### **GET MOST USED CATEGORIES**
- **Endpoint**: `GET /api/categories/most-used?limit={limit}`
- **Entrada**: `limit` (int, default: 5) como query parameter
- **Resposta**: `List<Category>` (categorias mais usadas)

#### **CAN DELETE CATEGORY**
- **Endpoint**: `GET /api/categories/{id}/can-delete`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: 
  ```dart
  {
    "canDelete": boolean
  }
  ```

---

## 📋 3. TaskService

### **Base URL**: `/api/tasks`

#### **GET ALL TASKS**
- **Endpoint**: `GET /api/tasks`
- **Entrada**: Query parameters opcionais:
  ```dart
  {
    "status": String?, // "PENDING", "IN_PROGRESS", "COMPLETED"
    "priority": String?, // "LOW", "MEDIUM", "HIGH"
    "categoryId": String?
  }
  ```
- **Resposta**: 
  ```dart
  List<Task> // Array de tarefas do usuário
  [
    {
      "id": String,
      "title": String,
      "description": String?,
      "priority": TaskPriority,
      "status": TaskStatus,
      "dueDate": DateTime?,
      "estimatedTime": int?,
      "categoryId": String?,
      "userId": String,
      "createdAt": DateTime,
      "updatedAt": DateTime
    }
  ]
  ```

#### **GET TASK BY ID**
- **Endpoint**: `GET /api/tasks/{id}`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `Task` (objeto único)

#### **CREATE TASK**
- **Endpoint**: `POST /api/tasks`
- **Entrada**: 
  ```dart
  CreateTaskRequest {
    "title": String,
    "description": String?, // opcional
    "priority": TaskPriority, // enum: LOW, MEDIUM, HIGH
    "dueDate": DateTime?, // opcional
    "estimatedTime": int?, // opcional (minutos)
    "categoryId": String? // opcional
  }
  ```
- **Resposta**: `Task` (tarefa criada com ID gerado)

#### **UPDATE TASK**
- **Endpoint**: `PUT /api/tasks/{id}`
- **Entrada**: 
  ```dart
  UpdateTaskRequest {
    "title": String?, // opcional
    "description": String?, // opcional
    "priority": TaskPriority?, // opcional
    "status": TaskStatus?, // opcional
    "dueDate": DateTime?, // opcional
    "estimatedTime": int?, // opcional
    "categoryId": String? // opcional
  }
  ```
- **Resposta**: `Task` (tarefa atualizada)

#### **DELETE TASK**
- **Endpoint**: `DELETE /api/tasks/{id}`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `void` (status 200)

#### **TOGGLE TASK COMPLETION**
- **Endpoint**: `PATCH /api/tasks/{id}/toggle`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `Task` (tarefa com status alternado)

#### **COMPLETE TASK**
- **Endpoint**: `PATCH /api/tasks/{id}/complete`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `Task` (tarefa marcada como concluída)

#### **GET OVERDUE TASKS**
- **Endpoint**: `GET /api/tasks/overdue`
- **Entrada**: Token no header (automático)
- **Resposta**: `List<Task>` (tarefas atrasadas)

#### **GET TODAY TASKS**
- **Endpoint**: `GET /api/tasks/today`
- **Entrada**: Token no header (automático)
- **Resposta**: `List<Task>` (tarefas com prazo hoje)

#### **GET TASKS STATS**
- **Endpoint**: `GET /api/tasks/stats`
- **Entrada**: Token no header (automático)
- **Resposta**: 
  ```dart
  {
    "total": int,
    "completed": int,
    "pending": int,
    "overdue": int,
    "completionRate": double,
    "byPriority": {
      "LOW": int,
      "MEDIUM": int,
      "HIGH": int
    },
    "byCategory": [
      {
        "categoryId": String,
        "categoryName": String,
        "count": int
      }
    ]
  }
  ```

---

## ⏱️ 4. TimeEntryService

### **Base URL**: `/api/time-entries`

#### **GET ALL TIME ENTRIES**
- **Endpoint**: `GET /api/time-entries`
- **Entrada**: Query parameters opcionais:
  ```dart
  {
    "taskId": String?,
    "startDate": DateTime?, // ISO string
    "endDate": DateTime? // ISO string
  }
  ```
- **Resposta**: 
  ```dart
  List<TimeEntry> // Array de registros de tempo
  [
    {
      "id": String,
      "taskId": String,
      "userId": String,
      "startTime": DateTime,
      "endTime": DateTime?,
      "duration": int?, // segundos
      "description": String?,
      "createdAt": DateTime,
      "updatedAt": DateTime
    }
  ]
  ```

#### **GET TIME ENTRY BY ID**
- **Endpoint**: `GET /api/time-entries/{id}`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `TimeEntry` (objeto único)

#### **CREATE TIME ENTRY**
- **Endpoint**: `POST /api/time-entries`
- **Entrada**: 
  ```dart
  CreateTimeEntryRequest {
    "taskId": String,
    "description": String?, // opcional
    "startTime": DateTime?, // opcional (default: now)
    "endTime": DateTime?, // opcional
    "duration": int? // opcional (segundos)
  }
  ```
- **Resposta**: `TimeEntry` (registro criado com ID gerado)

#### **UPDATE TIME ENTRY**
- **Endpoint**: `PUT /api/time-entries/{id}`
- **Entrada**: 
  ```dart
  UpdateTimeEntryRequest {
    "taskId": String?, // opcional
    "description": String?, // opcional
    "startTime": DateTime?, // opcional
    "endTime": DateTime?, // opcional
    "duration": int? // opcional
  }
  ```
- **Resposta**: `TimeEntry` (registro atualizado)

#### **DELETE TIME ENTRY**
- **Endpoint**: `DELETE /api/time-entries/{id}`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `void` (status 200)

#### **START TIMER**
- **Endpoint**: `POST /api/time-entries/start`
- **Entrada**: 
  ```dart
  StartTimerRequest {
    "taskId": String,
    "description": String? // opcional
  }
  ```
- **Resposta**: `TimeEntry` (registro de tempo iniciado, endTime = null)

#### **STOP TIMER**
- **Endpoint**: `POST /api/time-entries/{id}/stop`
- **Entrada**: `id` (String) como path parameter
- **Resposta**: `TimeEntry` (registro finalizado com endTime e duration calculados)

#### **GET CURRENT RUNNING TIMER**
- **Endpoint**: `GET /api/time-entries/running`
- **Entrada**: Token no header (automático)
- **Resposta**: `TimeEntry?` (registro em execução ou null)

#### **GET TODAY TIME ENTRIES**
- **Endpoint**: `GET /api/time-entries/today`
- **Entrada**: Token no header (automático)
- **Resposta**: `List<TimeEntry>` (registros de hoje)

#### **GET TOTAL TIME FOR TASK**
- **Endpoint**: `GET /api/time-entries/total-time/{taskId}`
- **Entrada**: `taskId` (String) como path parameter
- **Resposta**: 
  ```dart
  {
    "totalTime": int // segundos totais da tarefa
  }
  ```

#### **GET TIME STATS**
- **Endpoint**: `GET /api/time-entries/stats`
- **Entrada**: Query parameters opcionais:
  ```dart
  {
    "startDate": DateTime?, // ISO string
    "endDate": DateTime? // ISO string
  }
  ```
- **Resposta**: 
  ```dart
  {
    "totalTime": int, // segundos
    "totalEntries": int,
    "averagePerDay": double,
    "mostProductiveDay": String,
    "byTask": [
      {
        "taskId": String,
        "taskTitle": String,
        "totalTime": int,
        "percentage": double
      }
    ],
    "byCategory": [
      {
        "categoryId": String,
        "categoryName": String,
        "totalTime": int,
        "percentage": double
      }
    ],
    "dailyBreakdown": [
      {
        "date": String, // "2025-07-10"
        "totalTime": int,
        "entries": int
      }
    ]
  }
  ```

---

## 🌐 5. ApiService (Configuração Base)

### **Configurações Globais**

#### **Base URL**
```dart
static const String baseUrl = 'http://localhost:8080/api';
// Para Android Emulator: 'http://10.0.2.2:8080/api'
// Para IP da rede: 'http://192.168.x.x:8080/api'
// Para produção: 'https://sua-api.com/api'
```

#### **Headers Automáticos**
```dart
{
  'Content-Type': 'application/json',
  'Authorization': 'Bearer {token}' // adicionado automaticamente quando usuário logado
}
```

#### **Interceptors**
- **Request Interceptor**: Adiciona token automaticamente
- **Response Interceptor**: Trata erros globalmente (401, 403, 500, etc.)
- **Error Interceptor**: Formata mensagens de erro

---

## 🔄 Fluxo de Autenticação

### **Headers de Autorização**
Todos os endpoints (exceto login/register) requerem:
```dart
Authorization: Bearer {jwt_token}
```

### **Tratamento de Token**
- Token é armazenado automaticamente após login
- Token é adicionado automaticamente em todas as requisições
- Token expirado resulta em redirecionamento para login
- Refresh token é chamado automaticamente quando possível

---

## 📊 Códigos de Status HTTP Esperados

### **Sucesso**
- `200 OK` - Operação bem-sucedida
- `201 Created` - Recurso criado com sucesso
- `204 No Content` - Operação bem-sucedida sem conteúdo

### **Erro do Cliente**
- `400 Bad Request` - Dados inválidos
- `401 Unauthorized` - Token inválido/expirado
- `403 Forbidden` - Sem permissão
- `404 Not Found` - Recurso não encontrado
- `409 Conflict` - Conflito (ex: email já existe)

### **Erro do Servidor**
- `500 Internal Server Error` - Erro interno do servidor
- `503 Service Unavailable` - Serviço temporariamente indisponível

---

## 🛠️ Padrões de Erro

### **Formato de Resposta de Erro**
```dart
{
  "error": {
    "code": String, // código do erro
    "message": String, // mensagem amigável
    "details": String?, // detalhes técnicos (opcional)
    "timestamp": DateTime
  }
}
```

### **Tratamento nos Services**
Todos os services convertem erros HTTP em `Exception` com mensagens em português:
```dart
throw Exception('Erro ao buscar tarefas: $e');
```

---

## 📝 Notas Importantes

### **DTOs vs Models**
- **DTOs** (Data Transfer Objects): Usados para **enviar** dados para API
- **Models**: Usados para **receber** dados da API

### **Campos Obrigatórios vs Opcionais**
- Campos `required` no DTO = obrigatórios na API
- Campos opcionais (`?`) = podem ser omitidos

### **Datas**
- Todas as datas são enviadas/recebidas em formato ISO 8601
- Conversão automática entre `DateTime` e `String`

### **IDs**
- Todos os IDs são `String` (UUIDs)
- IDs são gerados pelo backend na criação

---

**🎯 Este resumo serve como documentação completa para integração entre o Flutter app e a API Spring Boot backend!**
