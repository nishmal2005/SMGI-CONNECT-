import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class NotificationRepository {
  NotificationRepository(this._client);
  final ApiClient _client;

  Future<ApiResponse> list() async =>
      ApiResponse(await _client.get(ApiEndpoints.notifications));

  Future<ApiResponse> downloads() async =>
      ApiResponse(await _client.get(ApiEndpoints.knowledgeDownloads));

  Future<ApiResponse> downloadDocument(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.knowledgeDownload(id)));
}