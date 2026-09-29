import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';



class PasswordField extends StatefulWidget {
  final bool isValid;
  final ValueChanged<String>? onChanged;

  const PasswordField({
    super.key,
    this.isValid = false,
    this.onChanged,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.inputHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF11305C), Color(0xFF0E1F39)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: const Color(0xFF1259A6), width: 1.2.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(
            widget.isValid ? Icons.check_circle : Icons.lock_outline,
            color: widget.isValid ? AppColors.success : AppColors.gray,
            size: 18.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              obscureText: _obscure,
              onChanged: widget.onChanged,
              style: AppTextStyles.caption,
              decoration: const InputDecoration(
                hintText: '••••••••',
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _obscure = !_obscure),
            child: Icon(
              _obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.gray,
              size: 18.r,
            ),
          ),
        ],
      ),
    );
  }
}