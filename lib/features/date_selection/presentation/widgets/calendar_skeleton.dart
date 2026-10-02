import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/loading_skeleton.dart';
import 'calendar_metrics.dart';

/// Placeholder for the day grid while a month's availability loads.
class CalendarSkeleton extends StatelessWidget {
  const CalendarSkeleton({super.key});

  static const int _kCells = 35;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: GridView.count(
        crossAxisCount: CalendarMetrics.columns,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: CalendarMetrics.cellGap,
        crossAxisSpacing: CalendarMetrics.cellGap,
        children: List.generate(
          _kCells,
          (_) => const LoadingSkeleton(
            width: double.infinity,
            height: double.infinity,
            radius: AppSpacing.kRadiusMedium,
          ),
        ),
      ),
    );
  }
}
