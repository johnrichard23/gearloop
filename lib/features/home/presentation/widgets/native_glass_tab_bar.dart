import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import 'floating_tab_bar.dart';

/// The app's bottom bar: Apple's real Liquid Glass tab bar on iOS 26 and later,
/// and the Flutter-drawn [FloatingTabBar] everywhere else. Older iOS versions
/// only get a flat, edge-to-edge system tab bar from the plugin, which does not
/// match the floating design.
///
/// [items] has five entries with the raised action in the middle, the same
/// contract as [FloatingTabBar].
class AdaptiveTabBar extends StatelessWidget {
  const AdaptiveTabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<FloatingTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final hasLiquidGlass =
        defaultTargetPlatform == TargetPlatform.iOS &&
        PlatformVersion.isIOS26OrLater;
    if (!hasLiquidGlass) {
      return FloatingTabBar(
        items: items,
        currentIndex: currentIndex,
        onTap: onTap,
      );
    }
    return _NativeGlassTabBar(
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}

/// A native `UITabBar` whose middle slot is covered by a round gold button.
///
/// The bar holds all five tabs so they stay evenly spaced; the Post slot sits
/// underneath the gold Post button, a Flutter widget laid on top of it.
class _NativeGlassTabBar extends StatelessWidget {
  const _NativeGlassTabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  static const double _kActionSize = 60;
  static const double _kCenterNudge = 3;
  static const double _kBottomTuck = 16;
  static const double _kIconSize = 18;

  final List<FloatingTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  int get _centerIndex => items.length ~/ 2;

  @override
  Widget build(BuildContext context) {
    final action = items[_centerIndex];
    // Sit just above the home indicator rather than a full safe area above it.
    final bottomInset =
        (MediaQuery.viewPaddingOf(context).bottom - _kBottomTuck).clamp(
          AppSpacing.kSpacing4,
          double.infinity,
        );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.kSpacing4,
        0,
        AppSpacing.kSpacing4,
        bottomInset,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CNTabBar(
            items: [
              for (final item in items)
                CNTabBarItem(
                  label: item.label,
                  customIcon: item.icon,
                  activeCustomIcon: item.selectedIcon,
                ),
            ],
            currentIndex: currentIndex,
            onTap: onTap,
            tint: AppColors.kColorPrimary,
            iconSize: _kIconSize,
            shrinkCentered: false,
          ),
          // The native bar reserves a few points of headroom above its glass,
          // so the pill's centre sits a little above the view's centre.
          Transform.translate(
            offset: const Offset(0, -_kCenterNudge),
            child: Semantics(
              button: true,
              label: action.label,
              child: GestureDetector(
                onTap: () => onTap(_centerIndex),
                child: Container(
                  width: _kActionSize,
                  height: _kActionSize,
                  decoration: BoxDecoration(
                    color: AppColors.kColorAccent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.kColorSurface,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kColorAccent.withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    action.selectedIcon,
                    size: AppSpacing.kIconXLarge,
                    color: AppColors.kColorOnAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
