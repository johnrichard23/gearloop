import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/accent_headline.dart';

/// Common frame for the auth screens: a flat cream page with an optional back
/// button, a display headline whose [highlight] word gets the hand-drawn
/// underline, a [subtitle], and the screen's [child] (the form).
///
/// An optional [footer] (the "other way in" link) is pinned to the bottom of the
/// screen, within thumb reach, and follows the form when the screen is short.
///
/// On entry the headline, subtitle and form fade up one after another and the
/// underline draws itself.
class AuthShell extends StatefulWidget {
  const AuthShell({
    required this.lead,
    required this.highlight,
    required this.subtitle,
    required this.child,
    this.footer,
    this.onBack,
    super.key,
  });

  final String lead;
  final String highlight;
  final String subtitle;
  final Widget child;

  /// Pinned to the bottom, for example a "New here? Sign up" link.
  final Widget? footer;

  /// Shows a back button at the top left when set.
  final VoidCallback? onBack;

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell>
    with SingleTickerProviderStateMixin {
  static const Duration _kEntrance = Duration(milliseconds: 900);
  static const double _kRise = 14;
  static const double _kBackSize = 44;

  late final AnimationController _entrance;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(vsync: this, duration: _kEntrance);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Widget _staged(double begin, double end, Widget child) {
    final t = Interval(
      begin,
      end,
      curve: Curves.easeOutCubic,
    ).transform(_entrance.value);
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, _kRise * (1 - t)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.kColorBackground,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.kSpacing24,
                vertical: AppSpacing.kSpacing16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 2 * AppSpacing.kSpacing16,
                ),
                child: AnimatedBuilder(
                  animation: _entrance,
                  builder: (context, _) => Column(
                    mainAxisAlignment: widget.footer == null
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTopRow(),
                      // With a footer the slack on tall screens is shared above
                      // and below the form, not dumped above the footer alone.
                      if (widget.footer == null)
                        _buildBody()
                      else ...[
                        _buildBody(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppSpacing.kSpacing16,
                          ),
                          child: _staged(0.3, 1, Center(child: widget.footer)),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.kSpacing32),
        _staged(
          0,
          0.5,
          Align(
            alignment: Alignment.centerLeft,
            child: AccentHeadline(
              lead: widget.lead,
              highlight: widget.highlight,
              swoosh: Interval(
                0.5,
                1,
                curve: Curves.easeInOut,
              ).transform(_entrance.value),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.kSpacing8),
        _staged(
          0.15,
          0.65,
          Text(widget.subtitle, style: AppTextStyles.kTextBodyLarge),
        ),
        const SizedBox(height: AppSpacing.kSpacing24),
        _staged(0.3, 1, widget.child),
      ],
    );
  }

  Widget _buildTopRow() {
    final onBack = widget.onBack;
    return SizedBox(
      height: _kBackSize,
      child: Align(
        alignment: Alignment.centerLeft,
        child: onBack == null ? null : _BackButton(onTap: onBack),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  static const double _kSize = 44;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: AppColors.kColorSurface,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.kColorBorderDark),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: _kSize,
            height: _kSize,
            child: Icon(
              Icons.arrow_back,
              size: AppSpacing.kIconMedium,
              color: AppColors.kColorTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
