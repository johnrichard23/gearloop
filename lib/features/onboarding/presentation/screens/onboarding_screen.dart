import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/onboarding_slide.dart';
import '../widgets/cloud_bank.dart';
import '../widgets/earn_scene.dart';
import '../widgets/gear_radar_scene.dart';
import '../widgets/onboarding_copy.dart';
import '../widgets/onboarding_exit_actions.dart';
import '../widgets/onboarding_next_row.dart';
import '../widgets/onboarding_top_bar.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/return_scene.dart';

/// First-run story: auto-advancing slides with a segmented progress bar.
///
/// The animated scene floats on the page; the text sits on a tinted panel that
/// rises out of drifting clouds. Each slide runs a 0–1 timeline
/// ([_kSlideDuration]). Its scene collapses to a point at the end, the text
/// reveals anew, and the next scene grows out of the same point. The last
/// slide holds at [_kHoldPoint] and shows the exit actions. Slides advance on
/// their own until the user swipes or taps Next; from then on the user is in
/// control and each slide just plays to its hold point. Guests can leave at
/// any time via Skip or "Start browsing", and people who already have an
/// account can go straight to Log in.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  static const Duration _kSlideDuration = Duration(seconds: 6);
  static const Duration _kRevealDuration = Duration(milliseconds: 900);
  static const Duration _kCloudLoop = Duration(seconds: 16);
  static const Duration _kControlsSwap = Duration(milliseconds: 300);
  static const double _kHoldPoint = 0.85;
  static const double _kStaticProgress = 0.8;
  static const double _kSwipeVelocity = 300;
  static const double _kCopyMinHeight = 160;
  static const double _kControlsHeight = 106;

  late final AnimationController _controller;
  late final AnimationController _reveal;
  late final AnimationController _ambient;
  int _index = 0;
  bool _reduceMotion = false;
  bool _started = false;

  /// Set once the user swipes or taps Next: auto-advance stops for good.
  bool _manual = false;

  bool get _isLast => _index == kOnboardingSlides.length - 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _kSlideDuration)
      ..addStatusListener(_onStatus);
    _reveal = AnimationController(vsync: this, duration: _kRevealDuration);
    _ambient = AnimationController(vsync: this, duration: _kCloudLoop);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (_reduceMotion) {
      _reveal.value = 1;
    } else {
      _reveal.forward();
      _ambient.repeat();
      _play();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _reveal.dispose();
    _ambient.dispose();
    super.dispose();
  }

  void _onStatus(AnimationStatus status) {
    // An animation that only runs to the hold point also reports `completed`,
    // so slides that hold must be excluded here.
    if (status == AnimationStatus.completed && !_holds) {
      _goTo(_index + 1);
    }
  }

  /// Whether the current slide stops at [_kHoldPoint] instead of auto-advancing.
  bool get _holds => _isLast || _manual;

  void _play() {
    if (_holds) {
      _controller.animateTo(
        _kHoldPoint,
        duration: _kSlideDuration * _kHoldPoint,
      );
    } else {
      _controller.forward(from: 0);
    }
  }

  void _goTo(int index, {bool byUser = false}) {
    if (index < 0 || index >= kOnboardingSlides.length || !mounted) return;
    setState(() {
      _index = index;
      if (byUser) _manual = true;
    });
    _controller.value = 0;
    if (_reduceMotion) return;
    _reveal.forward(from: 0);
    _play();
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() <= _kSwipeVelocity) return;
    // Any qualifying swipe is manual, even one that cannot change the slide
    // (e.g. swiping back on the first slide), so auto-advance stops.
    if (!_manual) setState(() => _manual = true);
    _goTo(velocity < 0 ? _index + 1 : _index - 1, byUser: true);
  }

  void _enterAsGuest() => _finish('/home');

  void _goToLogin() => _finish('/login');

  /// Remembers that onboarding was seen, then leaves for [route].
  Future<void> _finish(String route) async {
    await ref.read(onboardingRepositoryProvider).markSeen();
    if (!mounted) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: _onDragEnd,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: topInset + OnboardingTopBar.height,
                    ),
                    child: _buildScene(),
                  ),
                ),
                _buildPanel(),
              ],
            ),
            Positioned(
              top: topInset + AppSpacing.kSpacing8,
              left: AppSpacing.kSpacing16,
              right: AppSpacing.kSpacing16,
              child: _buildTopBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return OnboardingTopBar(
      animation: _controller,
      fill: () =>
          _reduceMotion ? 1.0 : _controller.value / (_holds ? _kHoldPoint : 1),
      count: kOnboardingSlides.length,
      index: _index,
      showSkip: !_isLast,
      onSkip: _enterAsGuest,
    );
  }

  Widget _buildScene() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _reduceMotion ? _kStaticProgress : _controller.value;
        return switch (_index) {
          0 => GearRadarScene(progress: progress),
          1 => EarnScene(progress: progress),
          _ => ReturnScene(progress: progress),
        };
      },
    );
  }

  Widget _buildPanel() {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final slide = kOnboardingSlides[_index];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: -CloudBank.height,
          height: CloudBank.height,
          child: AnimatedBuilder(
            animation: _ambient,
            builder: (context, _) => CloudBank(phase: _ambient.value),
          ),
        ),
        Container(
          width: double.infinity,
          color: AppColors.kColorPrimaryFaded,
          padding: EdgeInsets.fromLTRB(
            AppSpacing.kSpacing24,
            AppSpacing.kSpacing8,
            AppSpacing.kSpacing24,
            bottomInset + AppSpacing.kSpacing16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _kCopyMinHeight),
                child: Semantics(
                  liveRegion: true,
                  child: OnboardingCopy(
                    lead: slide.lead,
                    highlight: slide.highlight,
                    body: slide.body,
                    reveal: _reveal,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.kSpacing8),
              AnimatedSize(
                duration: _kControlsSwap,
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: _kControlsHeight,
                  ),
                  child: AnimatedSwitcher(
                    duration: _kControlsSwap,
                    child: _isLast
                        ? OnboardingExitActions(
                            key: const ValueKey<String>('exit-actions'),
                            onStartBrowsing: _enterAsGuest,
                            onLogin: _goToLogin,
                          )
                        : OnboardingNextRow(
                            key: const ValueKey<String>('next-row'),
                            animation: _controller,
                            fill: () => _reduceMotion || _manual
                                ? 0
                                : _controller.value,
                            onNext: () => _goTo(_index + 1, byUser: true),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
