class ActivityLogModel {
  final int? id;
  final String action;
  final String staffName;
  final String? orderId;
  final String? details;
  final DateTime createdAt;

  ActivityLogModel({
    this.id,
    required this.action,
    required this.staffName,
    this.orderId,
    this.details,
    required this.createdAt,
  });

  /// Factory constructor to create ActivityLogModel from Supabase map
  factory ActivityLogModel.fromMap(Map<String, dynamic> map) {
    return ActivityLogModel(
      id: map['id'],
      action: map['action'],
      staffName: map['staff_name'],
      orderId: map['order_id'],
      details: map['details'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  /// Convert ActivityLogModel to a map for Supabase insert/update
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'action': action,
      'staff_name': staffName,
      'order_id': orderId,
      'details': details,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// ✅ Getter to format the createdAt for UI display
  String get formattedTime {
    // Example format: "11/01/2026 14:35"
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
