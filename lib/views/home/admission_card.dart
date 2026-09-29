import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';


import '../../widgets/gap.dart';
import '../../widgets/gradient_button.dart';
import '../admission/aadhaar_verification_screen.dart';

class AdmissionCard extends StatelessWidget {
  const AdmissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
     // padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF8FAFF)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Gap(h: 15),
          Image.asset(
            'assets/images/cardicon.png',
            width: 90.r,
            height: 90.r,
          ),
          const Gap(h: 16),
          Text(
            'Start Admission Process',
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 18.sp,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(h: 8),
          Text(
            'Complete your Aadhaar, course selection & payment in one flow.',
            style: AppTextStyles.condition.copyWith(
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(h: 20),
          GradientButton(
            text: 'Start Now →',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AadhaarVerificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}