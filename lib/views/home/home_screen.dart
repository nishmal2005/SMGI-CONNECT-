import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/application_viewmodel.dart';
import '../../widgets/admission_card.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/gap.dart';

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
    final app = context.watch<ApplicationViewModel>();
    final state = app.admissionState;

    return AppScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          AppSizes.appBarHeight + MediaQuery.paddingOf(context).top,
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: AppSizes.appBarHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
              child: const HomeAppBar(),
            ),
          ),
        ),
      ),
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Image.asset(
                      'assets/images/homebanner.png',
                      height: 150.h,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                          switch (state) {
                            AdmissionState.notStarted =>
                              'Ready to begin your admission?',
                            AdmissionState.inProgress =>
                              'Continue your admission.',
                            AdmissionState.completed =>
                              'Your admission is complete.',
                          },
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
