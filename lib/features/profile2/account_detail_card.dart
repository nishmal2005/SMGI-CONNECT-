import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/profile2/detail_item.dart';
import 'package:smgi.connect/features/profile2/edit_profile_screen.dart';
//import 'package:smgi.connect/features/profile2/profile_edit_sheet.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import 'package:smgi.connect/shared/widgets/back_appbar.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';

class AccountDetailsCard extends StatelessWidget {
  const AccountDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AppScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: BackAppBar(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// USER IMAGE
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/person.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// NAME TEXT
            const Text(
              'Cooper, Kristin',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),

            const SizedBox(height: 8),

            /// EDIT LINK — opens the bottom sheet, not a pushed route
            InkWell(
              onTap: () {
                showProfileEditSheet(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Edit',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: width * 0.08),

            /// ACCOUNT DETAILS CARD
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Account Details', style: AppTextStyles.pageTitle),
                  Gap(h: 12),
                  Divider(color: AppColors.lightGray),
                  Gap(h: 12),

                  DetailItem(
                    label: 'Name',
                    value: Text(
                      'Cooper, Kristin',
                      style: AppTextStyles.inputText,
                    ),
                  ),
                  Gap(h: 12),

                  DetailItem(
                    label: 'Email',
                    value: Text(
                      'user.email@example.com',
                      style: AppTextStyles.inputText,
                    ),
                  ),
                  Gap(h: 12),

                  DetailItem(
                    label: 'Mobile',
                    value: Text(
                      '+91 9904703101',
                      style: AppTextStyles.inputText,
                    ),
                  ),
                  Gap(h: 12),

                  DetailItem(
                    label: 'Course',
                    value: Text(
                      'BSc Nursing',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0A4D9F),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}