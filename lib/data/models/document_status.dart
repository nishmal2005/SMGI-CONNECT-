enum DocumentStatus { verified, pending, rejected, reupload }

extension DocumentStatusX on DocumentStatus {
  /// Admin is reviewing or already accepted → no re-upload allowed.
  bool get isLocked =>
      this == DocumentStatus.verified || this == DocumentStatus.pending;

  /// Admin flagged the doc → user should see a Reupload button.
  bool get canReupload =>
      this == DocumentStatus.rejected || this == DocumentStatus.reupload;

  String get label => switch (this) {
        DocumentStatus.verified => 'Verified',
        DocumentStatus.pending  => 'Pending',
        DocumentStatus.rejected => 'Rejected',
        DocumentStatus.reupload => 'Reupload',
      };
}

/// Tolerant parser: handles snake_case, spaces, backend synonyms.
DocumentStatus? parseDocumentStatus(String? raw) {
  if (raw == null) return null;
  final v = raw.toLowerCase().replaceAll('_', '').replaceAll(' ', '').trim();
  if (v.isEmpty) return null;

  switch (v) {
    case 'verified':
    case 'approved':
    case 'accepted':
      return DocumentStatus.verified;
    case 'rejected':
    case 'declined':
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