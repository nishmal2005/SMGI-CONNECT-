import 'package:flutter/material.dart';
//import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;

  const OtpBox({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.15,
      height: size.width * 0.15,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF11305C), Color(0xFF0E1F39)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1259A6), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: AppTextStyles.subtitle,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
