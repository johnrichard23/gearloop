import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/cloud_bank.dart';
import '../widgets/earn_scene.dart';
import '../widgets/gear_radar_scene.dart';
import '../widgets/onboarding_copy.dart';
import '../widgets/onboarding_progress_bar.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/return_scene.dart';
import '../widgets/timer_next_button.dart';

/// First-run story: auto-advancing slides with a segmented progress bar.
///
/// The animated scene floats on the page; the text sits on a teal panel that
/// rises out of drifting clouds. Each slide runs a 0–1 timeline
/// ([_kSlideDuration]). Its scene collapses to a point at the end, the text
/// reveals anew, and the next scene grows out of the same point. The last
/// slide holds at [_kHoldPoint] and shows the exit actions. Guests can leave
/// at any time via Skip or "Start browsing".
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  static const Duration _kSlideDuration = Duration(seconds: 4);
  static const Duration _kRevealDuration = Duration(milliseconds: 900);
  static const Duration _kCloudLoop = Duration(seconds: 16);
  static const Duration _kControlsSwap = Duration(milliseconds: 300);
  static const double _kHoldPoint = 0.85;
  static const double _kStaticProgress = 0.8;
  static const double _kSwipeVelocity = 300;
  static const double _kTopBarHeight = 64;
  static const double _kCopyMinHeight = 160;
  static const double _kControlsHeight = 106;
  static const double _kLinkButtonHeight = 44;

  static const List<_Slide> _slides = [
    _Slide(
      eyebrow: '01 — NEARBY',
      lead: 'Rent what you ',
      highlight: 'need',
      body:
          'Cameras, drones, camping and audio gear from people near you, '
          'by the day.',
    ),
    _Slide(
      eyebrow: '02 — EARN',
      lead: 'Make your gear ',
      highlight: 'earn',
      body:
          'Earn from what you own. List it, set your daily rate, and '
          "you're done.",
    ),
    _Slide(
      eyebrow: '03 — EASY',
      lead: 'Rent. Use. ',
      highlight: 'Return.',
      body:
          'Book the dates, pick it up from a neighbor, and bring it back '
          'when you are done.',
    ),
  ];

  late final AnimationController _controller;
  late final AnimationController _reveal;
  late final AnimationController _ambient;
  int _index = 0;
  bool _reduceMotion = false;
  bool _started = false;

  bool get _isLast => _index == _slides.length - 1;

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
    if (status == AnimationStatus.completed && !_isLast) {
      _goTo(_index + 1);
    }
  }

  void _play() {
    if (_isLast) {
      _controller.animateTo(
        _kHoldPoint,
        duration: _kSlideDuration * _kHoldPoint,
      );
    } else {
      _controller.forward(from: 0);
    }
  }

  void _goTo(int index) {
    if (index < 0 || index >= _slides.length || !mounted) return;
    setState(() => _index = index);
    _controller.value = 0;
    if (_reduceMotion) return;
    _reveal.forward(from: 0);
    _play();
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -_kSwipeVelocity) _goTo(_index + 1);
    if (velocity > _kSwipeVelocity) _goTo(_index - 1);
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
                    padding: EdgeInsets.only(top: topInset + _kTopBarHeight),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final fill = _reduceMotion
                ? 1.0
                : _controller.value / (_isLast ? _kHoldPoint : 1);
            return OnboardingProgressBar(
              count: _slides.length,
              index: _index,
              fill: fill,
            );
          },
        ),
        SizedBox(
          height: _kTopBarHeight - AppSpacing.kSpacing16,
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedOpacity(
              duration: _kControlsSwap,
              opacity: _isLast ? 0 : 1,
              child: IgnorePointer(
                ignoring: _isLast,
                child: TextButton(
                  onPressed: _enterAsGuest,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.kTextButton.copyWith(
                      color: AppColors.kColorTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
    final slide = _slides[_index];
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
                child: OnboardingCopy(
                  eyebrow: slide.eyebrow,
                  lead: slide.lead,
                  highlight: slide.highlight,
                  body: slide.body,
                  reveal: _reveal,
                ),
              ),
              const SizedBox(height: AppSpacing.kSpacing8),
              SizedBox(
                height: _kControlsHeight,
                child: AnimatedSwitcher(
                  duration: _kControlsSwap,
                  child: _isLast ? _buildExitActions() : _buildCounterAndNext(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounterAndNext() {
    final current = (_index + 1).toString().padLeft(2, '0');
    final total = _slides.length.toString().padLeft(2, '0');
    return Row(
      key: const ValueKey<String>('counter-next'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$current / $total',
          style: AppTextStyles.kTextLabel.copyWith(
            color: AppColors.kColorTextSecondary,
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => TimerNextButton(
            fill: _reduceMotion ? 0 : _controller.value,
            onTap: () => _goTo(_index + 1),
          ),
        ),
      ],
    );
  }

  Widget _buildExitActions() {
    return Column(
      key: const ValueKey<String>('exit-actions'),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(label: 'Start browsing', onTap: _enterAsGuest),
        const SizedBox(height: AppSpacing.kSpacing8),
        TextButton(
          onPressed: _goToLogin,
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(_kLinkButtonHeight),
          ),
          child: Text(
            'Log in or sign up',
            style: AppTextStyles.kTextButton.copyWith(
              color: AppColors.kColorPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _Slide {
  const _Slide({
    required this.eyebrow,
    required this.lead,
    required this.highlight,
    required this.body,
  });

  final String eyebrow;
  final String lead;
  final String highlight;
  final String body;
}
