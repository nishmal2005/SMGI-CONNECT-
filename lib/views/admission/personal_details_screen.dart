import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../viewmodels/application_viewmodel.dart';
import '../../viewmodels/personal_details_viewmodel.dart';
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

    // Snapshot the values once — same data goes to the API and the aggregate VM.
    final name = _name.text.trim();
    final dob = _dob.text.trim();
    final father = _father.text.trim();
    final mother = _mother.text.trim();
    final phone1 = _phone1.text.trim();
    final phone2 = _phone2.text.trim();
    final address = _address.text.trim();
    final pincode = _pincode.text.trim();
    final email = _email.text.trim();

    final ok = await vm.submit(
      name: name,
      dob: dob,
      father: father,          // ← matches VM param
      mother: mother,          // ← matches VM param
      phone1: phone1,
      phone2: phone2,
      address: address,
      pincode: pincode,
      email: email,
    );

    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Could not save personal details.'),
        ),
      );
      return;
    }

    // Stash in the aggregate application state so the Review screen reads it.
    context.read<ApplicationViewModel>().setPersonal({
      'name': name,
      'gender': vm.gender,
      'email': email,
      'phone1': phone1,
      'phone2': phone2,
      'dob': dob,
      'father_name': father,
      'mother_name': mother,
      'address': address,
      'postal_code': pincode,
      'nationality': vm.nationality,
      'state': vm.state,
      'district': vm.district,
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CourseSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PersonalDetailsViewModel>();

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 4.w),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.accent,
                size: 22.r,
              ),
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
                      validator: _phoneValidator,
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
                      validator: _phone2Validator,
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
                      validator: (v) => (v == null || v.length != 6)
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
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.padding,
              0,
              AppSizes.padding,
              16.h,
            ),
            child: GradientButton(
              text: vm.saving ? 'Saving...' : 'Continue',
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
                  ) &&
                  !vm.saving,
              onTap: () => _onContinue(vm),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text, style: AppTextStyles.fieldTitle);

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  /// Contact 1 — required, 10–15 digits after stripping non-digits.
  String? _phoneValidator(String? v) {
    if (v == null) return 'Required';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 15) {
      return 'Enter 10-15 digits';
    }
    return null;
  }

  /// Contact 2 — optional, but if filled must be 10–15 digits.
  String? _phone2Validator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 15) {
      return 'Enter 10-15 digits';
    }
    return null;
  }
}