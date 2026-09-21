import 'package:flutter/material.dart';
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
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF11305C), Color(0xFF0E1F39)],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(color: const Color(0xFF1259A6), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          /// LEFT ICON
          Icon(
            widget.isValid ? Icons.check_circle : Icons.lock_outline,
            color: widget.isValid ? AppColors.success : AppColors.gray,
            size: 18,
          ),

          const SizedBox(width: 12),

          /// INPUT
          Expanded(
            child: TextField(
              obscureText: _obscureText,
              style: AppTextStyles.caption,
              decoration: const InputDecoration(
                hintText: '••••••••',
                border: InputBorder.none,
              ),
              onChanged: widget.onChanged,
            ),
          ),

          /// EYE ICON (WORKING)
          GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.gray,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
