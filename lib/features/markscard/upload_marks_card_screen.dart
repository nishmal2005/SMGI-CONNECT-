import 'package:flutter/material.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/features/markscard/upload_card.dart';
import 'package:smgi.connect/features/markscard/upload_file_status.dart';
import 'package:smgi.connect/features/referalcode/applyreferalcode.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import 'package:smgi.connect/shared/widgets/gradient_button.dart';
import 'package:smgi.connect/shared/widgets/warning_popup.dart';

class UploadMarksCardScreen extends StatelessWidget {
  const UploadMarksCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back arrow
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
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    const Text(
                      "Upload 10th Mark Card",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600, // SemiBold
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Section header
                    const Text(
                      "Upload Marks Card",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400, // Regular
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Dashed Upload Card
                    UploadCardDashed(width: width, height: 230, onTap: () {}),
                    const SizedBox(height: 30),

                    const UploadFileStatusCard(),
                    const SizedBox(height: 40),

                    /// Continue Button
                    GradientButton(
                      text: "Continue",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ApplyReferralPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
