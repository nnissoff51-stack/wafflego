class ActivityLog {
  final int? id;
  final String staffName;
  final String orderId;
  final String action; // e.g., 'Order Created', 'Order Completed', 'Stock Updated'
  final DateTime timestamp;
  final String? details;

  ActivityLog({
    this.id,
    required this.staffName,
    required this.orderId,
    required this.action,
    DateTime? timestamp,
    this.details,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'staffName': staffName,
      'orderId': orderId,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
    };
  }

  // Create from Map
  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      id: map['id'],
      staffName: map['staffName'],
      orderId: map['orderId'],
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