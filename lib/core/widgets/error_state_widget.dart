import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import 'app_button.dart';

/// Full-screen or section error with retry action.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.kSpacing24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: AppSpacing.kIconXLarge,
            color: AppColors.kColorError,
          ),
          const SizedBox(height: AppSpacing.kSpacing16),
          Text(
            message,
            style: AppTextStyles.kTextBodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.kSpacing24),
          AppButton(
            label: 'Retry',
            onTap: onRetry,
          ),
        ],
      ),
    );
  }
}
