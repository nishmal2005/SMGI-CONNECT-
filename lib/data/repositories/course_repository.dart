import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class CourseRepository {
  CourseRepository(this._client);
  final ApiClient _client;

  Future<ApiResponse> list() async =>
      ApiResponse(await _client.get(ApiEndpoints.courses));

  Future<ApiResponse> details(String id) async =>
      ApiResponse(await _client.get(ApiEndpoints.course(id)));
}