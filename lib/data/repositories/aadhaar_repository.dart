import 'dart:io';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_response.dart';

class AadhaarRepository {
  AadhaarRepository(this._client);
  final ApiClient _client;

  // ── Initial upload (POST) ───────────────────────
  Future<ApiResponse> uploadFront({
    required String aadhaarNumber,
    required File file,
  }) async =>
      ApiResponse(await _client.multipart(
        ApiEndpoints.aadhaarFrontUpload,
        fields: {'aadhaar_number': aadhaarNumber},
        files: {'aadhaar_front': file},
      ));

  Future<ApiResponse> uploadBack({
    required String aadhaarNumber,
    required File file,
  }) async =>
      ApiResponse(await _client.multipart(
        ApiEndpoints.aadhaarBackUpload,
        fields: {'aadhaar_number': aadhaarNumber},
        files: {'aadhaar_back': file},
      ));

  // ── Reupload (PATCH) — backend expects the key `file` ──
  Future<ApiResponse> reuploadFront({
    required File file,
  }) async =>
      ApiResponse(await _client.multipart(
        ApiEndpoints.aadhaarFrontUpload,
        fields: const {},
        files: {'file': file},
        method: 'PATCH',
      ));

  Future<ApiResponse> reuploadBack({
    required File file,
  }) async =>
      ApiResponse(await _client.multipart(
        ApiEndpoints.aadhaarBackUpload,
        fields: const {},
        files: {'file': file},
        method: 'PATCH',
      ));
}