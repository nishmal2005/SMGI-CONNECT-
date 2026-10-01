import 'document_status.dart';

// Re-export so existing imports of document_model.dart keep
// seeing DocumentStatus / DocumentStatusX / parseDocumentStatus.
export 'document_status.dart';

class DocumentModel {
  final String id;
  final String title;
  final String documentType;
  final String? fileUrl;
  final String image;
  final DocumentStatus status;

  const DocumentModel({
    required this.id,
    required this.title,
    required this.documentType,
    required this.image,
    required this.status,
    this.fileUrl,
  });

  bool get canReupload => status.canReupload;

  bool get isAadhaar {
    final t = (documentType.isEmpty ? title : documentType).toLowerCase();
    return t.contains('aadhaar') || t.contains('aadhar');
  }

  String get side {
    final t = '${documentType.isEmpty ? title : documentType}'.toLowerCase();
    if (t.contains('front')) return 'front';
    if (t.contains('back')) return 'back';
    return '';
  }

  DocumentModel copyWith({
    String? id,
    String? title,
    String? documentType,
    String? fileUrl,
    String? image,
    DocumentStatus? status,
  }) =>
      DocumentModel(
        id: id ?? this.id,
        title: title ?? this.title,
        documentType: documentType ?? this.documentType,
        fileUrl: fileUrl ?? this.fileUrl,
        image: image ?? this.image,
        status: status ?? this.status,
      );

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    final root = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final title = (root['name'] ?? root['title'] ?? '').toString();
    final docType =
        (root['document_type'] ?? root['type'] ?? '').toString();

    return DocumentModel(
      id: root['id']?.toString() ?? '',
      title: title.isEmpty ? docType : title,
      documentType: docType.isEmpty ? _slugFromTitle(title) : docType,
      fileUrl: root['file_url']?.toString(),
      image: root['image']?.toString() ??
          _assetFor(title.isEmpty ? docType : title),
      status: parseDocumentStatus(root['status']?.toString()) ??
          DocumentStatus.pending,
    );
  }

  static String _assetFor(String title) {
    final t = title.toLowerCase();
    if (t.contains('aadhaar') || t.contains('aadhar')) {
      return 'assets/images/adharimg.png';
    }
    if (t.contains('marks') || t.contains('10th')) {
      return 'assets/images/marks.png';
    }
    if (t.contains('referral') || t.contains('qr')) {
      return 'assets/images/qr.png';
    }
    return 'assets/images/adharimg.png';
  }

  static String _slugFromTitle(String title) {
    final t = title.toLowerCase();
    if (t.contains('aadhaar') || t.contains('aadhar')) {
      if (t.contains('front')) return 'aadhaar_front';
      if (t.contains('back')) return 'aadhaar_back';
      return 'aadhaar_id_proof';
    }
    if (t.contains('marks') || t.contains('10th')) return 'tenth_marks_card';
    if (t.contains('referral')) return 'referral_code';
    return 'other_required';
  }
}