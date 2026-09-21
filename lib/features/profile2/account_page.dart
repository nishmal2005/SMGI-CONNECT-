// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:smgi.connect/core/constants/app_colors.dart';
// import 'package:smgi.connect/features/profile2/account_detail_card.dart';
// import 'package:smgi.connect/features/profile2/header.dart';
// import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
// import 'package:smgi.connect/shared/widgets/gap.dart';
// import 'package:smgi.connect/shared/widgets/responsive_helper.dart';

// class AccountPage extends StatefulWidget {
//   const AccountPage({super.key});

//   @override
//   State<AccountPage> createState() => _AccountPageState();
// }

// class _AccountPageState extends State<AccountPage> {
//   File? _avatarImage;

//   Future<void> _pickPhoto() async {
//     Navigator.pop(context); // close the bottom sheet first
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => _avatarImage = File(picked.path));
//     }
//   }

//   void _deletePhoto() {
//     Navigator.pop(context); // close the bottom sheet
//     setState(() => _avatarImage = null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isTablet = Responsive.isTablet(context);

//     return AppScaffold(
//       body: SafeArea(
//         child: Center(
//           child: Container(
//             width: isTablet ? 500 : double.infinity,
//             padding: EdgeInsets.symmetric(
//               horizontal: isTablet ? 32 : 20,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Back button (inside body)
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   alignment: Alignment.centerLeft,
//                   icon: const Icon(Icons.arrow_back),
//                   color: AppColors.accent,
//                   onPressed: () => Navigator.pop(context),
//                 ),

//                 const Gap(h: 8),

//                 /// Content
//                 Center(
//                   child: ProfileHeader(
//                     name: 'Cooper, Kristin', // swap for real user name when available
//                     avatarImage: _avatarImage,
//                     onChoosePhoto: _pickPhoto,
//                     onDeletePhoto: _deletePhoto,
//                   ),
//                 ),
//                 const Gap(h: 24),
//                 const AccountDetailsCard(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }