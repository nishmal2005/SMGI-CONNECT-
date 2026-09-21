import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Call this to open the sheet, e.g. from an "Edit" tap:
///   showProfileEditSheet(context);
Future<void> showProfileEditSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const ProfileEditSheet(),
  );
}

class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({super.key});

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Cooper, Kristin');
  final TextEditingController _emailController =
      TextEditingController(text: 'user.email@example.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+91 9904703101');

  File? _avatarImage;

  static const Color labelGrey = Color(0xFF9AA0A6);
  static const Color fieldFill = Color(0xFFF1F2F5);
  static const Color linkBlue = Color(0xFF2E6BE6);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _openEditPhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfilePictureSheet(
        onChoosePhoto: _pickPhoto,
        onDeletePhoto: _deletePhoto,
      ),
    );
  }

  Future<void> _pickPhoto() async {
    Navigator.pop(context); // close the photo-options sheet first
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _avatarImage = File(picked.path));
    }
  }

  void _deletePhoto() {
    Navigator.pop(context); // close the photo-options sheet
    setState(() => _avatarImage = null);
  }

  @override
  Widget build(BuildContext context) {
    // Push the sheet above the keyboard when a field is focused.
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: "Profile" + close button ─────────
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F2F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── Avatar + Edit link ────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF9CC0F0),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFE0E0E0),
                        backgroundImage: _avatarImage != null
                            ? FileImage(_avatarImage!)
                            : const AssetImage(
                                'assets/images/avatar_placeholder.png',
                              ) as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _openEditPhotoSheet,
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: linkBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildLabel('Name'),
              _buildField(_nameController),
              const SizedBox(height: 18),

              _buildLabel('Email'),
              _buildField(_emailController,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 18),

              _buildLabel('Phone Number'),
              _buildField(_phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B2E6B), Color(0xFF16408F)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: save profile changes
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 2),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: labelGrey),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// "Edit profile picture" bottom sheet — Choose photo / Delete photo
/// Purely a display sheet — no File/ImagePicker/setState knowledge.
/// -----------------------------------------------------------------------
class _EditProfilePictureSheet extends StatelessWidget {
  final VoidCallback onChoosePhoto;
  final VoidCallback onDeletePhoto;

  const _EditProfilePictureSheet({
    required this.onChoosePhoto,
    required this.onDeletePhoto,
  });

  static const Color optionFill = Color(0xFFF1F2F5);
  static const Color deleteRed = Color(0xFFE94B4B);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Edit profile picture',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: optionFill,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _optionTile(
              icon: Icons.image_outlined,
              iconColor: Colors.black87,
              label: 'Choose photo',
              labelColor: Colors.black87,
              onTap: onChoosePhoto,
            ),
            const SizedBox(height: 12),
            _optionTile(
              icon: Icons.delete_outline,
              iconColor: deleteRed,
              label: 'Delete photo',
              labelColor: deleteRed,
              onTap: onDeletePhoto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: optionFill,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}