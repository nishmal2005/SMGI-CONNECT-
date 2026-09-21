enum DocumentStatus { verified, pending, rejected, reupload }

class DocumentItem {
  final String title;
  final String image;
  final DocumentStatus status;

  DocumentItem({
    required this.title,
    required this.image,
    required this.status,
  });
}
