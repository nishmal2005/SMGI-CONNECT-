import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'package:smgi.connect/core/utils/adhar_mask_formatter.dart';
import 'package:smgi.connect/features/aadhar/provider/adhar_provider.dart';
import 'package:smgi.connect/features/aadhar/widgets/card.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/custom_input_field.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/warning_popup.dart';
import '../../personaldetails/person_screen.dart';

class AadhaarVerificationScreen extends StatefulWidget {
  const AadhaarVerificationScreen({super.key});

  @override
  State<AadhaarVerificationScreen> createState() =>
      _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends State<AadhaarVerificationScreen> {
  late final TextEditingController aadhaarController;
  Future<void> _pickImage(BuildContext context, {required bool isFront}) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null) {
      debugPrint("IMAGE PICK CANCELLED");
      return;
    }

    final file = File(result.files.single.path!);
    final provider = context.read<AadhaarProvider>();

    if (isFront) {
      provider.setFrontImage(file);
    } else {
      provider.setBackImage(file);
    }
  }

  @override
  void initState() {
    super.initState();
    aadhaarController = TextEditingController();
  }

  @override
  void dispose() {
    aadhaarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AadhaarProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => LeaveConfirmationDialog(
                      onLeave: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
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
                    const Text(
                      "Aadhaar Verification",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                        fontFamily: "Poppins",
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Enter Aadhaar Number (12 Digits)",
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    CustomInputField(
                      hintText: "XXXX XXXX 1234",
                      controller: aadhaarController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      onChanged: provider.setAadhaar,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      "Upload Aadhaar Card (Front)",
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    UploadCard(
                      height: 220,
                      width: screenWidth,
                      assetPath: "assets/images/download.png",
                      isFileSelected: provider.isFrontUploaded,
                      onTap: () => _pickImage(context, isFront: true),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Upload Aadhaar Card (Back)",
                      style: AppTextStyles.body3.copyWith(
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    UploadCard(
                      height: 220,
                      width: screenWidth,
                      assetPath: "assets/images/download.png",
                      isFileSelected: provider.isBackUploaded,
                      onTap: () => _pickImage(context, isFront: false),
                    ),

                    const SizedBox(height: 40),

                    GradientButton(
                      text: "Continue",
                      enabled: provider.canContinue,
                      onTap: provider.canContinue
                          ? () {
                              debugPrint("SUBMIT CLICKED");
                              debugPrint("AADHAAR: ${provider.aadhaar}");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PersonalDetailsPage(),
                                ),
                              );
                            }
                          : null,
                    ),

                    const SizedBox(height: 16),
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
