# Especificação OpenAPI 3.0 - Time Management API

## Visão Geral

Este documento apresenta a especificação OpenAPI 3.0 completa para a API do aplicativo de gestão de tempo. O arquivo `openapi.yaml` contém todos os endpoints, schemas e exemplos necessários para atualizar o backend Spring Boot.

## Estrutura da API

### 🔐 Autenticação
- **POST** `/auth/login` - Login do usuário
- **POST** `/auth/register` - Registro de novo usuário  
- **POST** `/auth/refresh` - Renovar token JWT
- **POST** `/auth/logout` - Logout do usuário

### 📋 Tarefas (Tasks)
- **GET** `/tasks` - Listar tarefas (com filtros opcionais)
- **POST** `/tasks` - Criar nova tarefa
- **GET** `/tasks/{id}` - Obter tarefa por ID
- **PUT** `/tasks/{id}` - Atualizar tarefa
- **DELETE** `/tasks/{id}` - Deletar tarefa
- **PATCH** `/tasks/{id}/toggle` - Alternar status da tarefa

### ⏱️ Registros de Tempo (Time Entries)
- **GET** `/time-entries` - Listar registros de tempo (com filtros)
- **POST** `/time-entries` - Criar novo registro de tempo
- **GET** `/time-entries/{id}` - Obter registro por ID
- **PUT** `/time-entries/{id}` - Atualizar registro de tempo
- **DELETE** `/time-entries/{id}` - Deletar registro de tempo
- **POST** `/time-entries/start` - Iniciar timer
- **PATCH** `/time-entries/stop/{id}` - Parar timer
- **GET** `/time-entries/active` - Obter timer ativo

### 🏷️ Categorias (Categories)
- **GET** `/categories` - Listar categorias
- **POST** `/categories` - Criar nova categoria
- **GET** `/categories/{id}` - Obter categoria por ID
- **PUT** `/categories/{id}` - Atualizar categoria
- **DELETE** `/categories/{id}` - Deletar categoria

### 👤 Usuários (Users)
- **GET** `/users/profile` - Obter perfil do usuário
- **PUT** `/users/profile` - Atualizar perfil do usuário

### 📊 Analytics
- **GET** `/analytics/time-summary` - Resumo de tempo trabalhado
- **GET** `/analytics/productivity` - Relatório de produtividade

## Principais Modelos de Dados

### Task (Tarefa)
```json
{
  "id": "string (uuid)",
  "title": "string (required)",
  "description": "string (optional)",
  "priority": "LOW|MEDIUM|HIGH (required)",
  "status": "PENDING|IN_PROGRESS|COMPLETED (required)",
  "dueDate": "string (date-time, optional)",
  "estimatedTime": "integer (minutes, optional)",
  "categoryId": "string (uuid, optional)",
  "userId": "string (uuid, required)",
  "createdAt": "string (date-time, required)",
  "updatedAt": "string (date-time, required)"
}
```

### TimeEntry (Registro de Tempo)
```json
{
  "id": "string (uuid)",
  "taskId": "string (uuid, required)",
  "userId": "string (uuid, required)",
  "startTime": "string (date-time, required)",
  "endTime": "string (date-time, optional - null se ativo)",
  "duration": "integer (seconds, optional - calculado)",
  "description": "string (optional)",
  "createdAt": "string (date-time, required)",
  "updatedAt": "string (date-time, required)"
}
```

### Category (Categoria)
```json
{
  "id": "string (uuid)",
  "name": "string (required)",
  "color": "string (hex color, required)",
  "description": "string (optional)",
  "userId": "string (uuid, required)",
  "createdAt": "string (date-time, required)",
  "updatedAt": "string (date-time, required)"
}
```

### User (Usuário)
```json
{
  "id": "string (uuid)",
  "name": "string (required)",
  "email": "string (email, required)",
  "profileImageUrl": "string (uri, optional)",
  "createdAt": "string (date-time, required)",
  "preferences": {
    "enableNotifications": "boolean",
    "reminderMinutesBefore": "integer",
    "timeFormat": "12h|24h",
    "dateFormat": "string",
    "enableSounds": "boolean"
  }
}
```

## DTOs Principais

### CreateTaskRequest
```json
{
  "title": "string (required)",
  "description": "string (optional)",
  "priority": "LOW|MEDIUM|HIGH (required)",
  "dueDate": "string (date-time, optional)",
  "estimatedTime": "integer (optional)",
  "categoryId": "string (uuid, optional)"
}
```

### UpdateTaskRequest
```json
{
  "title": "string (optional)",
  "description": "string (optional)",
  "priority": "LOW|MEDIUM|HIGH (optional)",
  "status": "PENDING|IN_PROGRESS|COMPLETED (optional)",
  "dueDate": "string (date-time, optional)",
  "estimatedTime": "integer (optional)",
  "categoryId": "string (uuid, optional)"
}
```

### CreateTimeEntryRequest
```json
{
  "taskId": "string (uuid, required)",
  "description": "string (optional)",
  "startTime": "string (date-time, optional - default now)",
  "endTime": "string (date-time, optional)",
  "duration": "integer (seconds, optional)"
}
```

### StartTimerRequest
```json
{
  "taskId": "string (uuid, required)",
  "description": "string (optional)"
}
```

## Códigos de Status HTTP

### Sucesso
- **200** - OK (operação bem-sucedida)
- **201** - Created (recurso criado)
- **204** - No Content (operação bem-sucedida sem retorno)

### Erro do Cliente
- **400** - Bad Request (dados inválidos)
- **401** - Unauthorized (não autenticado)
- **404** - Not Found (recurso não encontrado)
- **409** - Conflict (conflito - email já existe, timer já ativo, etc.)

### Erro do Servidor
- **500** - Internal Server Error

## Autenticação e Segurança

### JWT Bearer Token
- Todos os endpoints (exceto `/auth/login` e `/auth/register`) requerem autenticação
- Token deve ser enviado no header: `Authorization: Bearer <token>`
- Token contém informações do usuário (ID, email)

### Estrutura do Token
```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "iat": 1625097600,
  "exp": 1625184000
}
```

## Filtros e Parâmetros de Query

### Tasks
- `status` - Filtrar por status (PENDING, IN_PROGRESS, COMPLETED)
- `priority` - Filtrar por prioridade (LOW, MEDIUM, HIGH)
- `categoryId` - Filtrar por categoria

### Time Entries
- `taskId` - Filtrar por tarefa específica
- `startDate` - Data de início para filtro
- `endDate` - Data de fim para filtro

### Analytics
- `startDate` e `endDate` - Período para análise
- `groupBy` - Agrupar por dia, semana ou mês
- `period` - Período predefinido (week, month, quarter, year)

## Funcionalidades Especiais

### Timer Ativo
- Apenas um timer pode estar ativo por usuário
- Timer ativo tem `endTime = null` e `duration = null`
- Endpoint `/time-entries/active` retorna o timer atual

### Toggle Task Status
- Endpoint `/tasks/{id}/toggle` alterna entre PENDING ↔ COMPLETED
- Se status for IN_PROGRESS, muda para COMPLETED

### Relatórios de Produtividade
- Métricas incluem: total de tarefas, taxa de conclusão, tempo total
- Trends comparam período atual com anterior
- Score de produtividade de 0-100

## Validações Importantes

### Task
- `title` é obrigatório (1-255 caracteres)
- `priority` deve ser LOW, MEDIUM ou HIGH
- `estimatedTime` em minutos (≥ 0)

### TimeEntry
- `taskId` deve existir e pertencer ao usuário
- `startTime` obrigatório
- `duration` calculado automaticamente se não fornecido
- Apenas um timer ativo por usuário

### Category
- `name` obrigatório (1-100 caracteres)
- `color` deve ser hex válido (#RRGGBB)
- Não pode deletar categoria em uso

### User
- `email` deve ser único
- `password` mínimo 6 caracteres
- `name` mínimo 2 caracteres

## Como Usar a Especificação

1. **Validação**: O arquivo `openapi.yaml` foi validado e está em formato OAS 3.0 correto
2. **Geração de Código**: Use ferramentas como Swagger Codegen para gerar controllers Spring Boot
3. **Documentação**: Importe no Swagger UI para visualização interativa
4. **Testes**: Use para gerar testes automatizados da API

## Próximos Passos

1. ✅ Especificação OpenAPI criada e validada
2. 🔄 Atualizar controllers Spring Boot baseados na especificação
3. 🔄 Implementar validações de entrada conforme schemas
4. 🔄 Configurar serialização/deserialização JSON
5. 🔄 Testar todos os endpoints contra a especificação
6. 🔄 Configurar CORS para o frontend Flutter
7. 🔄 Implementar tratamento de erros padronizado

## Arquivo Principal

O arquivo `openapi.yaml` na raiz do projeto contém a especificação completa e está pronto para ser usado com:
- Spring Boot com SpringDoc OpenAPI
- Swagger UI para documentação
- Postman para testes
- Ferramentas de geração de código
