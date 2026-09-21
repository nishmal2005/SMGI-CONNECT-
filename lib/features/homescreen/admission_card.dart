import 'package:flutter/material.dart';
import 'package:smgi.connect/features/aadhar/screens/aadhaar_verification_screen.dart';
import 'package:smgi.connect/shared/widgets/gradient_button.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/gap.dart';

class AdmissionCard extends StatelessWidget {
  const AdmissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * .05),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFF8FAFF)),
      ),

      child: Column(
        children: [
          const Gap(h: 15),
          Image.asset('assets/images/cardicon.png', width: 90, height: 90),

          const Gap(h: 16),

          Text(
            'Start Admission Process',
            style: AppTextStyles.subtitle.copyWith(
              fontSize: 18,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),

          const Gap(h: 8),

          Text(
            'Complete your Aadhaar, course selection & payment in one flow.',
            style: AppTextStyles.condition.copyWith(color: AppColors.black),
            textAlign: TextAlign.center,
          ),

          const Gap(h: 20),

          GradientButton(
            text: 'Start Now →',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AadhaarVerificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
