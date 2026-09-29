import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';



class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry? padding;

  /// When false, the screen draws its own SafeArea.
  /// Use for full-bleed images (banner, splash) that should slide
  /// under the status bar.
  final bool safeTop;
  final bool safeBottom;

  /// Whether the body should resize when the keyboard appears.
  /// Defaults to true (Flutter's default).
  final bool resizeToAvoidBottomInset;

  /// Custom background — falls back to the app's light grey.
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.padding,
    this.safeTop = true,
    this.safeBottom = true,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: padding ??
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: body,
    );

    // Only wrap in SafeArea if either side is requested.
    // When the caller passes `appBar`, the Scaffold already consumed
    // the top inset — so `safeTop` becomes a no-op in that case.
    if (safeTop || safeBottom) {
      content = SafeArea(
        top: safeTop && appBar == null,
        bottom: safeBottom,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.lightGray,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: content,
    );
  }
}