import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// One slot in the [FloatingTabBar].
class FloatingTabItem {
  const FloatingTabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// A translucent pill that floats above the bottom edge, with the middle item
/// raised out of it as a round gold action button.
///
/// [items] must have an odd length; the middle one is the raised action.
class FloatingTabBar extends StatelessWidget {
  const FloatingTabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<FloatingTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const double _kPillHeight = 64;
  static const double _kActionSize = 60;
  // 0 keeps the action centred on the pill; raise it to lift it above the top.
  static const double _kActionLift = 0;
  static const double _kBarHeight = _kPillHeight + _kActionLift;

  int get _centerIndex => items.length ~/ 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.kSpacing16,
          AppSpacing.kSpacing4,
          AppSpacing.kSpacing16,
          AppSpacing.kSpacing8,
        ),
        // The raised action overflows the pill, so the bar is as tall as the
        // action reaches; taps outside a widget's bounds would be lost.
        child: SizedBox(
          height: _kBarHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [_buildPill(), _buildAction()],
          ),
        ),
      ),
    );
  }

  Widget _buildPill() {
    return Container(
      height: _kPillHeight,
      decoration: BoxDecoration(
        color: AppColors.kColorSurface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
        border: Border.all(color: AppColors.kColorBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.kColorTextPrimary.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: i == _centerIndex
                  ? const SizedBox.shrink()
                  : _TabButton(
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildAction() {
    final item = items[_centerIndex];
    return Positioned(
      bottom: (_kPillHeight - _kActionSize) / 2 + _kActionLift / 2,
      child: Semantics(
        button: true,
        label: item.label,
        child: GestureDetector(
          onTap: () => onTap(_centerIndex),
          child: Container(
            width: _kActionSize,
            height: _kActionSize,
            decoration: BoxDecoration(
              color: AppColors.kColorAccent,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.kColorSurface, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kColorAccent.withValues(alpha: 0.45),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              item.selectedIcon,
              size: AppSpacing.kIconXLarge,
              color: AppColors.kColorOnAccent,
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final FloatingTabItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColors.kColorPrimary
        : AppColors.kColorTextSecondary;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: ExcludeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? item.selectedIcon : item.icon,
                size: AppSpacing.kIconLarge,
                color: color,
              ),
              const SizedBox(height: AppSpacing.kSpacing2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.kTextCaption.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
