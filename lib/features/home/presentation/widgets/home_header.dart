import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Top row of Home: the current city on the left, notifications on the right.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.onLocationTap,
    required this.onNotificationsTap,
    super.key,
  });

  final VoidCallback onLocationTap;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _LocationPicker(onTap: onLocationTap)),
        _NotificationsButton(onTap: onNotificationsTap),
      ],
    );
  }
}

/// "Location" label over the current city, with a chevron for a future picker.
class _LocationPicker extends StatelessWidget {
  const _LocationPicker({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Change location, Sorsogon City',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Location',
              style: AppTextStyles.kTextCaption.copyWith(
                color: AppColors.kColorTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.kSpacing2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: AppSpacing.kIconMedium,
                  color: AppColors.kColorPrimary,
                ),
                const SizedBox(width: AppSpacing.kSpacing4),
                // Hard-coded until device location or a saved city exists.
                Text('Sorsogon City', style: AppTextStyles.kTextHeading4),
                const SizedBox(width: AppSpacing.kSpacing4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppSpacing.kIconMedium,
                  color: AppColors.kColorTextSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Round bell button with an unread dot.
class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton({required this.onTap});

  final VoidCallback onTap;

  static const double _kSize = 48;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Notifications',
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
                Icons.notifications_outlined,
                color: AppColors.kColorTextPrimary,
              ),
            ),
            // Always shown until a real unread count exists.
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
