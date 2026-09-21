import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:smgi.connect/core/constants/app_colors.dart';
// import 'package:smgi.connect/core/constants/app_sizes.dart';
// import 'package:smgi.connect/core/constants/app_text_styles.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  // ✅ ADD THESE AS CLASS FIELDS
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  const CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,        // ✅ correct
    this.inputFormatters,  // ✅ correct
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLines == 1 ? 52 : null,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(
          color: AppColors.gray,
          width: 0.75,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength,
        // ✅ NOW THESE WORK CORRECTLY
        onChanged: onChanged,
        inputFormatters: inputFormatters,

        style: AppTextStyles.inputText.copyWith(
          color: AppColors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.inputHint,
          counterText: "",
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: maxLines == 1 ? 0 : 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
