import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:smgi.connect/core/network/api_exception.dart';
import 'package:smgi.connect/data/models/document_model.dart';
import 'package:smgi.connect/data/repositories/document_repository.dart';



class DocumentViewModel extends ChangeNotifier {
  DocumentViewModel(this._repo);
  final DocumentRepository _repo;

  bool isLoading = false;
  bool isUploading = false;
  String? errorMessage;
  List<DocumentModel> items = const [];

  /// File picked but not yet uploaded — cleared on success or cancel.
  File? pendingFile;
  String? pendingTitle;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final res = await _repo.list();
      items = res.results
          .whereType<Map>()
          .map((e) => DocumentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void pickFile({
    required File file,
    required String title,
  }) {
    pendingFile = file;
    pendingTitle = title;
    notifyListeners();
  }

  void clearPending() {
    pendingFile = null;
    pendingTitle = null;
    notifyListeners();
  }

  /// Upload the pending document, then refresh the list.
  /// Body shape is a placeholder — adjust once the backend
  /// confirms what `/documents/` expects.
  Future<bool> uploadPending() async {
    if (pendingFile == null || pendingTitle == null) return false;

    isUploading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repo.upload({
        'title': pendingTitle,
        // Actual multipart upload will need `uploadMultipart` on ApiClient.
        // This stub just calls the JSON endpoint.
      });
      await load();
      clearPending();
      return true;
    } on ApiException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}