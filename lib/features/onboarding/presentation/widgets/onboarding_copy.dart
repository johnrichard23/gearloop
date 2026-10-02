import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/accent_headline.dart';

/// Text block of an onboarding slide: a headline with one highlighted word and
/// a supporting line. [reveal] (0–1) staggers them in.
class OnboardingCopy extends StatelessWidget {
  const OnboardingCopy({
    required this.lead,
    required this.highlight,
    required this.body,
    required this.reveal,
    super.key,
  });

  final String lead;
  final String highlight;
  final String body;
  final Animation<double> reveal;

  static const double _kRise = 14;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: reveal,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _staged(0, 0.6, _buildHeadline()),
            const SizedBox(height: AppSpacing.kSpacing12),
            _staged(0.25, 1, _buildBody()),
          ],
        );
      },
    );
  }

  Widget _staged(double begin, double end, Widget child) {
    final t = Interval(
      begin,
      end,
      curve: Curves.easeOutCubic,
    ).transform(reveal.value);
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, _kRise * (1 - t)),
        child: child,
      ),
    );
  }

  Widget _buildHeadline() {
    final swoosh = Interval(
      0.6,
      1,
      curve: Curves.easeInOut,
    ).transform(reveal.value);
    return AccentHeadline(lead: lead, highlight: highlight, swoosh: swoosh);
  }

  Widget _buildBody() {
    return Text(body, style: AppTextStyles.kTextBodyLarge);
  }
}
