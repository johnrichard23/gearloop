import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetLink() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset link sent (UI only)'),
        ),
      );
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.kSpacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter your email and we will send you a reset link.',
                  style: AppTextStyles.kTextBodyMedium,
                ),
                const SizedBox(height: AppSpacing.kSpacing24),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: AppSpacing.kSpacing24),
                AppButton(
                  label: 'Send Reset Link',
                  onTap: _onSendResetLink,
                ),
                const SizedBox(height: AppSpacing.kSpacing16),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Back to login',
                    style: AppTextStyles.kTextBodyMedium.copyWith(
                      color: AppColors.kColorPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? _validateNotEmpty(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  return null;
}

String? _validateEmail(String? value) {
  final emptyError = _validateNotEmpty(value);
  if (emptyError != null) {
    return emptyError;
  }
  final emailRegex = RegExp(r'^[\w.%+-]+@[\w.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(value!.trim())) {
    return 'Enter a valid email address';
  }
  return null;
}
