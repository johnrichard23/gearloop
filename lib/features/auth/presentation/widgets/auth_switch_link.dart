import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// The "other way in" line under an auth form, e.g. "New to Rentra? Sign up".
/// The [action] part is bold and in the primary color.
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    required this.prompt,
    required this.action,
    required this.onTap,
    super.key,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text.rich(
        TextSpan(
          text: '$prompt ',
          style: AppTextStyles.kTextBodyMedium,
          children: [
            TextSpan(
              text: action,
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
