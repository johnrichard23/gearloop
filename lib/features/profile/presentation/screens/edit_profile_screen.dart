import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/user_profile_entity.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({required this.user, super.key});

  final UserProfileEntity user;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _fullNameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone ?? '');
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String get _initials {
    final trimmed = widget.user.fullName.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed[0].toUpperCase();
  }

  void _showPhotoUploadComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo upload coming soon!')),
    );
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated!')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.kColorPrimaryLight,
                    backgroundImage: user.avatarUrl != null
                        ? NetworkImage(user.avatarUrl!)
                        : null,
                    child: user.avatarUrl == null
                        ? Text(
                            _initials,
                            style: AppTextStyles.kTextHeading2.copyWith(
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: _showPhotoUploadComingSoon,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.kColorPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.kSpacing24),
            AppTextField(
              label: 'Full Name',
              controller: _fullNameController,
            ),
            const SizedBox(height: AppSpacing.kSpacing16),
            _ReadOnlyTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.kSpacing16),
            AppTextField(
              label: 'Phone',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.kSpacing16),
            _MultilineTextField(
              label: 'Bio',
              controller: _bioController,
              hint: 'Tell renters and hosts a bit about yourself...',
            ),
            const SizedBox(height: AppSpacing.kSpacing32),
            AppButton(
              label: 'Save Changes',
              onTap: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyTextField extends StatelessWidget {
  const _ReadOnlyTextField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      keyboardType: keyboardType,
      style: AppTextStyles.kTextBodyLarge.copyWith(
        color: AppColors.kColorTextSecondary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.kTextLabel,
        filled: true,
        fillColor: AppColors.kColorSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorBorder),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.kSpacing16,
          vertical: AppSpacing.kSpacing12,
        ),
      ),
    );
  }
}

class _MultilineTextField extends StatelessWidget {
  const _MultilineTextField({
    required this.label,
    required this.controller,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      style: AppTextStyles.kTextBodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.kTextLabel,
        hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
          color: AppColors.kColorTextHint,
        ),
        filled: true,
        fillColor: AppColors.kColorSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorPrimary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.kSpacing16,
          vertical: AppSpacing.kSpacing12,
        ),
      ),
    );
  }
}
