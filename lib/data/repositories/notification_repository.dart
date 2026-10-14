// lib/data/repositories/notification_repository.dart

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class NotificationRepository {
  NotificationRepository(this._client);
  final ApiClient _client;

  // ── Notifications ────────────────────────────────────────

  /// GET /api/notifications/
  Future<ApiResponse> list() async =>
      ApiResponse(await _client.get(ApiEndpoints.notifications));

  /// POST /api/notifications/{id}/read/
  /// Marks a single notification as read.
  /// If your backend doesn't have this yet, the ViewModel
  /// swallows the error and keeps the optimistic local update.
  Future<void> markRead(String id) async {
    await _client.post('${ApiEndpoints.notifications}$id/read/');
  }

  /// POST /api/notifications/read-all/
  /// Marks every notification as read in one request.
  /// Optional — use only if your backend implements it.
  Future<void> markAllRead() async {
    await _client.post('${ApiEndpoints.notifications}read-all/');
  }

  // ── Downloads ────────────────────────────────────────────

  Future<ApiResponse> downloads() async =>
      ApiResponse(await _client.get(ApiEndpoints.knowledgeDownloads));

  Future<ApiResponse> downloadDocument(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.knowledgeDownload(id)));
}