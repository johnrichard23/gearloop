import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/repositories/auth_repository_impl.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final success = await ref.read(authProvider.notifier).signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (success) {
      context.go('/home');
      return;
    }

    final message = ref.read(authProvider).errorMessage ??
        'Something went wrong. Please try again.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.kSpacing24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: 'Full name',
                  controller: _fullNameController,
                  validator: _validateNotEmpty,
                ),
                const SizedBox(height: AppSpacing.kSpacing16),
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
                const SizedBox(height: AppSpacing.kSpacing16),
                AppTextField(
                  label: 'Confirm password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: AppSpacing.kSpacing24),
                AppButton(
                  label: 'Register',
                  onTap: _onRegister,
                  isLoading: isLoading,
                ),
                const SizedBox(height: AppSpacing.kSpacing16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Already have an account? Login',
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
