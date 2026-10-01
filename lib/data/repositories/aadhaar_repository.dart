import 'dart:io';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class AadhaarRepository {
  AadhaarRepository(this._client);
  final ApiClient _client;

  /// GET /aadhaar/ — current Aadhaar status.
  Future<ApiResponse> status() async =>
      ApiResponse(await _client.get(ApiEndpoints.aadhaar));

  /// POST /aadhaar/upload/  (multipart)
  ///
  /// fields:
  ///   aadhaar_number — 12 digits
  ///   aadhaar_front  — front image
  ///   aadhaar_back   — back image
  Future<ApiResponse> upload({
    required String aadhaarNumber,
    required File front,
    required File back,
  }) async =>
      ApiResponse(await _client.multipart(
        ApiEndpoints.aadhaarUpload,
        fields: {'aadhaar_number': aadhaarNumber},
        files: {
          'aadhaar_front': front,
          'aadhaar_back': back,
        },
      ));

  /// PATCH /aadhaar/ — re-upload one side.
  ///
  /// fields:
  ///   side — "front" or "back"
  ///   file — the new image
  Future<ApiResponse> reuploadSide({
    required String side,
    required File file,
  }) async =>
      ApiResponse(await _client.multipart(
        ApiEndpoints.aadhaar,
        fields: {'side': side},
        files: {'file': file},
        method: 'PATCH',
      ));
}