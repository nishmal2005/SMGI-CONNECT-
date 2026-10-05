import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../data/models/download_model.dart';
import '../data/repositories/notification_repository.dart';

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

      if (kDebugMode) {
        debugPrint('[DOWNLOADS] raw = ${res.data}');
      }

      items = res.results
          .whereType<Map>()
          .map((e) => DownloadModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      if (kDebugMode) {
        for (final d in items) {
          debugPrint(
            '[DOWNLOADS] id=${d.id} title="${d.title}" '
            'fileUrl=${d.fileUrl}',
          );
        }
      }
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}