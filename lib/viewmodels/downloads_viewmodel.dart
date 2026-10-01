import 'package:flutter/foundation.dart';
import 'package:smgi.connect/core/network/api_exception.dart';
import 'package:smgi.connect/data/models/download_model.dart';
import 'package:smgi.connect/data/repositories/notification_repository.dart';

class DownloadsViewModel extends ChangeNotifier {
  DownloadsViewModel(this._repo);
  final NotificationRepository _repo;
  bool isLoading = false;
  String? errorMessage;
  List<DownloadModel> items = const [];

  /// GET /knowledge-downloads/
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.downloads();
      items = res.results
          .whereType<Map>()
          .map((e) => DownloadModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}