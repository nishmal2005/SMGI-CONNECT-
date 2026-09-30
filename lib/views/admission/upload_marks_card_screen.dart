import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/document_viewmodel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/leave_confirmation_dialog.dart';
import '../../widgets/upload_card_dashed.dart';
import '../../widgets/upload_file_status_card.dart';
import '../referrals/apply_referral_screen.dart';

class UploadMarksCardScreen extends StatefulWidget {
  const UploadMarksCardScreen({super.key});

  @override
  State<UploadMarksCardScreen> createState() =>
      _UploadMarksCardScreenState();
}

class _UploadMarksCardScreenState extends State<UploadMarksCardScreen> {
  String? _pickedPath;

  @override
  void initState() {
    super.initState();
  }

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

  Future<void> _continue() async {
    if (_pickedPath == null) return;

    final vm = context.read<DocumentViewModel>();
    final ok = await vm.upload(
      documentType: 'tenth_marks_card',
      file: File(_pickedPath!),
    );

    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Upload failed.'),
        ),
      );
      return;
    }

    // Upload succeeded — move to referral.
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ApplyReferralScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DocumentViewModel>();
    final fileName = _pickedPath == null
        ? null
        : _pickedPath!.split(Platform.pathSeparator).last;

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back ───────────────────────────────
            IconButton(
              onPressed: () {
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
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.accent,
                size: 22.r,
              ),
            ),
            SizedBox(height: 10.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload 10th Mark Card',
                    style: AppTextStyles.pageTitle,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Upload Marks Card',
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
                    text: vm.isUploading ? 'Uploading...' : 'Continue',
                    enabled: _pickedPath != null && !vm.isUploading,
                    onTap: _continue,
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