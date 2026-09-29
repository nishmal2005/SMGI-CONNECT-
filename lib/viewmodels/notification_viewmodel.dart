import 'package:flutter/foundation.dart';
import 'package:smgi.connect/core/network/api_exception.dart';
import 'package:smgi.connect/data/models/notification_model.dart';
import 'package:smgi.connect/data/repositories/notification_repository.dart';



class NotificationViewModel extends ChangeNotifier {
  NotificationViewModel(this._repo);
  final NotificationRepository _repo;

  bool isLoading = false;
  String? errorMessage;
  List<NotificationModel> items = const [];

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
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}