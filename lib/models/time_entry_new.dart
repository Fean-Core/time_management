class TimeEntry {
  final String? id;
  final String taskId;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int? duration; // em segundos
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TimeEntry({
    this.id,
    required this.taskId,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.duration,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      taskId: json['taskId'] ?? '',
      userId: json['userId'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: json['duration'],
      description: json['description'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'taskId': taskId,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      if (endTime != null) 'endTime': endTime!.toIso8601String(),
      if (duration != null) 'duration': duration,
      if (description != null) 'description': description,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  // Getters de conveniência
  bool get isActive => endTime == null;
  bool get isRunning => isActive; // Alias para compatibilidade
  
  Duration get elapsedTime {
    if (duration != null) {
      return Duration(seconds: duration!);
    }
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  String get formattedDuration {
    final elapsed = elapsedTime;
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60);
    final seconds = elapsed.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  TimeEntry copyWith({
    String? id,
    String? taskId,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimeEntry(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
