enum DocumentStatus { verified, pending, rejected, reupload }

class DocumentModel {
  final String id;
  final String title;
  final String image;
  final DocumentStatus status;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.image,
    required this.status,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        image: json['image']?.toString() ?? 'assets/images/adharimg.png',
        status: _statusFrom(json['status']?.toString()),
      );

  static DocumentStatus _statusFrom(String? v) {
    switch (v?.toLowerCase()) {
      case 'verified':
        return DocumentStatus.verified;
      case 'pending':
        return DocumentStatus.pending;
      case 'rejected':
        return DocumentStatus.rejected;
      case 'reupload':
        return DocumentStatus.reupload;
      default:
        return DocumentStatus.pending;
    }
  }
}