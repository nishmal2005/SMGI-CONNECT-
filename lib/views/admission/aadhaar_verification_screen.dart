import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/aadhaar_viewmodel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/leave_confirmation_dialog.dart';
import '../../widgets/upload_card.dart';
import 'personal_details_screen.dart';

class AadhaarVerificationScreen extends StatefulWidget {
  const AadhaarVerificationScreen({super.key});

  @override
  State<AadhaarVerificationScreen> createState() =>
      _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends State<AadhaarVerificationScreen> {
  late final TextEditingController _aadhaarController;

  @override
  void initState() {
    super.initState();
    _aadhaarController = TextEditingController(
      text: context.read<AadhaarViewModel>().aadhaar,
    );
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool isFront}) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.single.path == null) return;

    final file = File(result.files.single.path!);
    if (!mounted) return;
    final vm = context.read<AadhaarViewModel>();
    isFront ? vm.setFrontImage(file) : vm.setBackImage(file);
  }

  Future<void> _onContinue(AadhaarViewModel vm) async {
    final ok = await vm.upload();
    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Upload failed.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PersonalDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AadhaarViewModel>();

    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => LeaveConfirmationDialog(
                  onLeave: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
              icon: Icon(Icons.arrow_back,
                  color: AppColors.accent, size: 22.r),
            ),
            Gap(h: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Aadhaar Verification',
                      style: AppTextStyles.pageTitle),
                  Gap(h: 24),
                  Text('Enter Aadhaar Number (12 Digits)',
                      style: AppTextStyles.body3
                          .copyWith(color: AppColors.black)),
                  Gap(h: 8),
                  CustomInputField(
                    hintText: 'XXXX XXXX 1234',
                    controller: _aadhaarController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    onChanged: vm.setAadhaar,
                  ),
                  Gap(h: 24),
                  Text('Upload Aadhaar Card (Front)',
                      style: AppTextStyles.body3
                          .copyWith(color: AppColors.black)),
                  Gap(h: 12),
                  UploadCard(
                    height: 220.h,
                    width: double.infinity,
                    assetPath: 'assets/images/download.png',
                    isFileSelected: vm.isFrontUploaded,
                    onTap: () => _pickImage(isFront: true),
                  ),
                  Gap(h: 20),
                  Text('Upload Aadhaar Card (Back)',
                      style: AppTextStyles.body3
                          .copyWith(color: AppColors.black)),
                  Gap(h: 12),
                  UploadCard(
                    height: 220.h,
                    width: double.infinity,
                    assetPath: 'assets/images/download.png',
                    isFileSelected: vm.isBackUploaded,
                    onTap: () => _pickImage(isFront: false),
                  ),
                  Gap(h: 40),
                  GradientButton(
                    text: vm.uploading ? 'Uploading...' : 'Continue',
                    enabled: vm.canContinue && !vm.uploading,
                    onTap: () => _onContinue(vm),
                  ),
                  Gap(h: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}