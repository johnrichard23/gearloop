import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Empty list or search results with optional action.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title,
    required this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? action;

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
            color: AppColors.kColorTextHint,
          ),
          const SizedBox(height: AppSpacing.kSpacing16),
          Text(
            title,
            style: AppTextStyles.kTextHeading3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.kSpacing8),
          Text(
            subtitle,
            style: AppTextStyles.kTextBodyMedium,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.kSpacing24),
            action!,
          ],
        ],
      ),
    );
  }
}
