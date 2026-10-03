import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// The single search field, used on Browse and Home. Filters the loaded
/// listings by title or category. While it has focus the border thickens and
/// the search icon turns green, so it is clear the field is active.
class BrowseSearchField extends StatefulWidget {
  const BrowseSearchField({
    required this.onChanged,
    this.onSubmitted,
    this.initialText = '',
    this.controller,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final ValueChanged<String> onChanged;

  /// Called when the person taps the keyboard's search key.
  final ValueChanged<String>? onSubmitted;

  /// Text the field starts with, for example the query Browse already holds.
  final String initialText;

  /// Supply these to read or drive the field from outside; otherwise the
  /// field makes and disposes its own.
  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// Opens the keyboard as soon as the field appears.
  final bool autofocus;

  @override
  State<BrowseSearchField> createState() => _BrowseSearchFieldState();
}

class _BrowseSearchFieldState extends State<BrowseSearchField> {
  static const double _kBorderWidth = 1;
  static const double _kFocusedBorderWidth = 2;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
    _focusNode = widget.focusNode ?? FocusNode();
    // Rebuild on focus or text changes for the icon colour and clear button.
    _focusNode.addListener(_refresh);
    _controller.addListener(_refresh);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_refresh);
    _controller.removeListener(_refresh);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    // Keep the keyboard up so the next query can be typed straight away.
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      textInputAction: TextInputAction.search,
      // Brand and model names ("Fujifilm xt20") are not words to "correct".
      autocorrect: false,
      style: AppTextStyles.kTextBodyMedium,
      decoration: InputDecoration(
        hintText: 'Search gear near you',
        hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
          color: AppColors.kColorTextHint,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: _focusNode.hasFocus
              ? AppColors.kColorPrimary
              : AppColors.kColorTextSecondary,
        ),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear search',
                onPressed: _clear,
                icon: const Icon(
                  Icons.close,
                  size: AppSpacing.kIconMedium,
                  color: AppColors.kColorTextSecondary,
                ),
              ),
        filled: true,
        fillColor: AppColors.kColorSurface,
        constraints: const BoxConstraints(minHeight: AppSpacing.kSpacing48),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.kSpacing16,
          vertical: AppSpacing.kSpacing12,
        ),
        border: _pillBorder(AppColors.kColorBorder, _kBorderWidth),
        enabledBorder: _pillBorder(AppColors.kColorBorder, _kBorderWidth),
        focusedBorder: _pillBorder(
          AppColors.kColorPrimary,
          _kFocusedBorderWidth,
        ),
      ),
    );
  }

  static OutlineInputBorder _pillBorder(Color color, double width) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
        borderSide: BorderSide(color: color, width: width),
      );
}
