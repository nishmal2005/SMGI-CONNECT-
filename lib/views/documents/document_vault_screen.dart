import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/document_model.dart';
import '../../viewmodels/aadhaar_viewmodel.dart';
import '../../viewmodels/document_viewmodel.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_scaffold.dart';
import '../admission/aadhaar_verification_screen.dart';
import '../admission/upload_marks_card_screen.dart';

class DocumentVaultScreen extends StatefulWidget {
  const DocumentVaultScreen({super.key});

  @override
  State<DocumentVaultScreen> createState() => _DocumentVaultScreenState();
}

class _DocumentVaultScreenState extends State<DocumentVaultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<AadhaarViewModel>().loadStatus(),
      context.read<DocumentViewModel>().load(),
    ]);
  }

  // ── Reupload — Aadhaar (both sides) ────────────
  Future<void> _onAadhaarReupload() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AadhaarVerificationScreen(
          isReupload: true,
        ),
      ),
    );
    if (!mounted) return;
    await _refresh();
  }

  // ── Reupload — 10th Marks Card ──────────────────
  Future<void> _onMarksCardReupload(DocumentModel doc) async {
    if (doc.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cannot re-upload: this document is not linked to an id. '
            'Please log out and back in, then try again.',
          ),
        ),
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UploadMarksCardScreen(
          isReupload: true,
          documentId: doc.id,
        ),
      ),
    );
    if (!mounted) return;
    await _refresh();
  }

  // ── Filters ─────────────────────────────────────
  bool _isAadhaar(DocumentModel d) {
    final t = '${d.documentType} ${d.title}'.toLowerCase();
    return t.contains('aadhaar') || t.contains('aadhar');
  }

  bool _isMarksCard(DocumentModel d) {
    final t = '${d.documentType} ${d.title}'.toLowerCase();
    return t.contains('tenth') ||
        t.contains('10th') ||
        t.contains('marks_card') ||
        t.contains('marks card');
  }

  DocumentModel? _firstWhere(
    List<DocumentModel> list,
    bool Function(DocumentModel) test,
  ) {
    for (final d in list) {
      if (test(d)) return d;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final aVm = context.watch<AadhaarViewModel>();
    final docVm = context.watch<DocumentViewModel>();

    final aadhaar = _firstWhere(docVm.items, _isAadhaar);
    final marks   = _firstWhere(docVm.items, _isMarksCard);

    final isUploading = aVm.uploading || docVm.isUploading;

    final aadhaarStatus = aadhaar?.status ?? aVm.frontStatus;
    final aadhaarCanReupload =
        aadhaarStatus == DocumentStatus.reupload ||
        aadhaarStatus == DocumentStatus.rejected;

    return AppScaffold(
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.padding,
                  vertical: AppSizes.padding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Documents',
                      style: AppTextStyles.subtitle.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildCard(
                      aadhaarStatus: aadhaarStatus,
                      aadhaarCanReupload: aadhaarCanReupload,
                      marks: marks,
                      isUploading: isUploading,
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required DocumentStatus? aadhaarStatus,
    required bool aadhaarCanReupload,
    required DocumentModel? marks,
    required bool isUploading,
  }) {
    final rows = <Widget>[
      _DocRow(
        title: 'Aadhaar Card',
        status: aadhaarStatus,
        canReupload: aadhaarCanReupload,
        isUploading: isUploading,
        onReupload: _onAadhaarReupload,
      ),
      _DocRow(
        title: '10th Marks Card',
        status: marks?.status,
        canReupload: (marks?.status == DocumentStatus.reupload ||
                marks?.status == DocumentStatus.rejected) &&
            (marks?.id.isNotEmpty ?? false),
        isUploading: isUploading,
        onReupload: () {
          if (marks != null) _onMarksCardReupload(marks);
        },
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: i == rows.length - 1 ? 0 : 18.h,
            ),
            child: rows[i],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// One row
// ─────────────────────────────────────────────────────

class _DocRow extends StatelessWidget {
  final String title;
  final DocumentStatus? status;
  final bool canReupload;
  final bool isUploading;
  final VoidCallback onReupload;

  const _DocRow({
    required this.title,
    required this.status,
    required this.canReupload,
    required this.isUploading,
    required this.onReupload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 42.r,
          width: 42.r,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Image.asset(
            'assets/images/adharimg.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.description_outlined,
              size: 20.r,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ),
        ),
        if (canReupload)
          SizedBox(
            height: 30.h,
            child: ElevatedButton(
              onPressed: isUploading ? null : onReupload,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                disabledBackgroundColor:
                    const Color(0xFFE74C3C).withValues(alpha: 0.4),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                isUploading ? 'Uploading…' : 'Reupload',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          _StatusText(status: status),
      ],
    );
  }
}

class _StatusText extends StatelessWidget {
  final DocumentStatus? status;
  const _StatusText({required this.status});

  @override
  Widget build(BuildContext context) {
    final (text, color) = _describe(status);
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  (String, Color) _describe(DocumentStatus? s) {
    switch (s) {
      case DocumentStatus.verified:
        return ('Verified', const Color(0xFF2ECC71));
      case DocumentStatus.pending:
        return ('Pending', const Color(0xFFF1C40F));
      case DocumentStatus.rejected:
        return ('Rejected', const Color(0xFFE74C3C));
      case DocumentStatus.reupload:
        return ('Reupload', const Color(0xFFE74C3C));
      case null:
        return ('Not Uploaded', AppColors.gray);
    }
  }
}