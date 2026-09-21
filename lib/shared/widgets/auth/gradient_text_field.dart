import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';

class GradientTextField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const GradientTextField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF11305C), Color(0xFF0E1F39)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: const Color(0xFF1259A6), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: onChanged,
        style: AppTextStyles.caption.copyWith(color: AppColors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.caption.copyWith(
            color: const Color(0x9B9BA3B0),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
