import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFF070D19)),
        Positioned(
          top: -60.h,
          right: -80.w,
          child: _BlurredShape(
            width: 260.w,
            height: 320.h,
            color: const Color(0xFF0A3D91),
            blur: 140,
            opacity: 0.25,
          ),
        ),
        Positioned(
          top: 90.h,
          right: 30.w,
          child: Transform.rotate(
            angle: 72.51 * pi / 180,
            child: _BlurredShape(
              width: 220.w,
              height: 190.h,
              color: const Color(0xFF1C5DB8),
              blur: 40,
              opacity: 0.12,
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

class _BlurredShape extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double blur;
  final double opacity;

  const _BlurredShape({
    required this.width,
    required this.height,
    required this.color,
    required this.blur,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(32.r),
          ),
        ),
      ),
    );
  }
}