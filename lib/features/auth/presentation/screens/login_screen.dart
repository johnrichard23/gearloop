import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../widgets/auth_pill_field.dart';
import '../widgets/auth_shell.dart';
import '../widgets/social_sign_in_button.dart';

/// Log in: a full-screen photo with the form on a centred frosted-glass panel.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final success = await ref
        .read(authProvider.notifier)
        .signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    _afterSignIn(success);
  }

  Future<void> _onSocial(SocialProvider provider) async {
    final notifier = ref.read(authProvider.notifier);
    final success = switch (provider) {
      SocialProvider.apple => await notifier.signInWithApple(),
      SocialProvider.google => await notifier.signInWithGoogle(),
      SocialProvider.facebook => await notifier.signInWithFacebook(),
    };
    _afterSignIn(success);
  }

  void _afterSignIn(bool success) {
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

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      lead: 'Welcome ',
      highlight: 'back',
      subtitle: 'Log in to rent or lend gear near you.',
      footer: _buildFooter(),
      child: _buildForm(),
    );
  }

  Widget _buildForm() {
    final isLoading = ref.watch(authProvider).isLoading;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            validator: _validateNotEmpty,
            onSubmitted: (_) => _onLogin(),
            labelTrailing: GestureDetector(
              onTap: () => context.go('/forgot-password'),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.kSpacing4,
                ),
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.kTextLabel.copyWith(
                    color: AppColors.kColorPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.kSpacing16),
          AppButton(
            label: 'Log in',
            onTap: _onLogin,
            isLoading: isLoading,
            isPill: true,
          ),
          const SizedBox(height: AppSpacing.kSpacing16),
          const _OrDivider(label: 'or continue with'),
          const SizedBox(height: AppSpacing.kSpacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialSignInButton(
                provider: SocialProvider.apple,
                onTap: () => _onSocial(SocialProvider.apple),
              ),
              const SizedBox(width: AppSpacing.kSpacing16),
              SocialSignInButton(
                provider: SocialProvider.google,
                onTap: () => _onSocial(SocialProvider.google),
              ),
              const SizedBox(width: AppSpacing.kSpacing16),
              SocialSignInButton(
                provider: SocialProvider.facebook,
                onTap: () => _onSocial(SocialProvider.facebook),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return TextButton(
      onPressed: () => context.push('/register'),
      child: Text.rich(
        TextSpan(
          text: 'New to Rentra? ',
          style: AppTextStyles.kTextBodyMedium,
          children: [
            TextSpan(
              text: 'Sign up',
              style: AppTextStyles.kTextBodyMedium.copyWith(
                color: AppColors.kColorPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    const line = Expanded(
      child: Divider(height: 1, color: AppColors.kColorBorderDark),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing12,
          ),
          child: Text(label, style: AppTextStyles.kTextBodySmall),
        ),
        line,
      ],
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
