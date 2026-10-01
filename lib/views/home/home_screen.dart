import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/gap.dart';
import 'admission_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          // ── App bar (padded) ───────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
            child: const HomeAppBar(),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Banner (no padding) ────────
                  Image.asset(
                    'assets/images/homebanner.png',
                    width: double.infinity,
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),

                  // ── Content (padded) ───────────
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(h: 16),
                        Text(
                          'Hello, there!',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.black,
                          ),
                        ),
                        const Gap(h: 4),
                        Text(
                          'Ready to begin your admission?',
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: 22.sp,
                            color: AppColors.black,
                          ),
                        ),
                        const Gap(h: 20),
                        const AdmissionCard(),
                        const Gap(h: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}