enum TaskPriority {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH');

  const TaskPriority(this.value);
  final String value;

  static TaskPriority fromString(String value) {
    switch (value.toUpperCase()) {
      case 'LOW':
        return TaskPriority.low;
      case 'MEDIUM':
        return TaskPriority.medium;
      case 'HIGH':
        return TaskPriority.high;
      default:
        return TaskPriority.medium;
    }
  }
}

enum TaskStatus {
  pending('PENDING'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED');

  const TaskStatus(this.value);
  final String value;

  static TaskStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return TaskStatus.pending;
      case 'IN_PROGRESS':
        return TaskStatus.inProgress;
      case 'COMPLETED':
        return TaskStatus.completed;
      default:
        return TaskStatus.pending;
    }
  }
}

class Task {
  final String? id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final int? estimatedTime; // em minutos
  final String? categoryId;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.priority,
    required this.status,
    this.dueDate,
    this.estimatedTime,
    this.categoryId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      priority: TaskPriority.fromString(json['priority'] ?? 'MEDIUM'),
      status: TaskStatus.fromString(json['status'] ?? 'PENDING'),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      estimatedTime: json['estimatedTime'],
      categoryId: json['categoryId'],
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'priority': priority.value,
      'status': status.value,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      if (estimatedTime != null) 'estimatedTime': estimatedTime,
      if (categoryId != null) 'categoryId': categoryId,
      'userId': userId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // Getters de conveniência para compatibilidade
  bool get isCompleted => status == TaskStatus.completed;
  DateTime? get deadline => dueDate; // Alias para compatibilidade
  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now()) && !isCompleted;
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    return taskDate.isAtSameMomentAs(today);
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    int? estimatedTime,
    String? categoryId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// DTO para criação de tarefas conforme API
class CreateTaskRequest {
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime? dueDate;
  final int? estimatedTime;
  final String? categoryId;

  CreateTaskRequest({
    required this.title,
    this.description,
    required this.priority,
    this.dueDate,
    this.estimatedTime,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      'priority': priority.value,
      if (dueDate != null) 'dueDate': dueDate!.toIso8601String(),
      if (estimatedTime != null) 'estimatedTime': estimatedTime,
      if (categoryId != null) 'categoryId': categoryId,
    };
  }
}
