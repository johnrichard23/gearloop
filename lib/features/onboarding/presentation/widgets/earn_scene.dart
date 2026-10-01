import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'scene_parts.dart';
import 'scene_timing.dart';

/// Onboarding slide 2 visual: a gear listing goes live, bookings pop up around
/// it and fly into an earnings counter. [progress] is the slide's 0–1
/// timeline: the listing card drops in (0.18), its availability toggle flips
/// on (0.32), three booking chips pop and fly into the counter (0.34–0.78),
/// and from 0.85 the whole scene collapses into the centre point.
class EarnScene extends StatelessWidget {
  const EarnScene({required this.progress, super.key});

  final double progress;

  static const double _kCardWidth = 236;
  static const double _kTileSize = 48;
  static const double _kToggleWidth = 44;
  static const double _kToggleHeight = 26;
  static const double _kKnobSize = 20;
  static const int _kRatePerDay = 850;
  static const double _kChipPop = 0.06;
  static const double _kChipHold = 0.06;
  static const double _kChipFlight = 0.12;

  /// Layout box the scene is designed in; it scales down to fit shorter screens.
  static const double _kDesignWidth = 360;
  static const double _kDesignHeight = 330;

  static const Alignment _cardAlignment = Alignment.topCenter;
  static const Alignment _pillAlignment = Alignment(0, 0.9);

  static const List<_Booking> _bookings = [
    _Booking(day: 'Fri', from: Alignment(-0.72, 0.11), start: 0.34),
    _Booking(day: 'Sat', from: Alignment(0.72, 0.2), start: 0.44),
    _Booking(day: 'Sun', from: Alignment(-0.45, 0.02), start: 0.54),
  ];

  @override
  Widget build(BuildContext context) {
    final t = progress;
    final growth = sceneGrowth(t);
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(bottom: sceneCloudClearance),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SceneOriginDot(growth: growth),
            Transform.scale(
              scale: growth,
              child: FittedBox(
                child: SizedBox(
                  width: _kDesignWidth,
                  height: _kDesignHeight,
                  child: Stack(
                    children: [
                      _buildCard(t),
                      _buildPill(t),
                      for (final booking in _bookings) _buildChip(booking, t),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(double t) {
    final drop = sceneInterval(t, 0.18, 0.3, Curves.easeOutBack);
    final on = sceneInterval(t, 0.32, 0.38, Curves.easeInOut);
    return Align(
      alignment: _cardAlignment,
      child: Opacity(
        opacity: drop.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, -16 * (1 - drop)),
          child: Transform.scale(
            scale: 0.9 + 0.1 * drop,
            child: _ListingCard(available: on),
          ),
        ),
      ),
    );
  }

  Widget _buildPill(double t) {
    final rise = sceneInterval(t, 0.36, 0.46, Curves.easeOutBack);
    var earned = 0.0;
    var bump = 0.0;
    for (final booking in _bookings) {
      final flight = _flight(booking, t);
      earned += _kRatePerDay * flight;
      bump += math.sin(math.pi * ((flight - 0.8) / 0.2).clamp(0.0, 1.0));
    }
    return Align(
      alignment: _pillAlignment,
      child: Opacity(
        opacity: rise.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - rise)),
          child: Transform.scale(
            scale: rise * (1 + 0.06 * bump.clamp(0.0, 1.0)),
            child: _EarningsPill(amount: earned.round()),
          ),
        ),
      ),
    );
  }

  /// 0 until the chip starts flying, 1 once it has landed in the counter.
  double _flight(_Booking booking, double t) {
    final begin = booking.start + _kChipPop + _kChipHold;
    return sceneInterval(t, begin, begin + _kChipFlight, Curves.easeInCubic);
  }

  Widget _buildChip(_Booking booking, double t) {
    final pop = sceneInterval(
      t,
      booking.start,
      booking.start + _kChipPop,
      Curves.easeOutBack,
    );
    final flight = _flight(booking, t);
    if (flight >= 1) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.lerp(booking.from, _pillAlignment, flight)!,
      child: Opacity(
        opacity: (pop * (1 - flight * 0.6)).clamp(0.0, 1.0),
        child: Transform.scale(
          scale: pop * (1 - 0.5 * flight),
          child: _BookingChip(day: booking.day),
        ),
      ),
    );
  }
}

class _Booking {
  const _Booking({required this.day, required this.from, required this.start});

  final String day;
  final Alignment from;
  final double start;
}

class _ListingCard extends StatelessWidget {
  const _ListingCard({required this.available});

  /// 0 = toggle off, 1 = toggle on.
  final double available;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: EarnScene._kCardWidth,
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      decoration: sceneCardDecoration(AppSpacing.kRadiusLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: EarnScene._kTileSize,
                height: EarnScene._kTileSize,
                decoration: BoxDecoration(
                  color: AppColors.kColorPrimaryFaded,
                  borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: AppColors.kColorPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.kSpacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Canon EOS R6',
                      style: AppTextStyles.kTextHeading4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '₱${EarnScene._kRatePerDay} / day',
                      style: AppTextStyles.kTextBodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.kSpacing12),
          const Divider(height: 1, color: AppColors.kColorBorder),
          const SizedBox(height: AppSpacing.kSpacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                available > 0.5 ? 'Available' : 'Paused',
                style: AppTextStyles.kTextLabel.copyWith(
                  color: AppColors.kColorTextPrimary,
                ),
              ),
              _Toggle(value: available),
            ],
          ),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: EarnScene._kToggleWidth,
      height: EarnScene._kToggleHeight,
      padding: const EdgeInsets.all(AppSpacing.kSpacing2 + 1),
      decoration: BoxDecoration(
        color: Color.lerp(
          AppColors.kColorBorderDark,
          AppColors.kColorPrimary,
          value,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
      ),
      child: Align(
        alignment: Alignment(-1 + 2 * value, 0),
        child: Container(
          width: EarnScene._kKnobSize,
          height: EarnScene._kKnobSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kColorSurface,
          ),
        ),
      ),
    );
  }
}

class _BookingChip extends StatelessWidget {
  const _BookingChip({required this.day});

  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing12,
        vertical: AppSpacing.kSpacing8,
      ),
      decoration: sceneCardDecoration(AppSpacing.kRadiusCircular),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: AppSpacing.kIconSmall,
            color: AppColors.kColorSuccess,
          ),
          const SizedBox(width: AppSpacing.kSpacing4),
          Text(
            '$day · ₱${EarnScene._kRatePerDay}',
            style: AppTextStyles.kTextLabel.copyWith(
              color: AppColors.kColorTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningsPill extends StatelessWidget {
  const _EarningsPill({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing24,
        vertical: AppSpacing.kSpacing12,
      ),
      decoration: BoxDecoration(
        color: AppColors.kColorPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusXLarge),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You earned',
            style: AppTextStyles.kTextCaption.copyWith(
              color: AppColors.kColorOnPrimary.withValues(alpha: 0.8),
            ),
          ),
          Text(
            '₱${NumberFormat('#,##0').format(amount)}',
            style: AppTextStyles.kTextHeading2.copyWith(
              color: AppColors.kColorOnPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
