import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/features/payment/payment_screen.dart';
import 'package:smgi.connect/features/refferaldetails/review_card.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import 'package:smgi.connect/shared/widgets/gradient_button.dart';
import 'package:smgi.connect/shared/widgets/warning_popup.dart';

class ReviewDetailsScreen extends StatefulWidget {
  const ReviewDetailsScreen({super.key});

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AppScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Back arrow ONLY (no padding)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => LeaveConfirmationDialog(
                    onLeave: () {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // go back page
                    },
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back, color: AppColors.accent),
            ),

            const SizedBox(height: 8),

            /// PERSONAL INFORMATION CARD
            ReviewCard(
              title: "Personal Information",
              data: {"Name": "Cooper, Kristin", "Age/Gender": "22 / Male"},
            ),

            const SizedBox(height: 8),

            /// COURSE SELECTED SECTION
            ReviewCard(
              title: "Course Selected",
              data: {"Discipline:": "Nursing", "Program": "BSC Nursing"},
            ),

            const SizedBox(height: 8),

            /// REQUIRED DOCUMENTS
            ReviewCard(
              title: "Required Documents",
              data: {
                "Aadhaar Card:": "Uploaded",
                "10th Marks Card": "Uploaded",
              },
            ),

            const SizedBox(height: 8),

            /// REFERRAL CODE
            ReviewCard(
              title: "Referral Code",
              data: {
                "Referral\nSMGI2025REF89\nReferred By:\nAkhil P. (ID: RF12873)":
                    "Applied",
              },
            ),

            const SizedBox(height: 24),

            /// AGREEMENT CHECKBOX + TEXT
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white, // fill - FFFFFF
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFF9BA3B0), // stroke - 9BA3B0
                        width: 1.5, // stroke weight 1.5
                      ),
                    ),
                    child: isChecked
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.accent,
                          )
                        : null,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    "I confirm that all the information provided above is correct and complete to the best of my knowledge and belief.",
                    style: AppTextStyles.body3,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Continue Button
            GradientButton(
              text: "Continue",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PaymentScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
