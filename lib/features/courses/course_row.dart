// import 'package:flutter/material.dart';
// import 'package:smgi.connect/core/constants/app_text_styles.dart';
// import 'package:smgi.connect/features/courses/radiobutton.dart';

// class CourseTile extends StatelessWidget {
//   final String title;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const CourseTile({
//     super.key,
//     required this.title,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final horizontal = MediaQuery.of(context).size.width * 0.04;

//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: horizontal,
//           vertical: 12,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 style: AppTextStyles.fieldTitle.copyWith(
//                   fontSize: 18,
//                   color: isSelected
//                       ? const Color(0xFF9BA3B0)
//                       : const Color(0xFF1A1A1A),
//                 ),
//               ),
//             ),
//             CourseRadio(isSelected: isSelected),
//           ],
//         ),
//       ),
//     );
//   }
// }
