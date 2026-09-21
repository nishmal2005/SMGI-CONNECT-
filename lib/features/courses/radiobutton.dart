// import 'package:flutter/material.dart';
// import 'package:smgi.connect/core/constants/app_colors.dart';

// class CourseRadio extends StatelessWidget {
//   final bool isSelected;

//   const CourseRadio({super.key, required this.isSelected});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size.width * 0.045;

//     return Container(
//       height: size,
//       width: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: isSelected ? AppColors.primary : const Color(0xFF9BA3B0),
//           width: 1.5,
//         ),
//       ),
//       alignment: Alignment.center,
//       child: isSelected
//           ? Container(
//               height: size * 0.5,
//               width: size * 0.5,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColors.primary,
//               ),
//             )
//           : null,
//     );
//   }
// }
