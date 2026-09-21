import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
//import 'package:smgi.connect/core/constants/app_text_styles.dart';

class PersonalDetailsHeader extends StatelessWidget {
  const PersonalDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back,
              color: AppColors.accent),
        ),
      ],
    );
  }
}
