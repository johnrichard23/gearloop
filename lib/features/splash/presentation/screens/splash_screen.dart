import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/splash_destination_provider.dart';
import '../widgets/rentra_mark.dart';

/// Launch screen: the Rentra mark and wordmark, then a hand-off to the next
/// route. Total ≈ 1.4 s: rings interlock (0–0.6 s), wordmark fades up
/// (0.4–1.0 s), hold until 1.4 s.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _kTotal = Duration(milliseconds: 1400);
  static const Duration _kReducedMotionHold = Duration(milliseconds: 600);
  static const double _kGlowSize = 300;
  static const double _kGlowAlpha = 0.22;
  static const double _kWordmarkRise = 8;

  late final AnimationController _controller;
  late final Animation<double> _rings;
  late final Animation<double> _wordmark;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _kTotal);
    _rings = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.43, curve: Curves.easeOutCubic),
    );
    _wordmark = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.29, 0.71, curve: Curves.easeOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _run();
  }

  Future<void> _run() async {
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      await Future<void>.delayed(_kReducedMotionHold);
    } else {
      await _controller.forward();
    }
    if (!mounted) return;
    context.go(ref.read(splashDestinationProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.kColorPrimary,
        body: Semantics(
          label: 'Rentra',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(child: _buildGlow()),
              Center(child: _buildLockup()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlow() {
    return FadeTransition(
      opacity: _rings,
      child: Container(
        width: _kGlowSize,
        height: _kGlowSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.kColorAccent.withValues(alpha: _kGlowAlpha),
              AppColors.kColorAccent.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockup() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RentraMark(progress: _rings),
        const SizedBox(height: AppSpacing.kSpacing20),
        AnimatedBuilder(
          animation: _wordmark,
          builder: (context, child) => Opacity(
            opacity: _wordmark.value,
            child: Transform.translate(
              offset: Offset(0, _kWordmarkRise * (1 - _wordmark.value)),
              child: child,
            ),
          ),
          child: Text(
            'Rentra',
            style: AppTextStyles.kTextHeading1.copyWith(
              color: AppColors.kColorSurface,
            ),
          ),
        ),
      ],
    );
  }
}
