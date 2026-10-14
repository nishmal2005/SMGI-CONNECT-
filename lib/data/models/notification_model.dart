// lib/data/models/notification_model.dart

enum NotificationType { success, pending, reupload, action, info }

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime? createdAt;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['id'] ?? '').toString(),
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      type: _typeFrom(json['notif_type']?.toString() ?? json['type']?.toString()),
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      isRead: json['is_read'] == true || json['read'] == true,
    );
  }

  /// Returns a copy with a different [isRead].
  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        message: message,
        type: type,
        createdAt: createdAt,
        isRead: isRead ?? this.isRead,
      );

  String get timeLabel {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(createdAt!);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final d = createdAt!;
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static NotificationType _typeFrom(String? v) {
    final s = (v ?? '').toLowerCase();
    switch (s) {
      case 'success':
      case 'approved':
      case 'completed':
      case 'payment_success':
        return NotificationType.success;
      case 'pending':
      case 'in_progress':
        return NotificationType.pending;
      case 'reupload':
      case 'reupload_required':
      case 'document_rejected':
        return NotificationType.reupload;
      case 'action':
      case 'action_required':
        return NotificationType.action;
      default:
        return NotificationType.info;
    }
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }
}