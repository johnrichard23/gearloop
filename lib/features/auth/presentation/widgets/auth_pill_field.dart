import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Pill-shaped text field with its label above, used on the auth screens.
/// Set [isPassword] to get a show/hide eye toggle.
class AuthPillField extends StatefulWidget {
  const AuthPillField({
    required this.label,
    required this.controller,
    this.hint,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.onSubmitted,
    this.labelTrailing,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  /// Shown at the right end of the label row, e.g. a "Forgot password?" link.
  final Widget? labelTrailing;

  @override
  State<AuthPillField> createState() => _AuthPillFieldState();
}

class _AuthPillFieldState extends State<AuthPillField> {
  bool _obscured = true;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.kSpacing16,
            right: AppSpacing.kSpacing8,
            bottom: AppSpacing.kSpacing4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: AppTextStyles.kTextLabel.copyWith(
                  color: AppColors.kColorTextPrimary,
                ),
              ),
              if (widget.labelTrailing != null) widget.labelTrailing!,
            ],
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscured,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          onFieldSubmitted: widget.onSubmitted,
          style: AppTextStyles.kTextBodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
              color: AppColors.kColorTextHint,
            ),
            filled: true,
            fillColor: AppColors.kColorSurface.withValues(alpha: 0.85),
            border: _border(AppColors.kColorBorderDark),
            enabledBorder: _border(AppColors.kColorBorderDark),
            focusedBorder: _border(AppColors.kColorPrimary),
            errorBorder: _border(AppColors.kColorError),
            focusedErrorBorder: _border(AppColors.kColorError),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.kSpacing20,
              vertical: AppSpacing.kSpacing12,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _obscured ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured ? Icons.visibility_off : Icons.visibility,
                      size: AppSpacing.kIconMedium,
                      color: AppColors.kColorTextSecondary,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
