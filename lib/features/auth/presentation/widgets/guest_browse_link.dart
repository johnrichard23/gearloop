import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/pending_route.dart';

/// A quiet "Browse as guest" link for the auth screens, so someone who landed
/// here by mistake can leave without creating an account or logging in.
class GuestBrowseLink extends StatelessWidget {
  const GuestBrowseLink({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // Tight vertical padding so it sits close to the sign-up / log-in line
      // above instead of floating a full 48pt tap target away.
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.kSpacing16,
          vertical: AppSpacing.kSpacing4,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        // Browsing instead of signing in drops any screen they were headed to.
        PendingRoute.clear();
        context.go('/home');
      },
      child: Text(
        'Browse as guest',
        style: AppTextStyles.kTextBodyMedium.copyWith(
          color: AppColors.kColorPrimary,
        ),
      ),
    );
  }
}
