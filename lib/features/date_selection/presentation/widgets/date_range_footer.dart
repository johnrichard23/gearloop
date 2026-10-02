import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

/// The bottom bar of the dates screen: Clear on the left, Apply on the right.
class DateRangeFooter extends StatelessWidget {
  const DateRangeFooter({
    required this.canClear,
    required this.canApply,
    required this.onClear,
    required this.onApply,
    super.key,
  });

  final bool canClear;
  final bool canApply;
  final VoidCallback onClear;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.kSpacing16,
          AppSpacing.kSpacing8,
          AppSpacing.kSpacing16,
          AppSpacing.kSpacing16,
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Clear',
                isOutlined: true,
                isPill: true,
                isEnabled: canClear,
                onTap: onClear,
              ),
            ),
            const SizedBox(width: AppSpacing.kSpacing12),
            Expanded(
              child: AppButton(
                label: 'Apply',
                isPill: true,
                isEnabled: canApply,
                onTap: onApply,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
