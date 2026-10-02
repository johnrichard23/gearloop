import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/pending_route.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../widgets/auth_pill_field.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_shell.dart';
import '../widgets/auth_switch_link.dart';
import '../widgets/guest_browse_link.dart';
import '../widgets/social_sign_in_button.dart';

/// Log in: a flat cream AuthShell layout for the sign-in form.
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
      PendingRoute.goAfterAuth(context);
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
      child: AutofillGroup(
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
              validator: AuthValidators.email,
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            AuthPillField(
              label: 'Password',
              controller: _passwordController,
              isPassword: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: AuthValidators.required,
              onSubmitted: (_) => _onLogin(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go('/forgot-password'),
                style: TextButton.styleFrom(
                  minimumSize: const Size(
                    AppSpacing.kSpacing48,
                    AppSpacing.kSpacing48,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.kSpacing16,
                  ),
                ),
                child: Text(
                  'Forgot password?',
                  style: AppTextStyles.kTextLabel.copyWith(
                    color: AppColors.kColorPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.kSpacing8),
            AppButton(
              label: 'Log in',
              onTap: _onLogin,
              isLoading: isLoading,
              isPill: true,
            ),
            const SizedBox(height: AppSpacing.kSpacing24),
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
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthSwitchLink(
          prompt: 'New to Rentra?',
          action: 'Sign up',
          onTap: () => context.push('/register'),
        ),
        const GuestBrowseLink(),
      ],
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
