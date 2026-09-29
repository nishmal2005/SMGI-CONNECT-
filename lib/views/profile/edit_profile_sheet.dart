import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../viewmodels/profile_viewmodel.dart';

/// Opens the Profile edit bottom sheet.
Future<void> showProfileEditSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ProfileEditSheet(),
  );
}

// ─────────────────────────────────────────────────────
// Main edit sheet
// ─────────────────────────────────────────────────────

class _ProfileEditSheet extends StatefulWidget {
  const _ProfileEditSheet();

  @override
  State<_ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<_ProfileEditSheet> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  static const _labelGrey = Color(0xFF9AA0A6);
  static const _fieldFill = Color(0xFFF1F2F5);
  static const _linkBlue = Color(0xFF2E6BE6);

  @override
  void initState() {
    super.initState();
    final vm = context.read<ProfileViewModel>();
    _name = TextEditingController(text: vm.name);
    _email = TextEditingController(text: vm.email);
    _phone = TextEditingController(text: vm.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _openEditPhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _EditProfilePictureSheet(),
    );
  }

  Future<void> _save() async {
    final vm = context.read<ProfileViewModel>();
    vm.updateName(_name.text.trim());
    vm.updateEmail(_email.text.trim());
    vm.updatePhone(_phone.text.trim());

    final ok = await vm.save();
    if (!mounted) return;
    Navigator.of(context).pop();
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error ?? 'Could not save profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final vm = context.watch<ProfileViewModel>();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 32.r,
                        height: 32.r,
                        decoration: const BoxDecoration(
                          color: _fieldFill,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, size: 18.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // ── Avatar + Edit ────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 84.r,
                        height: 84.r,
                        padding: EdgeInsets.all(3.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF9CC0F0),
                            width: 2.w,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFE0E0E0),
                          backgroundImage: vm.avatar != null
                              ? FileImage(vm.avatar!)
                              : const AssetImage(
                                      'assets/images/person.jpeg',
                                    )
                                  as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: _openEditPhotoSheet,
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: _linkBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Fields ───────────────────────────
                _label('Name'),
                _field(_name),
                SizedBox(height: 18.h),

                _label('Email'),
                _field(_email, keyboardType: TextInputType.emailAddress),
                SizedBox(height: 18.h),

                _label('Phone Number'),
                _field(_phone, keyboardType: TextInputType.phone),
                SizedBox(height: 32.h),

                // ── Save ─────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0B2E6B), Color(0xFF16408F)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: vm.saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: vm.saving
                          ? SizedBox(
                              height: 20.r,
                              width: 20.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
      child: Text(
        text,
        style: TextStyle(fontSize: 13.sp, color: _labelGrey),
      ),
    );
  }

  Widget _field(
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: _fieldFill,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Nested "Edit profile picture" sheet
// ─────────────────────────────────────────────────────

class _EditProfilePictureSheet extends StatelessWidget {
  const _EditProfilePictureSheet();

  static const _optionFill = Color(0xFFF1F2F5);
  static const _deleteRed = Color(0xFFE94B4B);

  Future<void> _pickPhoto(BuildContext context) async {
    final vm = context.read<ProfileViewModel>();
    Navigator.pop(context); // close the picture sheet first
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      vm.updateAvatar(File(picked.path));
    }
  }

  void _deletePhoto(BuildContext context) {
    Navigator.pop(context);
    context.read<ProfileViewModel>().clearAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Edit profile picture',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 30.r,
                      height: 30.r,
                      decoration: const BoxDecoration(
                        color: _optionFill,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 16.r),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              _OptionTile(
                icon: Icons.image_outlined,
                iconColor: Colors.black87,
                label: 'Choose photo',
                labelColor: Colors.black87,
                onTap: () => _pickPhoto(context),
              ),
              SizedBox(height: 12.h),
              _OptionTile(
                icon: Icons.delete_outline,
                iconColor: _deleteRed,
                label: 'Delete photo',
                labelColor: _deleteRed,
                onTap: () => _deletePhoto(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F5),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20.r),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}