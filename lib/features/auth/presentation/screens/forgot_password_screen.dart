import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../utils/auth_validators.dart';
import '../widgets/auth_pill_field.dart';
import '../widgets/auth_shell.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  /// The address the reset link was "sent" to; non-null shows the done state.
  String? _sentTo;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetLink() {
    if (_formKey.currentState?.validate() ?? false) {
      // UI only: no reset use case exists yet, so nothing is sent.
      setState(() => _sentTo = _emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentTo = _sentTo;
    return AuthShell(
      lead: sentTo == null ? 'Reset your ' : 'Check your ',
      highlight: sentTo == null ? 'password' : 'email',
      subtitle: sentTo == null
          ? 'Enter your email and we will send you a reset link.'
          : 'If an account exists for $sentTo, a reset link is on its way.',
      onBack: () => context.go('/login'),
      child: sentTo == null ? _buildForm() : _buildSent(),
    );
  }

  Widget _buildForm() {
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
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: AuthValidators.email,
            onSubmitted: (_) => _onSendResetLink(),
          ),
          const SizedBox(height: AppSpacing.kSpacing24),
          AppButton(
            label: 'Send reset link',
            onTap: _onSendResetLink,
            isPill: true,
          ),
        ],
      ),
    );
  }

  /// Ending state: say what happened and what to do next, with a way forward.
  Widget _buildSent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Open the link in that email to choose a new password. '
          'Nothing there? Check your spam folder.',
          style: AppTextStyles.kTextBodyMedium.copyWith(
            color: AppColors.kColorTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.kSpacing24),
        AppButton(
          label: 'Back to log in',
          onTap: () => context.go('/login'),
          isPill: true,
        ),
        const SizedBox(height: AppSpacing.kSpacing8),
        TextButton(
          onPressed: () => setState(() => _sentTo = null),
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(AppSpacing.kSpacing48),
          ),
          child: Text(
            'Use a different email',
            style: AppTextStyles.kTextBodyMedium.copyWith(
              color: AppColors.kColorPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
