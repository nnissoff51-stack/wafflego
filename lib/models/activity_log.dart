class ActivityLogModel {
  final String? id; // UUID from Supabase
  final String staffName;
  final String orderId;
  final String action; // e.g., 'Order Created', 'Order Completed', 'Stock Updated'
  final DateTime timestamp;
  final String? details;

  ActivityLogModel({
    this.id,
    required this.staffName,
    required this.orderId,
    required this.action,
    DateTime? timestamp,
    this.details,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to Map for Supabase
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'staff_name': staffName,
      'order_id': orderId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
    };
  }

  // Create from Map
  factory ActivityLogModel.fromMap(Map<String, dynamic> map) {
    return ActivityLogModel(
      id: map['id'],
      staffName: map['staff_name'],
      orderId: map['order_id'],
      action: map['action'],
      timestamp: DateTime.parse(map['timestamp']),
      details: map['details'],
    );
  }

  // Formatted timestamp for display
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}