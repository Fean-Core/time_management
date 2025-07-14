# 📋 DTOs e Modelos - Especificação Detalhada

## 🔍 Visão Geral

Este documento detalha todos os **DTOs** (Data Transfer Objects) e **Models** utilizados na comunicação com a API backend.

---

## 📊 1. Task - Modelos e DTOs

### **Model: Task**
```dart
class Task {
  final String id;                    // UUID gerado pelo backend
  final String title;                 // Título da tarefa
  final String? description;          // Descrição opcional
  final TaskPriority priority;        // LOW, MEDIUM, HIGH
  final TaskStatus status;            // PENDING, IN_PROGRESS, COMPLETED
  final DateTime? dueDate;            // Data de vencimento opcional
  final int? estimatedTime;           // Tempo estimado em minutos
  final String? categoryId;           // ID da categoria (opcional)
  final String userId;                // ID do usuário proprietário
  final DateTime createdAt;           // Data de criação
  final DateTime updatedAt;           // Data da última atualização
  
  // Getters de conveniência
  bool get isCompleted => status == TaskStatus.completed;
  DateTime? get deadline => dueDate; // Alias para compatibilidade
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now()) && !isCompleted;
}
```

### **Enum: TaskPriority**
```dart
enum TaskPriority {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH');
  
  const TaskPriority(this.value);
  final String value;
}
```

### **Enum: TaskStatus**
```dart
enum TaskStatus {
  pending('PENDING'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');
  
  const TaskStatus(this.value);
  final String value;
}
```

### **DTO: CreateTaskRequest**
```dart
class CreateTaskRequest {
  final String title;                 // OBRIGATÓRIO
  final String? description;          // Opcional
  final TaskPriority priority;        // OBRIGATÓRIO (default: medium)
  final DateTime? dueDate;            // Opcional
  final int? estimatedTime;           // Opcional (em minutos)
  final String? categoryId;           // Opcional
  
  Map<String, dynamic> toJson() => {
    'title': title,
    'priority': priority.value,
    if (description != null) 'description': description,
    if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    if (estimatedTime != null) 'estimatedTime': estimatedTime,
    if (categoryId != null) 'categoryId': categoryId,
  };
}
```

### **DTO: UpdateTaskRequest**
```dart
class UpdateTaskRequest {
  final String? title;                // Opcional
  final String? description;          // Opcional
  final TaskPriority? priority;       // Opcional
  final TaskStatus? status;           // Opcional
  final DateTime? dueDate;            // Opcional
  final int? estimatedTime;           // Opcional
  final String? categoryId;           // Opcional
  
  Map<String, dynamic> toJson() => {
    // Inclui apenas campos não-null
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (priority != null) 'priority': priority!.value,
    if (status != null) 'status': status!.value,
    if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
    if (estimatedTime != null) 'estimatedTime': estimatedTime,
    if (categoryId != null) 'categoryId': categoryId,
  };
}
```

---

## ⏱️ 2. TimeEntry - Modelos e DTOs

### **Model: TimeEntry**
```dart
class TimeEntry {
  final String? id;                   // UUID gerado pelo backend
  final String taskId;                // ID da tarefa associada
  final String userId;                // ID do usuário proprietário
  final DateTime startTime;           // Horário de início
  final DateTime? endTime;            // Horário de fim (null = em execução)
  final int? duration;                // Duração em segundos
  final String? description;          // Descrição opcional
  final DateTime createdAt;           // Data de criação
  final DateTime updatedAt;           // Data da última atualização
  
  // Getters de conveniência
  bool get isRunning => endTime == null;
  String get formattedDuration => _formatDuration(duration ?? 0);
}
```

### **DTO: CreateTimeEntryRequest**
```dart
class CreateTimeEntryRequest {
  final String taskId;                // OBRIGATÓRIO
  final String? description;          // Opcional
  final DateTime? startTime;          // Opcional (default: now)
  final DateTime? endTime;            // Opcional
  final int? duration;                // Opcional (em segundos)
  
  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    if (description != null) 'description': description,
    if (startTime != null) 'startTime': startTime!.toIso8601String(),
    if (endTime != null) 'endTime': endTime!.toIso8601String(),
    if (duration != null) 'duration': duration,
  };
}
```

### **DTO: UpdateTimeEntryRequest**
```dart
class UpdateTimeEntryRequest {
  final String? taskId;               // Opcional
  final String? description;          // Opcional
  final DateTime? startTime;          // Opcional
  final DateTime? endTime;            // Opcional
  final int? duration;                // Opcional
  
  Map<String, dynamic> toJson() => {
    if (taskId != null) 'taskId': taskId,
    if (description != null) 'description': description,
    if (startTime != null) 'startTime': startTime!.toIso8601String(),
    if (endTime != null) 'endTime': endTime!.toIso8601String(),
    if (duration != null) 'duration': duration,
  };
}
```

### **DTO: StartTimerRequest**
```dart
class StartTimerRequest {
  final String taskId;                // OBRIGATÓRIO
  final String? description;          // Opcional
  
  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    if (description != null) 'description': description,
  };
}
```

---

## 📂 3. Category - Modelos e DTOs

### **Model: Category**
```dart
class Category {
  final String id;                    // UUID gerado pelo backend
  final String name;                  // Nome da categoria
  final String color;                 // Cor em HEX (ex: "#FF5722")
  final String? description;          // Descrição opcional
  final String userId;                // ID do usuário proprietário
  final DateTime createdAt;           // Data de criação
  final DateTime updatedAt;           // Data da última atualização
}
```

### **DTO: CreateCategoryRequest**
```dart
class CreateCategoryRequest {
  final String name;                  // OBRIGATÓRIO
  final String color;                 // OBRIGATÓRIO (HEX color)
  final String? description;          // Opcional
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color,
    if (description != null) 'description': description,
  };
}
```

### **DTO: UpdateCategoryRequest**
```dart
class UpdateCategoryRequest {
  final String? name;                 // Opcional
  final String? color;                // Opcional
  final String? description;          // Opcional
  
  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (color != null) 'color': color,
    if (description != null) 'description': description,
  };
}
```

---

## 👤 4. User - Modelo

### **Model: User**
```dart
class User {
  final String id;                    // UUID gerado pelo backend
  final String name;                  // Nome do usuário
  final String email;                 // Email único
  final String? profileImageUrl;      // URL da foto de perfil
  final DateTime createdAt;           // Data de criação da conta
  final UserPreferences? preferences; // Preferências do usuário
}
```

### **Model: UserPreferences**
```dart
class UserPreferences {
  final bool enableNotifications;     // Notificações habilitadas
  final int reminderMinutesBefore;    // Minutos antes para lembrete
  final String timeFormat;            // "12h" ou "24h"
  final String dateFormat;            // "dd/MM/yyyy", "MM/dd/yyyy", etc.
  final bool enableSounds;            // Sons habilitados
}
```

---

## 🔐 5. Auth - Requests e Responses

### **Login Request**
```dart
{
  "email": String,        // OBRIGATÓRIO - email válido
  "password": String      // OBRIGATÓRIO - mínimo 6 caracteres
}
```

### **Register Request**
```dart
{
  "name": String,         // OBRIGATÓRIO - mínimo 2 caracteres
  "email": String,        // OBRIGATÓRIO - email único
  "password": String      // OBRIGATÓRIO - mínimo 6 caracteres
}
```

### **Auth Response**
```dart
{
  "token": String,        // JWT token
  "user": User           // Objeto User completo
}
```

---

## 📊 6. Stats - Estruturas de Resposta

### **Task Stats Response**
```dart
{
  "total": int,                      // Total de tarefas
  "completed": int,                  // Tarefas concluídas
  "pending": int,                    // Tarefas pendentes
  "overdue": int,                    // Tarefas atrasadas
  "completionRate": double,          // Taxa de conclusão (0.0 - 1.0)
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

### **Time Stats Response**
```dart
{
  "totalTime": int,                  // Tempo total em segundos
  "totalEntries": int,               // Total de registros
  "averagePerDay": double,           // Média por dia em segundos
  "mostProductiveDay": String,       // Dia mais produtivo
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
      "date": String,                // "2025-07-10"
      "totalTime": int,
      "entries": int
    }
  ]
}
```

---

## 🔧 7. Padrões e Convenções

### **Nomes de Campos**
- **camelCase** no Flutter/Dart
- **camelCase** no JSON (API)
- **snake_case** no banco de dados (se necessário)

### **Datas**
- Formato: **ISO 8601** (`2025-07-10T14:30:00Z`)
- Timezone: **UTC** (convertido automaticamente)
- Campos: `createdAt`, `updatedAt`, `dueDate`, `startTime`, `endTime`

### **IDs**
- Formato: **UUID v4** (`123e4567-e89b-12d3-a456-426614174000`)
- Todos os IDs são **String**
- Gerados pelo backend

### **Cores**
- Formato: **HEX** (`#FF5722`, `#2196F3`)
- Sempre com **#** no início
- 6 dígitos hexadecimais

### **Enums**
- Valores em **UPPER_CASE** na API
- Conversão automática entre Dart e JSON

### **Campos Opcionais**
- Marcados com **?** no Dart
- Podem ser **null** ou omitidos no JSON
- Validação no backend e frontend

---

## ⚠️ Validações e Restrições

### **Tarefas**
- `title`: mínimo 1, máximo 255 caracteres
- `description`: máximo 1000 caracteres
- `estimatedTime`: mínimo 1 minuto, máximo 24 horas
- `dueDate`: não pode ser no passado

### **Categorias**
- `name`: mínimo 1, máximo 50 caracteres
- `color`: formato HEX válido
- `description`: máximo 255 caracteres

### **Time Entries**
- `startTime`: não pode ser no futuro
- `endTime`: deve ser após `startTime`
- `duration`: calculado automaticamente se não fornecido

### **Usuários**
- `email`: formato válido e único
- `password`: mínimo 6 caracteres
- `name`: mínimo 2 caracteres

---

**🎯 Esta especificação garante consistência total entre Frontend Flutter e Backend Spring Boot!**
