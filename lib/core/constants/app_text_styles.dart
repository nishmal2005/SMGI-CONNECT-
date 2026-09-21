import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const logoblack = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const body = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  //new
  static const logoGold = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.56, // 2%
    color: AppColors.accent,
  );

  static const logoWhite = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.56,
    color: AppColors.white,
  );

  static const subtitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.44,
    color: AppColors.white,
  );

  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const captionone = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const condition = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.gray,
  );
  static const body1 = TextStyle(fontSize: 12, color: AppColors.black);
  static const body2 = TextStyle(fontSize: 14, color: AppColors.black);

  static const body3 = TextStyle(fontSize: 14, color: AppColors.black);

  // fields
  static const pageTitle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600, // SemiBold
  color: AppColors.black,
);

static const fieldTitle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400, // Regular
  color: AppColors.black,
);

static const inputHint = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: AppColors.gray,
);



static const inputText = TextStyle(
  fontSize: 12,
  color: AppColors.black,
);


}
