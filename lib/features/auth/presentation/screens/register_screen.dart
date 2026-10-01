import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/legal_notice.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../widgets/auth_pill_field.dart';
import '../widgets/auth_shell.dart';

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

    final success = await ref
        .read(authProvider.notifier)
        .signUpWithEmail(
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

    final message =
        ref.read(authProvider).errorMessage ??
        'Something went wrong. Please try again.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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

    return AuthShell(
      lead: 'Create your ',
      highlight: 'account',
      subtitle: 'Join Rentra to rent and lend gear.',
      footer: TextButton(
        onPressed: () => context.pop(),
        child: Text.rich(
          TextSpan(
            text: 'Already have an account? ',
            style: AppTextStyles.kTextBodyMedium,
            children: [
              TextSpan(
                text: 'Log in',
                style: AppTextStyles.kTextBodyMedium.copyWith(
                  color: AppColors.kColorPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      onBack: () => context.pop(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthPillField(
              label: 'Full name',
              controller: _fullNameController,
              hint: 'Your name',
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              validator: _validateNotEmpty,
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            AuthPillField(
              label: 'Email',
              controller: _emailController,
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: _validateEmail,
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            AuthPillField(
              label: 'Password',
              controller: _passwordController,
              isPassword: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: _validateNotEmpty,
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            AuthPillField(
              label: 'Confirm password',
              controller: _confirmPasswordController,
              isPassword: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              validator: _validateConfirmPassword,
              onSubmitted: (_) => _onRegister(),
            ),
            const SizedBox(height: AppSpacing.kSpacing20),
            AppButton(
              label: 'Create account',
              onTap: _onRegister,
              isLoading: isLoading,
              isPill: true,
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            const LegalNotice(prefix: 'By creating an account'),
          ],
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
