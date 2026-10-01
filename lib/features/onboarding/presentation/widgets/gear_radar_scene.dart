import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'scene_timing.dart';

/// Onboarding slide 1 visual: gear pins around a "You" dot, with soft radius
/// rings. [progress] is the slide's 0–1 timeline: the scene grows out of the
/// dot (0–0.18), pins drop in one by one, the nearest pin's price tag pops,
/// and from 0.85 the whole scene collapses back into the dot.
class GearRadarScene extends StatelessWidget {
  const GearRadarScene({required this.progress, super.key});

  final double progress;

  static const double _kPinSize = 56;
  static const double _kPinIconSize = 28;
  static const double _kPinDrop = 16;
  static const double _kDotSize = 18;
  static const double _kHaloSize = 40;
  static const double _kRingStroke = 1.5;
  static const double _kTagOffset = 12;

  static const List<double> _kRingFactors = [0.9, 0.61, 0.32];
  static const List<double> _kRingAlphas = [0.14, 0.22, 0.34];

  static const List<_PinSpec> _pins = [
    _PinSpec(
      icon: Icons.photo_camera,
      distance: '0.8 km',
      alignment: Alignment(-0.62, -0.62),
      start: 0.18,
      highlighted: true,
    ),
    _PinSpec(
      icon: Icons.speaker,
      distance: '1.2 km',
      alignment: Alignment(0.58, -0.42),
      start: 0.28,
    ),
    _PinSpec(
      icon: Icons.festival,
      distance: '2.4 km',
      alignment: Alignment(-0.5, 0.52),
      start: 0.38,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final t = progress;
    final sceneScale = sceneGrowth(t);
    final pulse = math.sin(2 * math.pi * t * 2);

    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(bottom: sceneCloudClearance),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final side = math.min(constraints.maxWidth, constraints.maxHeight);
            return SizedBox.expand(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: sceneScale,
                    child: SizedBox.expand(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (var i = 0; i < _kRingFactors.length; i++)
                            _buildRing(side * _kRingFactors[i], i, t),
                          for (final pin in _pins) _buildPin(pin, t),
                        ],
                      ),
                    ),
                  ),
                  _buildYou(sceneScale, pulse),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRing(double diameter, int index, double t) {
    final wobble = 1 + 0.025 * math.sin(2 * math.pi * (t * 2 - index * 0.15));
    return Transform.scale(
      scale: wobble,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.kColorPrimary.withValues(
              alpha: _kRingAlphas[index],
            ),
            width: _kRingStroke,
          ),
        ),
      ),
    );
  }

  Widget _buildPin(_PinSpec pin, double t) {
    final drop = sceneInterval(
      t,
      pin.start,
      pin.start + 0.12,
      Curves.easeOutBack,
    );
    final tagPop = pin.highlighted
        ? sceneInterval(t, 0.45, 0.57, Curves.easeOutBack)
        : 0.0;
    return Align(
      alignment: pin.alignment,
      child: Opacity(
        opacity: drop.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, -_kPinDrop * (1 - drop)),
          child: Transform.scale(
            scale: drop,
            child: _Pin(spec: pin, tagScale: tagPop),
          ),
        ),
      ),
    );
  }

  Widget _buildYou(double sceneScale, double pulse) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: 1 + 0.15 * pulse,
          child: Container(
            width: _kHaloSize,
            height: _kHaloSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.kColorPrimary.withValues(alpha: 0.2),
            ),
          ),
        ),
        Container(
          width: _kDotSize,
          height: _kDotSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kColorPrimary,
          ),
        ),
        Opacity(
          opacity: sceneScale.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: const Offset(0, _kHaloSize / 2 + AppSpacing.kSpacing12),
            child: Text(
              'You',
              style: AppTextStyles.kTextCaption.copyWith(
                color: AppColors.kColorPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PinSpec {
  const _PinSpec({
    required this.icon,
    required this.distance,
    required this.alignment,
    required this.start,
    this.highlighted = false,
  });

  final IconData icon;
  final String distance;
  final Alignment alignment;
  final double start;
  final bool highlighted;
}

class _Pin extends StatelessWidget {
  const _Pin({required this.spec, required this.tagScale});

  final _PinSpec spec;
  final double tagScale;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            _buildTile(),
            if (spec.highlighted)
              Positioned(
                top: -GearRadarScene._kTagOffset,
                left: GearRadarScene._kPinSize / 2,
                child: Transform.scale(
                  scale: tagScale,
                  alignment: Alignment.bottomLeft,
                  child: const _PriceTag(label: '₱850/day'),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.kSpacing8),
        _buildDistance(),
      ],
    );
  }

  Widget _buildTile() {
    return Container(
      width: GearRadarScene._kPinSize,
      height: GearRadarScene._kPinSize,
      decoration: BoxDecoration(
        color: AppColors.kColorSurface,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
        border: spec.highlighted
            ? Border.all(color: AppColors.kColorPrimary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.kColorTextPrimary.withValues(alpha: 0.12),
            blurRadius: AppSpacing.kSpacing12,
            offset: const Offset(0, AppSpacing.kSpacing4),
          ),
        ],
      ),
      child: Icon(
        spec.icon,
        size: GearRadarScene._kPinIconSize,
        color: AppColors.kColorPrimary,
      ),
    );
  }

  Widget _buildDistance() => _DistanceChip(label: spec.distance);
}

class _DistanceChip extends StatelessWidget {
  const _DistanceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing2,
      ),
      decoration: BoxDecoration(
        color: AppColors.kColorSurface,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
      ),
      child: Text(label, style: AppTextStyles.kTextCaption),
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.kColorPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
      ),
      child: Text(
        label,
        style: AppTextStyles.kTextLabel.copyWith(
          color: AppColors.kColorOnPrimary,
        ),
      ),
    );
  }
}
