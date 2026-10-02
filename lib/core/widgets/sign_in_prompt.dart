import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import 'app_button.dart';

/// What a guest sees where a feature needs an account: a short reason plus
/// a single "Log in or sign up" button.
class SignInPrompt extends StatelessWidget {
  const SignInPrompt({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.kSpacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSpacing.kIconXLarge,
            color: AppColors.kColorPrimary,
          ),
          const SizedBox(height: AppSpacing.kSpacing16),
          Text(
            title,
            style: AppTextStyles.kTextHeading3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.kSpacing8),
          Text(
            message,
            style: AppTextStyles.kTextBodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.kSpacing24),
          // One entry point: the Log in screen links on to Create account.
          AppButton(
            label: 'Log in or sign up',
            isPill: true,
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
