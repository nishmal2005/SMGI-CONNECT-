import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/views/payments/onboarding/onboarding_screen.dart';

import 'core/theme/app_theme.dart';

class SMGIApp extends StatelessWidget {
  const SMGIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SMGI Connect',
        theme: AppTheme.light,
        home: child,
      ),
      child: const OnboardingScreen(),
    );
  }
}
