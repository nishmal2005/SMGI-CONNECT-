import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Logo ─────────────────────────────────────────
  static TextStyle get logoGold => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.accent,
      );
  static TextStyle get logoWhite => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      );
  static TextStyle get logoblack => TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );

  // ── Titles ───────────────────────────────────────
  static TextStyle get pageTitle => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );
  static TextStyle get subtitle => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );
  static TextStyle get headline => TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        height: 1.2,
      );

  // ── Body ─────────────────────────────────────────
  static TextStyle get body => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.white,
      );
  static TextStyle get body2 => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );
  static TextStyle get body3 => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.gray,
      );

  // ── Form ─────────────────────────────────────────
  static TextStyle get fieldTitle => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );
  static TextStyle get inputText => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      );
  static TextStyle get inputHint => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.gray,
      );

  // ── Misc ─────────────────────────────────────────
  static TextStyle get caption => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.white,
      );
  static TextStyle get captionone => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.white,
      );
  static TextStyle get condition => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.gray,
      );
  static TextStyle get button => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      );
}