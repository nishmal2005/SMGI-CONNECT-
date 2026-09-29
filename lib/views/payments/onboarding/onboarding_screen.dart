import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart'
    show AppTextStyles;
import 'package:smgi.connect/views/auth/login_screen.dart';
import 'package:smgi.connect/widgets/gap.dart';

import 'onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _current = 0;

  // Single shared background — only title/description change per page now.
  static const _backgroundImage = 'assets/images/onboarding_bg.png';

  static const _data = <OnboardingData>[
    OnboardingData(
      title: 'Digital admission\nmade easy',
      description:
          'Begin your journey with a clean, step-by-step admission system.',
    ),
    OnboardingData(
      title: 'Apply Your\nReferral Code',
      description:
          'Enter your referral code to get exclusive admission benefits.',
    ),
    OnboardingData(
      title: 'Complete Your\nPayment Safely',
      description: 'Quick, reliable, and fully protected payment processing.',
    ),
  ];

  void _next() {
    if (_current < _data.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background (shared across all pages) ─────
          Positioned.fill(
            child: Image.asset(
              _backgroundImage,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          PageView.builder(
            controller: _pageController,
            itemCount: _data.length,
            onPageChanged: (index) => setState(() => _current = index),
            itemBuilder: (context, index) => const SizedBox.expand(),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(h: 400),

                Text(_data[_current].title, style: AppTextStyles.headline),

                Gap(h: 20),

                Text(_data[_current].description, style: AppTextStyles.body),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_current != _data.length - 1)
                      TextButton(
                        onPressed: _finish,
                        child: Text('Skip', style: AppTextStyles.button),
                      )
                    else
                      const SizedBox(width: 60),

                    TextButton(
                      onPressed: _next,
                      child: Text(
                        _current == _data.length - 1 ? 'Get Started' : 'Next',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ],
                ),

                Gap(h: 32),
              ],
            ),
          ),

          Positioned(
            bottom: 82.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_data.length, (index) {
                final isActive = index == _current;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: (isActive ? 12 : 10).r,
                  height: (isActive ? 12 : 10).r,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
