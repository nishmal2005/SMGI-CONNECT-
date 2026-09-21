import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/features/api/provider/api_provider.dart';

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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      timeLabel: json['created_at']?.toString() ?? '',
      type: _typeFromString(json['notif_type']?.toString()),
    );
  }

  static NotificationType _typeFromString(String? value) {
    return NotificationType.values.firstWhere(
      (type) => type.name == value?.toLowerCase(),
      orElse: () => NotificationType.info,
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApiProvider>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ApiProvider>();
    final notifications = _notificationsFrom(provider.response?.data);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.orange),
              ),
              const SizedBox(height: 12),
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              if (provider.isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.errorMessage != null)
                Expanded(child: Center(child: Text(provider.errorMessage!)))
              else
                Expanded(
                  child: notifications.isEmpty
                      ? const Center(child: Text('No notifications yet.'))
                      : ListView.separated(
                          itemCount: notifications.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _NotificationCard(item: notifications[index]),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<NotificationModel> _notificationsFrom(dynamic data) {
    final rawItems = data is List
        ? data
        : data is Map && data['results'] is List
        ? data['results'] as List
        : data is Map && data['notifications'] is List
        ? data['notifications'] as List
        : const [];
    return rawItems
        .whereType<Map>()
        .map(
          (item) => NotificationModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final visuals = _iconFor(item.type);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: visuals.color,
            child: Icon(visuals.icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      item.timeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ({IconData icon, Color color}) _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return (icon: Icons.check, color: Colors.green);
      case NotificationType.pending:
        return (icon: Icons.more_horiz, color: Colors.amber.shade700);
      case NotificationType.reupload:
        return (icon: Icons.refresh, color: Colors.blue);
      case NotificationType.action:
        return (icon: Icons.flag, color: Colors.orange);
      case NotificationType.info:
        return (icon: Icons.check, color: Colors.teal);
    }
  }
}
