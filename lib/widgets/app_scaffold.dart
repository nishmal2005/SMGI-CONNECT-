import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi_connect/core/constants/app_colors.dart';
import 'package:smgi_connect/core/constants/app_sizes.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry? padding;
  final bool safeTop;
  final bool safeBottom;
  final bool resizeToAvoidBottomInset;
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
      padding:
          padding ??
          EdgeInsets.symmetric(horizontal: AppSizes.padding, vertical: 4.h),
      child: body,
    );
    
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
