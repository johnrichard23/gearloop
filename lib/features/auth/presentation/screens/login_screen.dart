import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.kSpacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.kSpacing32),
                Text(
                  'GearLoop',
                  style: AppTextStyles.kTextHeading1.copyWith(
                    color: AppColors.kColorPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.kSpacing48),
                AppTextField(
                  label: 'Email',
                  controller: _emailController,
                  hint: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: AppSpacing.kSpacing16),
                AppTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validateNotEmpty,
                ),
                const SizedBox(height: AppSpacing.kSpacing8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go('/forgot-password'),
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.kTextBodyMedium.copyWith(
                        color: AppColors.kColorPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.kSpacing24),
                AppButton(
                  label: 'Login',
                  onTap: _onLogin,
                ),
                const SizedBox(height: AppSpacing.kSpacing16),
                TextButton(
                  onPressed: () => context.push('/register'),
                  child: Text(
                    "Don't have an account? Register",
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
