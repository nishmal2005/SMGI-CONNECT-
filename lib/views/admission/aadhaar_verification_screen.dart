import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/aadhaar_viewmodel.dart';
import '../../viewmodels/application_viewmodel.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/leave_confirmation_dialog.dart';
import '../../widgets/upload_card.dart';
import 'personal_details_screen.dart';

class AadhaarVerificationScreen extends StatefulWidget {
  /// When true → opened from Document Vault to re-upload a flagged side.
  final bool isReupload;

  /// Which side to reupload: 'front' | 'back' | null (both).
  /// Only meaningful when [isReupload] is true.
  final String? reuploadSide;

  const AadhaarVerificationScreen({
    super.key,
    this.isReupload = false,
    this.reuploadSide,
  });

  @override
  State<AadhaarVerificationScreen> createState() =>
      _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends State<AadhaarVerificationScreen> {
  late final TextEditingController _aadhaarController;

  /// True once we've decided to show the reupload UI, either because
  /// the caller said so (isReupload) or because the backend rejected
  /// the POST with "use PATCH".
  late bool _forceReupload;

  // Local picks used in reupload mode.
  File? _newFront;
  File? _newBack;

  @override
  void initState() {
    super.initState();
    _forceReupload = widget.isReupload;
    final vm = context.read<AadhaarViewModel>();
    _aadhaarController = TextEditingController(text: vm.aadhaar);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadStatus();
    });
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

    if (_forceReupload) {
      setState(() {
        if (isFront) {
          _newFront = file;
        } else {
          _newBack = file;
        }
      });
    } else {
      final vm = context.read<AadhaarViewModel>();
      isFront ? vm.setFrontImage(file) : vm.setBackImage(file);
    }
  }

  // ── First-time submission ───────────────────────
  Future<void> _submitFull(AadhaarViewModel vm) async {
    final ok = await vm.upload();
    if (!mounted) return;

    if (!ok) {
      // Backend rejected the POST — the side(s) need PATCH.
      if (vm.needsReupload) {
        setState(() {
          _forceReupload = true;
          _newFront = null;
          _newBack = null;
        });
        _snack(
          'Your Aadhaar is already on file. Please re-upload the '
          'flagged side below.',
        );
        return;
      }

      _snack(vm.errorMessage ?? 'Upload failed.');
      return;
    }

    context.read<ApplicationViewModel>().setAadhaar(
          number: vm.aadhaar,
          frontPath: vm.frontImage?.path,
          backPath: vm.backImage?.path,
        );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PersonalDetailsScreen()),
    );
  }

  // ── Reupload submission ─────────────────────────
  Future<void> _submitReupload(
    AadhaarViewModel vm, {
    required bool frontNeeds,
    required bool backNeeds,
  }) async {
    if (frontNeeds) {
      if (_newFront == null) {
        _snack('Please pick a new Aadhaar Front image.');
        return;
      }
      final ok = await vm.reuploadSide(side: 'front', file: _newFront!);
      if (!mounted || !ok) {
        _snack(vm.errorMessage ?? 'Front re-upload failed.');
        return;
      }
    }

    if (backNeeds) {
      if (_newBack == null) {
        _snack('Please pick a new Aadhaar Back image.');
        return;
      }
      final ok = await vm.reuploadSide(side: 'back', file: _newBack!);
      if (!mounted || !ok) {
        _snack(vm.errorMessage ?? 'Back re-upload failed.');
        return;
      }
    }

    if (!mounted) return;

    if (widget.isReupload) {
      Navigator.pop(context, true);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PersonalDetailsScreen()),
      );
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
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
              onPressed: () {
                if (widget.isReupload || _forceReupload) {
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
            Gap(h: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _forceReupload
                  ? _buildReupload(vm)
                  : _buildFull(vm),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────
  // Reupload mode
  // ──────────────────────────────────────────────────
  Widget _buildReupload(AadhaarViewModel vm) {
    final forced = widget.reuploadSide; // 'front' | 'back' | null

    // When this screen was opened from the vault (isReupload = true),
    // we KNOW the backend flagged the Aadhaar. Trust the caller and
    // always show the tiles — do NOT fall back to _buildFull based on
    // the stale AadhaarViewModel cache.
    final frontNeeds = forced == 'front'
        ? true
        : forced == 'back'
            ? false
            : (widget.isReupload ? true : vm.frontNeedsReupload);

    final backNeeds = forced == 'back'
        ? true
        : forced == 'front'
            ? false
            : (widget.isReupload ? true : vm.backNeedsReupload);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Re-upload Aadhaar', style: AppTextStyles.pageTitle),
        Gap(h: 8),
        Text(
          'Please upload a new photo for the side(s) marked for '
          're-upload.',
          style: AppTextStyles.condition.copyWith(color: AppColors.black),
        ),
        Gap(h: 24),

        if (frontNeeds) ...[
          Text('Aadhaar Front',
              style: AppTextStyles.body3.copyWith(color: AppColors.black)),
          Gap(h: 12),
          UploadCard(
            height: 180.h,
            width: double.infinity,
            assetPath: 'assets/images/download.png',
            isFileSelected: _newFront != null,
            onTap: () => _pickImage(isFront: true),
          ),
          Gap(h: 20),
        ],

        if (backNeeds) ...[
          Text('Aadhaar Back',
              style: AppTextStyles.body3.copyWith(color: AppColors.black)),
          Gap(h: 12),
          UploadCard(
            height: 180.h,
            width: double.infinity,
            assetPath: 'assets/images/download.png',
            isFileSelected: _newBack != null,
            onTap: () => _pickImage(isFront: false),
          ),
          Gap(h: 20),
        ],

        Gap(h: 20),
        GradientButton(
          text: vm.uploading ? 'Uploading...' : 'Submit Re-upload',
          enabled: !vm.uploading,
          onTap: () => _submitReupload(
            vm,
            frontNeeds: frontNeeds,
            backNeeds: backNeeds,
          ),
        ),
        Gap(h: 16),
      ],
    );
  }

  // ──────────────────────────────────────────────────
  // First-time mode
  // ──────────────────────────────────────────────────
  Widget _buildFull(AadhaarViewModel vm) {
    if (vm.isLocked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aadhaar Verification', style: AppTextStyles.pageTitle),
          Gap(h: 24),
          Text(
            'Your Aadhaar is already submitted and under review.',
            style: AppTextStyles.body3.copyWith(color: AppColors.black),
          ),
          Gap(h: 40),
          GradientButton(
            text: 'Continue',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PersonalDetailsScreen(),
              ),
            ),
          ),
          Gap(h: 16),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aadhaar Verification', style: AppTextStyles.pageTitle),
        Gap(h: 24),
        Text('Enter Aadhaar Number (12 Digits)',
            style: AppTextStyles.body3.copyWith(color: AppColors.black)),
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
            style: AppTextStyles.body3.copyWith(color: AppColors.black)),
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
            style: AppTextStyles.body3.copyWith(color: AppColors.black)),
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
          onTap: () => _submitFull(vm),
        ),
        Gap(h: 16),
      ],
    );
  }
}