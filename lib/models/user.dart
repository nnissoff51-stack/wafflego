class UserModel {
  final int? id; // Nullable because new users may not have an ID yet
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String role; // e.g., 'owner', 'staff'
  final bool isActive;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.role,
    this.isActive = true,
  });

  /// Create UserModel from a Supabase row (Map)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'], // Must match your Supabase table column
      username: map['username'],
      password: map['password'],
      fullName: map['full_name'] ?? map['fullName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'staff',
      isActive: map['is_active'] ?? true,
    );
  }

  /// Convert UserModel to Map for inserting/updating Supabase
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'password': password,
      'full_name': fullName,
      'email': email,
      'role': role,
      'is_active': isActive,
    };
  }

  /// Create a copy of the user with updated fields
  UserModel copyWith({
    int? id,
    String? username,
    String? password,
    String? fullName,
    String? email,
    String? role,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }
}
