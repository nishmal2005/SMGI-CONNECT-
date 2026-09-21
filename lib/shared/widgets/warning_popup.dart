import 'package:flutter/material.dart';
import 'package:smgi.connect/shared/widgets/gradient_button.dart';
import '../../core/constants/app_colors.dart';

class LeaveConfirmationDialog extends StatelessWidget {
  final VoidCallback onLeave;

  const LeaveConfirmationDialog({super.key, required this.onLeave});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.80;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/warningicon.png", height: 60),
            const SizedBox(height: 15),

            Text(
              "Leave this page?",
              style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600,
                color: AppColors.black, fontFamily: "Poppins",
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            Text(
              "Your admission form progress will be lost. Are you sure you want to go back?",
              style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400,
                color: AppColors.black, fontFamily: "Poppins",
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            /// Leave Anyway Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE84545)),
                  backgroundColor: const Color(0xFFFFF3F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: onLeave,
                child: const Text(
                  "Leave anyway",
                  style: TextStyle(
                    color: Color(0xFFE84545),
                    fontWeight: FontWeight.w500, fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            /// Stay Button (Gradient)
            GradientButton(
              text: "Stay on this page",
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
