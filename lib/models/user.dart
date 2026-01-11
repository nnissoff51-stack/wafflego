class UserModel {
  final String? id; // UUID from Supabase
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String role; // 'owner' or 'staff'
  final DateTime createdAt;
  final bool isActive;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.role,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert UserModel to Map for Supabase
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'password': password,
      'full_name': fullName,
      'email': email,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  // Create UserModel from Map (Supabase query result)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      fullName: map['full_name'],
      email: map['email'],
      role: map['role'],
      createdAt: DateTime.parse(map['created_at']),
      isActive: map['is_active'] ?? true,
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? id,
    String? username,
    String? password,
    String? fullName,
    String? email,
    String? role,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isOwner => role == 'owner';
  bool get isStaff => role == 'staff';
}