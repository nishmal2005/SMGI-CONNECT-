class DownloadModel {
  final String id;
  final String title;
  final String subtitle;
  final String? fileUrl;

  const DownloadModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.fileUrl,
  });

  factory DownloadModel.fromJson(Map<String, dynamic> json) => DownloadModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        subtitle: json['subtitle']?.toString() ??
            json['description']?.toString() ??
            '',
        fileUrl: json['file_url']?.toString() ??
            json['document_url']?.toString(),
      );
}