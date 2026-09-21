import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12), // ✅ radius 12
        border: Border.all(color: AppColors.gray),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
  hint: Text(
    hint,
    style: AppTextStyles.inputHint,
  ),
  value: value,

  // ✅ keeps text + arrow aligned
  isExpanded: true,

  // ✅ arrow INSIDE the field
  icon: const Icon(
    Icons.keyboard_arrow_down,
    color: AppColors.gray,
  ),
  iconSize: 24,

  dropdownColor: Colors.white,
  borderRadius: BorderRadius.circular(12),

  items: _buildItems(),
  onChanged: onChanged,
)
,),
    );
  }

  List<DropdownMenuItem<String>> _buildItems() {
  return items.map((e) {
    return DropdownMenuItem<String>(
      value: e,
      child: Text(
        e,
        style: AppTextStyles.inputText,
      ),
    );
  }).toList();
}
}
