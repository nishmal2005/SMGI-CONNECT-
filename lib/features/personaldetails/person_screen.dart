import 'package:flutter/material.dart';
// import 'package:smgi.connect/features/courses/course_model.dart';
import 'package:smgi.connect/features/courses/course_screen.dart';
import 'package:smgi.connect/features/personaldetails/custom_dropdown.dart';
import 'package:smgi.connect/features/personaldetails/gender.dart';
//import 'package:smgi.connect/features/personaldetails/header.dart';
import 'package:smgi.connect/shared/widgets/app_scaffold.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';

import '../../shared/widgets/custom_input_field.dart';
import '../../shared/widgets/gradient_button.dart';
import '../../shared/widgets/gap.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  // ───────────────── Controllers ─────────────────
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final phoneController = TextEditingController(text: "+91 ");
  final phone2Controller = TextEditingController(text: "+91 ");
  final addressController = TextEditingController();
  final postalCodeController = TextEditingController();
  final emailController = TextEditingController();

  // ───────────────── State ─────────────────
  String gender = "Male";
  String? nationality;
  String? state;
  String? district;

  // ───────────────── Date Picker ─────────────────
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      dobController.text = "${date.day}/${date.month}/${date.year}";
      setState(() {});
    }
  }

  // ───────────────── Validation ─────────────────
  bool get isFormValid =>
      nameController.text.isNotEmpty &&
      dobController.text.isNotEmpty &&
      fatherNameController.text.isNotEmpty &&
      motherNameController.text.isNotEmpty &&
      phoneController.text.length == 14 &&
      phone2Controller.text.length == 14 &&
      addressController.text.isNotEmpty &&
      postalCodeController.text.length == 6 &&
      emailController.text.isNotEmpty &&
      nationality != null &&
      state != null &&
      district != null;

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    phoneController.dispose();
    phone2Controller.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.accent),
                  ),
                ],
              ),
              const Gap(h: 20),

              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Personal Details",
                          style: AppTextStyles.pageTitle,
                        ),
                        const Gap(h: 16),
                        // ───── Name ─────
                        Text("Name", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "Type Your Full Name",
                          controller: nameController,
                          onChanged: (_) => setState(() {}),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),

                        const Gap(h: 16),

                        // ───── DOB ─────
                        Text("Date of Birth", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "DD / MM / YYYY",
                          controller: dobController,
                          readOnly: true,
                          onTap: _pickDate,
                        ),

                        const Gap(h: 16),

                        // ───── Gender ─────
                        Text("Gender", style: AppTextStyles.fieldTitle),
                        const Gap(h: 8),
                        GenderSelector(
                          value: gender,
                          onChanged: (v) {
                            setState(() => gender = v);
                          },
                        ),

                        // ───── FATHER'S NAME ─────
                        const Gap(h: 16),
                        Text("Father's Name", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "Enter Father's Name",
                          controller: fatherNameController,
                          onChanged: (_) => setState(() {}),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                        const Gap(h: 16),

                        // ───── MOTHER'S NAME ─────
                        Text("Mother's Name", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "Enter Mother's Name",
                          controller: motherNameController,
                          onChanged: (_) => setState(() {}),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                        const Gap(h: 16),

                        // ───── CONTACT 1 ─────
                        Text(
                          "Contact Number 1",
                          style: AppTextStyles.fieldTitle,
                        ),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "Phone Number",
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 14,
                          onChanged: (_) => setState(() {}),
                          validator: (v) => v!.length < 14
                              ? "Enter valid phone number"
                              : null,
                        ),
                        const Gap(h: 16),

                        // ───── CONTACT 2 ─────
                        Text(
                          "Contact Number 2",
                          style: AppTextStyles.fieldTitle,
                        ),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "Phone Number 2",
                          controller: phone2Controller,
                          keyboardType: TextInputType.phone,
                          maxLength: 14,
                          onChanged: (_) => setState(() {}),
                          validator: (v) => v!.length < 14
                              ? "Enter valid phone number"
                              : null,
                        ),
                        const Gap(h: 16),

                        // ───── ADDRESS ─────
                        Text("Address", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "Enter Full Address",
                          controller: addressController,
                          maxLines: 6,
                          onChanged: (_) => setState(() {}),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                        const Gap(h: 16),

                        // ───── POSTAL CODE ─────
                        Text("Postal Code", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "Enter Postal Code",
                          controller: postalCodeController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          onChanged: (_) => setState(() {}),
                          validator: (v) =>
                              v!.length != 6 ? "Invalid postal code" : null,
                        ),
                        const Gap(h: 16),

                        // ───── EMAIL ─────
                        Text("Email", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomInputField(
                          hintText: "Enter Email Address",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (v!.isEmpty) return "Required";
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                              return "Invalid email";
                            }
                            return null;
                          },
                        ),
                        const Gap(h: 16),

                        // ───── Nationality ─────
                        Text("Nationality", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomDropdown(
                          hint: "Select Nationality",
                          value: nationality,
                          items: const ["Indian", "Other"],
                          onChanged: (v) {
                            setState(() {
                              nationality = v;
                            });
                          },
                        ),

                        const Gap(h: 16),

                        // ───── State ─────
                        Text("State", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomDropdown(
                          hint: "Select State",
                          value: state,
                          items: const ["Karnataka", "Tamil Nadu", "Kerala"],
                          onChanged: (v) {
                            setState(() {
                              state = v;
                            });
                          },
                        ),
                        const Gap(h: 16),

                        // ───── District ─────
                        Text("District", style: AppTextStyles.fieldTitle),
                        const Gap(h: 6),
                        CustomDropdown(
                          hint: "Select District",
                          value: district,
                          items: const ["Bangalore", "Chennai", "Kochi"],
                          onChanged: (v) {
                            setState(() {
                              district = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(h: 16),
              // ───── Continue Button ─────
              GradientButton(
                text: "Continue",
                enabled: isFormValid,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await Navigator.push<CourseSelectionScreen>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CourseSelectionScreen(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
