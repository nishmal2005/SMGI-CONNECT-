// lib/viewmodels/notification_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:smgi_connect/core/network/api_exception.dart';
import 'package:smgi_connect/data/models/notification_model.dart';
import 'package:smgi_connect/data/repositories/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel(this._repo);
  final NotificationRepository _repo;

  bool isLoading = false;
  String? errorMessage;
  List<NotificationModel> items = const [];
   
  /// Number of unread notifications —   drives the bell badge.
  int get unreadCount => items.where((n) => !n.isRead).length;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _repo.list();
      items = res.results
          .whereType<Map>()
          .map((e) => NotificationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // Newest first.
      items.sort((a, b) {
        final da = a.createdAt ?? DateTime(1970);
        final db = b.createdAt ?? DateTime(1970);
        return db.compareTo(da);
      });

      debugPrint('NOTIFICATIONS → loaded ${items.length} '
          '(unread=$unreadCount)');
    } on ApiException catch (e) {
      debugPrint('NOTIFICATIONS failed: ${e.message} status=${e.statusCode}');
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Optimistically mark one item as read; sync with the backend after.
  Future<void> markRead(String id) async {
    final idx = items.indexWhere((n) => n.id == id);
    if (idx < 0 || items[idx].isRead) return;

    items = [...items]..[idx] = items[idx].copyWith(isRead: true);
    notifyListeners();

    try {
      await _repo.markRead(id);
    } on ApiException catch (e) {
      debugPrint('markRead failed: ${e.message}');
    }
  }

  /// Mark every unread item as read.
  Future<void> markAllRead() async {
    if (items.isEmpty || unreadCount == 0) return;

    final previous = items;
    items = items.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();

    try {
      for (final n in previous.where((n) => !n.isRead)) {
        await _repo.markRead(n.id);
      }
    } on ApiException catch (e) {
      debugPrint('markAllRead failed: ${e.message}');
      items = previous; // revert on error
      notifyListeners();
    }
  }
}