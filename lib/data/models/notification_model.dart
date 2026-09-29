enum NotificationType { success, pending, reupload, action, info }

class NotificationModel {
  final String title;
  final String message;
  final String timeLabel;
  final NotificationType type;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        title: json['title']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        timeLabel: json['created_at']?.toString() ?? '',
        type: _typeFrom(json['notif_type']?.toString()),
      );

  static NotificationType _typeFrom(String? v) =>
      NotificationType.values.firstWhere(
        (t) => t.name == v?.toLowerCase(),
        orElse: () => NotificationType.info,
      );
}