import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/pending_route.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/legal_notice.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../widgets/auth_pill_field.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_shell.dart';
import '../widgets/auth_switch_link.dart';
import '../widgets/guest_browse_link.dart';

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
    final isLoading = ref.watch(authProvider).isLoading;

    return AuthShell(
      lead: 'Create your ',
      highlight: 'account',
      subtitle: 'Join Rentra to rent and lend gear.',
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthSwitchLink(
            prompt: 'Already have an account?',
            action: 'Log in',
            onTap: () => context.pop(),
          ),
          const GuestBrowseLink(),
        ],
      ),
      onBack: () => context.pop(),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
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
                validator: AuthValidators.required,
              ),
              const SizedBox(height: AppSpacing.kSpacing12),
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
              // One field: the eye toggle lets people check what they typed, so
              // a "Confirm password" box only adds work.
              AuthPillField(
                label: 'Password',
                controller: _passwordController,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: AuthValidators.required,
                onSubmitted: (_) => _onRegister(),
              ),
              const SizedBox(height: AppSpacing.kSpacing24),
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
      ),
    );
  }
}
