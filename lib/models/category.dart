class Category {
  final String id;
  final String name;
  final String color;
  final String? description;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.color,
    this.description,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '#007AFF',
      description: json['description'],
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? color,
    String? description,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, color: $color, userId: $userId)';
  }
}

// DTO para criação de categoria
class CreateCategoryRequest {
  final String name;
  final String color;
  final String? description;

  CreateCategoryRequest({
    required this.name,
    required this.color,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
      if (description != null) 'description': description,
    };
  }
}

// DTO para atualização de categoria
class UpdateCategoryRequest {
  final String? name;
  final String? color;
  final String? description;

  UpdateCategoryRequest({
    this.name,
    this.color,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (color != null) data['color'] = color;
    if (description != null) data['description'] = description;
    return data;
  }
}
