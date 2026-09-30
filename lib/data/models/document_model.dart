enum DocumentStatus { verified, pending, rejected, reupload }

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

  bool get canReupload =>
      status == DocumentStatus.reupload ||
      status == DocumentStatus.rejected;

  /// True for rows the backend identifies as Aadhaar.
  bool get isAadhaar {
    final t = (documentType.isEmpty ? title : documentType).toLowerCase();
    return t.contains('aadhaar') || t.contains('aadhar');
  }

  /// "front" | "back" | "" — derived from title/type when present.
  String get side {
    final t = '${documentType.isEmpty ? title : documentType}'.toLowerCase();
    if (t.contains('front')) return 'front';
    if (t.contains('back')) return 'back';
    return '';
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    final title = (json['name'] ?? json['title'] ?? '').toString();
    final docType = (json['document_type'] ?? json['type'] ?? '').toString();

    return DocumentModel(
      id: json['id']?.toString() ?? '',
      title: title.isEmpty ? docType : title,
      documentType: docType.isEmpty ? _slugFromTitle(title) : docType,
      fileUrl: json['file_url']?.toString(),
      image: json['image']?.toString() ?? _assetFor(title.isEmpty ? docType : title),
      status: _statusFrom(json['status']?.toString()),
    );
  }

  static DocumentStatus _statusFrom(String? v) {
    switch (v?.toLowerCase().replaceAll('_', '')) {
      case 'verified':
      case 'approved':
        return DocumentStatus.verified;
      case 'rejected':
        return DocumentStatus.rejected;
      case 'reupload':
      case 'reuploadrequired':
      case 'reuploadneeded':
        return DocumentStatus.reupload;
      case 'pending':
      case 'inreview':
      case 'underreview':
      default:
        return DocumentStatus.pending;
    }
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