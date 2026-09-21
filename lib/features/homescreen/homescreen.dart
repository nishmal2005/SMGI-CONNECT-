import 'package:flutter/material.dart';
import 'package:smgi.connect/features/homescreen/admission_card.dart';
import 'package:smgi.connect/shared/widgets/app_bar.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HomeAppBar(),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/homebanner.png',
                      width: size.width,
                      height: size.height * 0.18,
                      fit: BoxFit.cover,
                    ),

                    // Padding starts AFTER banner
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * .04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(h: 20),

                          Text(
                            'Hello, there!',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 18,
                              color: AppColors.black,
                            ),
                          ),

                          const Gap(h: 4),

                          Text(
                            'Ready to begin your admission?',
                            style: AppTextStyles.subtitle.copyWith(
                              fontSize: 22,
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
      ),
    );
  }
}
