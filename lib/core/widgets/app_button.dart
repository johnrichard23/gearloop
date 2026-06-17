import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Full-width primary or outlined action button.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = color ?? AppColors.kColorPrimary;

    return SizedBox(
      width: double.infinity,
      child: isOutlined ? _buildOutlined(buttonColor) : _buildFilled(buttonColor),
    );
  }

  Widget _buildFilled(Color buttonColor) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: buttonColor.withValues(alpha: 0.6),
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: _buildChild(Colors.white, outlined: false),
    );
  }

  Widget _buildOutlined(Color buttonColor) {
    return OutlinedButton(
      onPressed: isLoading ? null : onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        disabledForegroundColor: buttonColor.withValues(alpha: 0.6),
        side: BorderSide(color: buttonColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: _buildChild(buttonColor, outlined: true),
    );
  }

  Widget _buildChild(Color indicatorColor, {required bool outlined}) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: indicatorColor,
        ),
      );
    }
    return Text(
      label,
      style: AppTextStyles.kTextButton.copyWith(
        color: outlined ? indicatorColor : Colors.white,
      ),
    );
  }
}
