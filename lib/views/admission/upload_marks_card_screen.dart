import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/application_viewmodel.dart';
import '../../viewmodels/document_viewmodel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/leave_confirmation_dialog.dart';
import '../../widgets/upload_card_dashed.dart';
import '../../widgets/upload_file_status_card.dart';
import '../referrals/apply_referral_screen.dart';

class UploadMarksCardScreen extends StatefulWidget {
  /// When true → opened from Document Vault to replace a rejected
  /// 10th Marks Card. [documentId] must be provided.
  final bool isReupload;
  final String? documentId;

  const UploadMarksCardScreen({
    super.key,
    this.isReupload = false,
    this.documentId,
  });

  @override
  State<UploadMarksCardScreen> createState() =>
      _UploadMarksCardScreenState();
}

class _UploadMarksCardScreenState extends State<UploadMarksCardScreen> {
  String? _pickedPath;
  bool _submitting = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result == null || result.files.single.path == null) return;
    setState(() => _pickedPath = result.files.single.path!);
  }

  void _clearFile() {
    setState(() => _pickedPath = null);
  }

  Future<void> _onContinue() async {
    if (_pickedPath == null) return;

    setState(() => _submitting = true);

    // ── Reupload path (opened from Vault) ───────────
    if (widget.isReupload) {
      final id = widget.documentId;
      if (id == null || id.isEmpty) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document id missing.')),
        );
        return;
      }

      final docVm = context.read<DocumentViewModel>();
      final ok = await docVm.reuploadById(
        id: id,
        file: File(_pickedPath!),
      );

      if (!mounted) return;
      setState(() => _submitting = false);

      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(docVm.errorMessage ?? 'Upload failed.')),
        );
        return;
      }
      Navigator.pop(context, true);
      return;
    }

    // ── First-time path ─────────────────────────────
    final docVm = context.read<DocumentViewModel>();
    final appVm = context.read<ApplicationViewModel>();

    // 1) Upload the marks card document.
    final uploaded = await docVm.upload(
      documentType: 'tenth_marks_card',
      file: File(_pickedPath!),
    );

    if (!mounted) return;
    if (!uploaded) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(docVm.errorMessage ?? 'Upload failed.')),
      );
      return;
    }

    // 2) Create the application (POST /applications/).
    //    Only do this if it hasn't been created yet.
    if (appVm.applicationId == null) {
      final created = await appVm.submit();

      if (!mounted) return;
      if (!created) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              appVm.errorMessage ?? 'Could not create application.',
            ),
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    setState(() => _submitting = false);

    // 3) Move on to referral (which now sees a valid applicationId).
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ApplyReferralScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _pickedPath == null
        ? null
        : _pickedPath!.split(Platform.pathSeparator).last;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                if (widget.isReupload) {
                  Navigator.pop(context);
                  return;
                }
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => LeaveConfirmationDialog(
                    onLeave: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              icon: Icon(Icons.arrow_back,
                  color: AppColors.accent, size: 22.r),
            ),
            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isReupload
                        ? 'Re-upload 10th Mark Card'
                        : 'Upload 10th Mark Card',
                    style: AppTextStyles.pageTitle,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    widget.isReupload
                        ? 'Your previous upload was rejected. Please '
                          'select a new file to replace it.'
                        : 'Upload Marks Card',
                    style: AppTextStyles.fieldTitle.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  UploadCardDashed(
                    width: double.infinity,
                    height: 230.h,
                    onTap: _pickFile,
                  ),
                  SizedBox(height: 30.h),

                  UploadFileStatusCard(
                    fileName: fileName,
                    onClear: _clearFile,
                  ),
                  SizedBox(height: 40.h),

                  GradientButton(
                    text: _submitting
                        ? 'Submitting...'
                        : (widget.isReupload
                            ? 'Submit Re-upload'
                            : 'Continue'),
                    enabled: _pickedPath != null && !_submitting,
                    onTap: _onContinue,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}