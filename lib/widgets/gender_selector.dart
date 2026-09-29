import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';


class GenderSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _genders = ['Male', 'Female', 'Others'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _genders.map((gender) {
        final selected = gender == value;
        return Expanded(
          child: InkWell(
            onTap: () => onChanged(gender),
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
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
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}