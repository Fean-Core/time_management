class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final DateTime createdAt;
  final UserPreferences preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.createdAt,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'preferences': preferences.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? createdAt,
    UserPreferences? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      preferences: preferences ?? this.preferences,
    );
  }
}

class UserPreferences {
  final bool enableNotifications;
  final int reminderMinutesBefore;
  final String timeFormat; // 12h or 24h
  final String dateFormat;
  final bool enableSounds;

  UserPreferences({
    required this.enableNotifications,
    required this.reminderMinutesBefore,
    required this.timeFormat,
    required this.dateFormat,
    required this.enableSounds,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      enableNotifications: json['enableNotifications'] ?? true,
      reminderMinutesBefore: json['reminderMinutesBefore'] ?? 15,
      timeFormat: json['timeFormat'] ?? '24h',
      dateFormat: json['dateFormat'] ?? 'dd/MM/yyyy',
      enableSounds: json['enableSounds'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enableNotifications': enableNotifications,
      'reminderMinutesBefore': reminderMinutesBefore,
      'timeFormat': timeFormat,
      'dateFormat': dateFormat,
      'enableSounds': enableSounds,
    };
  }

  UserPreferences copyWith({
    bool? enableNotifications,
    int? reminderMinutesBefore,
    String? timeFormat,
    String? dateFormat,
    bool? enableSounds,
  }) {
    return UserPreferences(
      enableNotifications: enableNotifications ?? this.enableNotifications,
      reminderMinutesBefore: reminderMinutesBefore ?? this.reminderMinutesBefore,
      timeFormat: timeFormat ?? this.timeFormat,
      dateFormat: dateFormat ?? this.dateFormat,
      enableSounds: enableSounds ?? this.enableSounds,
    );
  }
}
