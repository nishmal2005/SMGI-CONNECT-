import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/theme/app_theme.dart';
import 'views/splash/splash_screen.dart';

/// Global navigator key — used by the session-expiry handler in
/// main.dart to redirect the user to the login screen when the
/// refresh token can no longer be used.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        navigatorKey: navigatorKey, // ← add this
        home: child,
      ),
      child: const SplashScreen(),
    );
  }
}