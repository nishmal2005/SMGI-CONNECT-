import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/viewmodels/application_viewmodel.dart';


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
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _pickedPath = context.read<ApplicationViewModel>().marksCardPath;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result == null || result.files.single.path == null) return;

    final path = result.files.single.path!;
    setState(() => _pickedPath = path);
    context.read<ApplicationViewModel>().setMarksCard(path);
  }

  void _clearFile() {
    setState(() => _pickedPath = null);
    context.read<ApplicationViewModel>().setMarksCard(null);
  }

  Future<void> _continue() async {
    if (_pickedPath == null) return;

    final app = context.read<ApplicationViewModel>();

    // Persist the marks-card path first so the payload includes it.
    app.setMarksCard(_pickedPath);

    setState(() => _submitting = true);

    // Create the application on the backend (POST /applications/).
    // Every downstream screen (Apply Referral, Review) needs the id.
    final ok = await app.submit();

    if (!mounted) return;
    setState(() => _submitting = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            app.errorMessage ?? 'Could not create application.',
          ),
        ),
      );
      return;
    }

    // Application now exists. Move to referral.
    await Navigator.push(
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
      body: SafeArea(
        child: SingleChildScrollView(
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

                    // ── Dashed upload box ──────────────
                    UploadCardDashed(
                      width: double.infinity,
                      height: 230.h,
                      onTap: _pickFile,
                    ),
                    SizedBox(height: 30.h),

                    // ── File status card ───────────────
                    UploadFileStatusCard(
                      fileName: fileName,
                      onClear: _clearFile,
                    ),
                    SizedBox(height: 40.h),

                    // ── Continue ───────────────────────
                    GradientButton(
                      text: _submitting
                          ? 'Creating application...'
                          : 'Continue',
                      enabled: _pickedPath != null && !_submitting,
                      onTap: _continue,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}