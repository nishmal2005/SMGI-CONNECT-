import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/core/constants/app_colors.dart';
import 'package:smgi.connect/core/constants/app_sizes.dart';
import 'package:smgi.connect/core/constants/app_text_styles.dart';
import 'package:smgi.connect/viewmodels/personal_details_viewmodel.dart';



import '../../widgets/app_scaffold.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/gap.dart';
import '../../widgets/gender_selector.dart';
import '../../widgets/gradient_button.dart';
import 'course_selection_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers are owned by the View (lifecycle), VM only reads values
  // when submitting.
  final _name = TextEditingController();
  final _dob = TextEditingController();
  final _father = TextEditingController();
  final _mother = TextEditingController();
  final _phone1 = TextEditingController(text: '+91 ');
  final _phone2 = TextEditingController(text: '+91 ');
  final _address = TextEditingController();
  final _pincode = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _dob.dispose();
    _father.dispose();
    _mother.dispose();
    _phone1.dispose();
    _phone2.dispose();
    _address.dispose();
    _pincode.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pickDate(PersonalDetailsViewModel vm) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: DateTime(now.year - 17, now.month, now.day),
    );
    if (picked == null) return;
    final formatted =
        '${picked.day.toString().padLeft(2, '0')}/'
        '${picked.month.toString().padLeft(2, '0')}/'
        '${picked.year}';
    _dob.text = formatted;
    vm.setDob(picked);
  }

  Future<void> _onContinue(PersonalDetailsViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    vm.submit(
      name: _name.text.trim(),
      dob: _dob.text.trim(),
      fatherName: _father.text.trim(),
      motherName: _mother.text.trim(),
      phone1: _phone1.text.trim(),
      phone2: _phone2.text.trim(),
      address: _address.text.trim(),
      pincode: _pincode.text.trim(),
      email: _email.text.trim(),
    );

    // Navigation is a UI concern — keep it in the View.
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CourseSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PersonalDetailsViewModel>();

    return AppScaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back ─────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 4.w),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back,
                    color: AppColors.accent, size: 22.r),
              ),
            ),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.padding,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Personal Details',
                          style: AppTextStyles.pageTitle),
                      Gap(h: 16),

                      // ── Name ─────────────────────────────
                      _label('Name'),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: 'Type Your Full Name',
                        controller: _name,
                        onChanged: (_) => setState(() {}),
                        validator: _required,
                      ),
                      Gap(h: 16),

                      // ── DOB ──────────────────────────────
                      _label('Date of Birth'),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: 'DD / MM / YYYY',
                        controller: _dob,
                        readOnly: true,
                        onTap: () => _pickDate(vm),
                        validator: _required,
                      ),
                      Gap(h: 16),

                      // ── Gender ───────────────────────────
                      _label('Gender'),
                      Gap(h: 8),
                      GenderSelector(
                        value: vm.gender,
                        onChanged: vm.setGender,
                      ),
                      Gap(h: 16),

                      // ── Father's name ────────────────────
                      _label("Father's Name"),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: "Enter Father's Name",
                        controller: _father,
                        onChanged: (_) => setState(() {}),
                        validator: _required,
                      ),
                      Gap(h: 16),

                      // ── Mother's name ────────────────────
                      _label("Mother's Name"),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: "Enter Mother's Name",
                        controller: _mother,
                        onChanged: (_) => setState(() {}),
                        validator: _required,
                      ),
                      Gap(h: 16),

                      // ── Contact 1 ────────────────────────
                      _label('Contact Number 1'),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: 'Phone Number',
                        controller: _phone1,
                        keyboardType: TextInputType.phone,
                        maxLength: 14,
                        onChanged: (_) => setState(() {}),
                        validator: (v) =>
                            (v == null || v.trim().length < 14)
                                ? 'Enter valid phone number'
                                : null,
                      ),
                      Gap(h: 16),

                      // ── Contact 2 ────────────────────────
                      _label('Contact Number 2'),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: 'Phone Number 2',
                        controller: _phone2,
                        keyboardType: TextInputType.phone,
                        maxLength: 14,
                        onChanged: (_) => setState(() {}),
                        validator: (v) =>
                            (v == null || v.trim().length < 14)
                                ? 'Enter valid phone number'
                                : null,
                      ),
                      Gap(h: 16),

                      // ── Address ──────────────────────────
                      _label('Address'),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: 'Enter Full Address',
                        controller: _address,
                        maxLines: 6,
                        onChanged: (_) => setState(() {}),
                        validator: _required,
                      ),
                      Gap(h: 16),

                      // ── Pincode ──────────────────────────
                      _label('Postal Code'),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: 'Enter Postal Code',
                        controller: _pincode,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        onChanged: (_) => setState(() {}),
                        validator: (v) =>
                            (v == null || v.length != 6)
                                ? 'Invalid postal code'
                                : null,
                      ),
                      Gap(h: 16),

                      // ── Email ────────────────────────────
                      _label('Email'),
                      Gap(h: 6),
                      CustomInputField(
                        hintText: 'Enter Email Address',
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Required';
                          }
                          final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(v.trim());
                          return ok ? null : 'Invalid email';
                        },
                      ),
                      Gap(h: 16),

                      // ── Nationality ──────────────────────
                      _label('Nationality'),
                      Gap(h: 6),
                      CustomDropdown(
                        hint: 'Select Nationality',
                        value: vm.nationality,
                        items: const ['Indian', 'Other'],
                        onChanged: vm.setNationality,
                      ),
                      Gap(h: 16),

                      // ── State ────────────────────────────
                      _label('State'),
                      Gap(h: 6),
                      CustomDropdown(
                        hint: 'Select State',
                        value: vm.state,
                        items: const [
                          'Karnataka',
                          'Tamil Nadu',
                          'Kerala',
                        ],
                        onChanged: vm.setState,
                      ),
                      Gap(h: 16),

                      // ── District ─────────────────────────
                      _label('District'),
                      Gap(h: 6),
                      CustomDropdown(
                        hint: 'Select District',
                        value: vm.district,
                        items: const [
                          'Bangalore',
                          'Chennai',
                          'Kochi',
                        ],
                        onChanged: vm.setDistrict,
                      ),
                      Gap(h: 24),
                    ],
                  ),
                ),
              ),
            ),

            // ── Continue ────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.padding,
                0,
                AppSizes.padding,
                16.h,
              ),
              child: GradientButton(
                text: 'Continue',
                enabled: vm.canContinue(
                  name: _name.text,
                  dob: _dob.text,
                  father: _father.text,
                  mother: _mother.text,
                  phone1: _phone1.text,
                  phone2: _phone2.text,
                  address: _address.text,
                  pincode: _pincode.text,
                  email: _email.text,
                ),
                onTap: () => _onContinue(vm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: AppTextStyles.fieldTitle);

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
}