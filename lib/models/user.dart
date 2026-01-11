class User {
  final int? id;
  final String username;
  final String password;
  final String fullName;
  final String role; // 'owner' or 'staff'
  final DateTime createdAt;
  final bool isActive;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.role,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert User to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  // Create User from Map (database query result)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      fullName: map['fullName'],
      role: map['role'],
      createdAt: DateTime.parse(map['createdAt']),
      isActive: map['isActive'] == 1,
    );
  }

  // Copy with method for updates
  User copyWith({
    int? id,
    String? username,
    String? password,
    String? fullName,
    String? role,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isOwner => role == 'owner';
  bool get isStaff => role == 'staff';
}