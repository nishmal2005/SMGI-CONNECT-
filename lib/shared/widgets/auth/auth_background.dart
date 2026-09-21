import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// BASE DARK BACKGROUND
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF070D19),
            borderRadius: BorderRadius.circular(0),
          ),
        ),

        /// SOFT RECTANGLE GLOW (TOP RIGHT)
        Positioned(
          top: -60,
          right: -80,
          child: _BlurredShape(
            width: 260,
            height: 320,
            color: const Color(0xFF0A3D91), // darker blue
            blur: 140, // ↓ reduced
            opacity: 0.25, // ↓ reduced
          ),
        ),

        /// ROTATED VECTOR (VERY SUBTLE)
        Positioned(
          top: 90,
          right: 30,
          child: Transform.rotate(
            angle: 72.51 * pi / 180,
            child: _BlurredShape(
              width: 220,
              height: 190,
              color: const Color(0xFF1C5DB8),
              blur: 40, // ↓ reduced
              opacity: 0.12, // ↓ reduced
            ),
          ),
        ),

        /// CONTENT
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
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
    );
  }
}
