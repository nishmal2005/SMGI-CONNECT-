import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PlainTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;

  const PlainTextField({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray, width: 0.75),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04, // responsive padding
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: AppTextStyles.caption.copyWith(color: AppColors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.caption.copyWith(color: AppColors.gray),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}
