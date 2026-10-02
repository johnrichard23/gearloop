import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// The last slide's way out: start browsing as a guest, or log in or sign up.
class OnboardingExitActions extends StatelessWidget {
  const OnboardingExitActions({
    required this.onStartBrowsing,
    required this.onLogin,
    super.key,
  });

  final VoidCallback onStartBrowsing;
  final VoidCallback onLogin;

  static const double _kLinkHeight = 48;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(label: 'Start browsing', onTap: onStartBrowsing),
        const SizedBox(height: AppSpacing.kSpacing8),
        TextButton(
          onPressed: onLogin,
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(_kLinkHeight),
          ),
          child: Text(
            'Log in or sign up',
            style: AppTextStyles.kTextButton.copyWith(
              color: AppColors.kColorPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
