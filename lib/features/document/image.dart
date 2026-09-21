import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';

class DocumentImage extends StatelessWidget {
  final String image;
  const DocumentImage(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset('assets/images/adharimg.png', fit: BoxFit.contain),
    );
  }
}
