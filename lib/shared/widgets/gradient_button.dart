import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';

//import 'package:flutter/material.dart';
//import '../../core/constants/app_sizes.dart';
//import '../../core/constants/app_text_styles.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // ✅ nullable
  final bool enabled;

  const GradientButton({
    super.key,
    required this.text,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          height: AppSizes.buttonHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF0B3266),
                Color(0xFF094E8F),
                Color(0xFF0B2546),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSizes.radius),
            border: Border.all(
              color: const Color(0xFF1259A6),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

