import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class DocumentRepository {
  DocumentRepository(this._client);
  final ApiClient _client;

  Future<ApiResponse> list() async =>
      ApiResponse(await _client.get(ApiEndpoints.documents));

  Future<ApiResponse> upload(Map<String, dynamic> body) async =>
      ApiResponse(await _client.post(ApiEndpoints.documents, body: body));

  Future<ApiResponse> details(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.document(id)));
}