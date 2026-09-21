import 'package:flutter/material.dart';
import 'package:smgi.connect/features/navbar/home_bottom_nav.dart';
import 'core/theme/app_theme.dart';

class SMGIApp extends StatelessWidget {
  const SMGIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMGI Connect',
      theme: AppTheme.lightTheme,
      // TEMP: Auth bypassed - backend dev on leave, restore before merging
      home: const HomeBottomNav(),
    );
  }
}
