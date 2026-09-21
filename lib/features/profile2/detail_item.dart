import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';

class DetailItem extends StatelessWidget {
  final String label;
  final Widget value;

  const DetailItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputHint),
        const Gap(h: 4),
        value,
      ],
    );
  }
}
