import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/navbar/home_bottom_nav.dart';
import 'package:smgi.connect/features/onboarding/onboarding_model.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<OnboardingData> data = [
    OnboardingData(
      image: 'assets/images/onboarding1.png',
      title: 'Digital admission\nmade easy',
      description:
          'Begin your journey with a clean, step-by-step admission system.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding2.png',
      title: 'Apply Your\nReferral Code',
      description:
          'Enter your referral code to get exclusive admission benefits.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding3.png',
      title: 'Complete Your\nPayment Safely',
      description: 'Quick, reliable, and fully protected payment processing.',
    ),
  ];

  /// 👇 Push-style screen feeling inside onboarding
  void goToNext() {
    if (currentPage < data.length - 1) {
      setState(() => currentPage++);
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut, // feels like Navigator.push()
      );
    } else {
      goToHome();
    }
  }

  void goToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        // TEMP: Auth bypassed - backend dev on leave, restore before merging
        // pageBuilder: (_, _, _) => const LoginScreen2(),
        pageBuilder: (_, _, _) => const HomeBottomNav(),
        transitionsBuilder: (_, animation, _, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Push from right
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: data.length,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => currentPage = index),

        itemBuilder: (context, index) {
          final item = data[index];

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),

              /// 🌟 Foreground Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(h: size.height * 0.50),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        item.title,
                        key: ValueKey(item.title),
                        style: AppTextStyles.headline,
                      ),
                    ),

                    Gap(h: size.height * 0.025),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        item.description,
                        key: ValueKey(item.description),
                        style: AppTextStyles.body,
                      ),
                    ),

                    Gap(h: size.height * 0.22),

                    /// Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (currentPage != data.length - 1)
                          TextButton(
                            onPressed: goToHome,
                            child: const Text(
                              'Skip',
                              style: AppTextStyles.button,
                            ),
                          )
                        else
                          const SizedBox(),

                        TextButton(
                          onPressed: goToNext,
                          child: Text(
                            currentPage == data.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: AppTextStyles.button,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
