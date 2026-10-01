import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/application_viewmodel.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/gap.dart';
import 'admission_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<ApplicationViewModel>();
      await vm.hydrate();
      await vm.loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final app   = context.watch<ApplicationViewModel>();
    final state = app.admissionState;

    final headline = switch (state) {
      AdmissionState.notStarted => 'Ready to begin your admission?',
      AdmissionState.inProgress => 'Continue your admission.',
      AdmissionState.completed  => 'Your admission is complete.',
    };

    return AppScaffold(
      body: Column(
        children: [
<<<<<<< HEAD
          // ── App bar (padded) ───────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
            child: const HomeAppBar(),
          ),

=======
          const HomeAppBar(),
>>>>>>> 8bb2989ef30e63080ba6cb0b6671681b06b68b68
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
<<<<<<< HEAD
                  // ── Banner (no padding) ────────
=======
>>>>>>> 8bb2989ef30e63080ba6cb0b6671681b06b68b68
                  Image.asset(
                    'assets/images/homebanner.png',
                    width: double.infinity,
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
<<<<<<< HEAD

                  // ── Content (padded) ───────────
=======
>>>>>>> 8bb2989ef30e63080ba6cb0b6671681b06b68b68
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
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
                          headline,
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: 22.sp,
                            color: AppColors.black,
                          ),
                        ),
                        const Gap(h: 20),
                        AdmissionCard(state: state),
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