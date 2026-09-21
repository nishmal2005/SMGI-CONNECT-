import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/markscard/upload_marks_card_screen.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import 'package:smgi.connect/shared/widgets/gap.dart';

//model
class CourseCategory {
  final String title;
  final IconData icon;
  final Color iconColor;

  const CourseCategory({
    required this.title,
    required this.icon,
    required this.iconColor,
  });
}

class CourseSelectionScreen extends StatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  State<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  int? selectedIndex;

  final categories = const [
    CourseCategory(
      title: 'Nursing',
      icon: Icons.favorite,
      iconColor: Color(0xFF2FAE60),
    ),
    CourseCategory(
      title: 'Paramedical',
      icon: Icons.medical_services,
      iconColor: Color(0xFF1E9E8C),
    ),
    CourseCategory(
      title: 'Pharmacy',
      icon: Icons.medication,
      iconColor: Color(0xFFF5A623),
    ),
    CourseCategory(
      title: 'AHS (Allied Health Sciences)',
      icon: Icons.medical_information,
      iconColor: Color(0xFF7B4FE0),
    ),
    CourseCategory(
      title: 'Physiotherapy Programs',
      icon: Icons.accessibility_new,
      iconColor: Color(0xFF1E9E8C),
    ),
    CourseCategory(
      title: 'LAW',
      icon: Icons.gavel,
      iconColor: Color(0xFFE0405C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).size.width * 0.04;

    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Back Button (simple widget, NOT reusable)
            Padding(
              padding: EdgeInsets.all(padding),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFF5A623),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Text('Course Selection', style: AppTextStyles.pageTitle),
            ),

            const Gap(h: 16),

            Expanded(
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedIndex == index;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      color: isSelected
                          ? const Color(0xFFF5F7FA)
                          : Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: padding,
                        vertical: padding,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            category.icon,
                            color: category.iconColor,
                            size: 22,
                          ),
                          const Gap(w: 16),
                          Expanded(
                            child: Text(
                              category.title,
                              style: AppTextStyles.fieldTitle.copyWith(
                                fontSize: 16,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(padding),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UploadMarksCardScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0A1E4D), Color(0xFF15347A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
