import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Rentra logo mark: two interlocking rings, one for the lender and one for
/// the borrower.
///
/// [progress] drives the entrance: 0 = rings apart and transparent,
/// 1 = rings interlocked.
class RentraMark extends StatelessWidget {
  const RentraMark({super.key, required this.progress});

  final Animation<double> progress;

  static const double _kRingSize = 96;
  static const double _kRingStroke = 6;
  static const double _kRingOverlap = 44;
  static const double _kEntranceTravel = 48;

  static const double _kMarkWidth = _kRingSize * 2 - _kRingOverlap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kMarkWidth,
      height: _kRingSize,
      child: AnimatedBuilder(
        animation: progress,
        builder: (context, _) {
          final t = progress.value;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                child: _Ring(
                  color: AppColors.kColorSurface,
                  opacity: t,
                  dx: -_kEntranceTravel * (1 - t),
                ),
              ),
              Positioned(
                left: _kRingSize - _kRingOverlap,
                child: _Ring(
                  color: AppColors.kColorPrimaryFaded,
                  opacity: t,
                  dx: _kEntranceTravel * (1 - t),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.color, required this.opacity, required this.dx});

  final Color color;
  final double opacity;
  final double dx;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: Container(
          width: RentraMark._kRingSize,
          height: RentraMark._kRingSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: RentraMark._kRingStroke),
          ),
        ),
      ),
    );
  }
}
