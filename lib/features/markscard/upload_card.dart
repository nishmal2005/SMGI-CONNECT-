import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadCardDashed extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;

  const UploadCardDashed({
    super.key,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
  options: RoundedRectDottedBorderOptions(
    color: const Color(0xFF9BA3B0),
    strokeWidth: 1,
    dashPattern: const [6, 6],
    radius: const Radius.circular(12),
  ),
  child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F7FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/download.png", height: 70),
              const SizedBox(height: 12),

              const Text(
                "Tap to select or drag file here",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),

              const Text(
                "Supported: JPG / PDF / PNG / (Max 5MB)",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF9BA3B0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
