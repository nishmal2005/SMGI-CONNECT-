import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
//import 'package:smgi.connect/shared/widgets/gap.dart';

class GenderSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final genders = ["Male", "Female", "Others"];

    return Row(
      children: genders.map((gender) {
        return Expanded(
          child: InkWell(
            onTap: () => onChanged(gender),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<String>(
                  value: gender,
                  groupValue: value,
                  onChanged: (v) => onChanged(v!),
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                Text(
                  gender,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
