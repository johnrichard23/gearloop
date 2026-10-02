import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Round filters button with a dot while a filter is on.
class BrowseFilterButton extends StatelessWidget {
  const BrowseFilterButton({
    required this.hasActiveFilter,
    required this.onTap,
    super.key,
  });

  final bool hasActiveFilter;
  final VoidCallback onTap;

  static const double _kSize = 48;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: hasActiveFilter ? 'Filters, one active' : 'Filters',
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: _kSize,
              height: _kSize,
              decoration: BoxDecoration(
                color: AppColors.kColorSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kColorBorder),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: AppColors.kColorTextPrimary,
              ),
            ),
            if (hasActiveFilter)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.kColorAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
