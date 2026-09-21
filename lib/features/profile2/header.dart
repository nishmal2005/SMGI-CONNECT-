// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:smgi.connect/core/constants/app_colors.dart';
// import 'package:smgi.connect/core/constants/app_text_styles.dart';
// import 'package:smgi.connect/shared/widgets/gap.dart';
// import 'package:smgi.connect/shared/widgets/responsive_helper.dart';

// class ProfileHeader extends StatelessWidget {
//   final String name;
//   final File? avatarImage;
//   final VoidCallback onChoosePhoto;
//   final VoidCallback onDeletePhoto;

//   const ProfileHeader({
//     super.key,
//     required this.name,
//     required this.avatarImage,
//     required this.onChoosePhoto,
//     required this.onDeletePhoto,
//   });

//   void _openEditPhotoSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _EditProfilePictureSheet(
//         onChoosePhoto: onChoosePhoto,
//         onDeletePhoto: onDeletePhoto,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isTablet = Responsive.isTablet(context);
//     final imageSize = isTablet ? 100.0 : 88.0;

//     return Column(
//       children: [
//         Text(name, style: AppTextStyles.pageTitle),
//         const Gap(h: 20),

//         CircleAvatar(
//           radius: imageSize / 2,
//           backgroundColor: AppColors.backgroundStrokeone,
//           child: CircleAvatar(
//             radius: (imageSize / 2) - 2,
//             backgroundImage: avatarImage != null
//                 ? FileImage(avatarImage!)
//                 : const AssetImage('assets/images/person.jpeg') as ImageProvider,
//           ),
//         ),

//         const Gap(h: 8),

//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.edit, size: 14, color: Color(0xFF0A4D9F)),
//             const Gap(w: 6),
//             GestureDetector(
//               onTap: () => _openEditPhotoSheet(context),
//               child: const Text(
//                 'Edit',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF0A4D9F),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// /// -----------------------------------------------------------------------
// /// "Edit profile picture" bottom sheet — pure display, no state of its own.
// /// -----------------------------------------------------------------------
// class _EditProfilePictureSheet extends StatelessWidget {
//   final VoidCallback onChoosePhoto;
//   final VoidCallback onDeletePhoto;

//   const _EditProfilePictureSheet({
//     required this.onChoosePhoto,
//     required this.onDeletePhoto,
//   });

//   static const Color optionFill = Color(0xFFF1F2F5);
//   static const Color deleteRed = Color(0xFFE94B4B);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 const Expanded(
//                   child: Text(
//                     'Edit profile picture',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: Container(
//                     width: 30,
//                     height: 30,
//                     decoration: const BoxDecoration(
//                       color: optionFill,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.close, size: 16),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 18),
//             _optionTile(
//               icon: Icons.image_outlined,
//               iconColor: Colors.black87,
//               label: 'Choose photo',
//               labelColor: Colors.black87,
//               onTap: onChoosePhoto,
//             ),
//             const SizedBox(height: 12),
//             _optionTile(
//               icon: Icons.delete_outline,
//               iconColor: deleteRed,
//               label: 'Delete photo',
//               labelColor: deleteRed,
//               onTap: onDeletePhoto,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _optionTile({
//     required IconData icon,
//     required Color iconColor,
//     required String label,
//     required Color labelColor,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         decoration: BoxDecoration(
//           color: optionFill,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: iconColor, size: 20),
//             const SizedBox(width: 12),
//             Text(
//               label,
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: labelColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }