import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0A4D9F);
  static const primaryDark = Color(0xFF0A0F29);

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF1A1A1A);

  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF1C40F);
  static const error = Color(0xFFE74C3C);

  static const gray = Color(0xFF9BA3B0);
  static const lightGray = Color(0xFFF5F7FA);

  static const accent = Color(0xFFDAA520);

  //navigation bar
  static const entirenavBg = Color(0xFFFFFFFF);
  static const navSelected = Color(0xFFDAA520);
  static const navNotSelected = Color(0xFF1A1A1A);
  static const navBg = Color(0xFF070D19);

  // Icon box (Home AppBar / Cards)
  static const iconBoxFill = Color(0x1AF5F7FA); //fill
  static const iconBoxStroke = Color(0x1AF5F7FA); //stroke
  static const iconBoxFrame = Color(0xFFFFFFFF); //framecolor



//gradient
  static const LinearGradient backgroundStroke = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF0085FF),
    Color(0xFF070D19),
  ],
);

static const backgroundStrokeone = Color(0xFF052A50);


}
