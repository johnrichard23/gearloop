import 'package:flutter/material.dart';

import 'timer_next_button.dart';

/// The Next button on slides before the last, right-aligned in the thumb zone.
class OnboardingNextRow extends StatelessWidget {
  const OnboardingNextRow({
    required this.animation,
    required this.fill,
    required this.onNext,
    super.key,
  });

  /// Rebuilds the button's ring as this animation ticks.
  final Listenable animation;

  /// Current fill (0–1) of the ring.
  final double Function() fill;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) => TimerNextButton(fill: fill(), onTap: onNext),
      ),
    );
  }
}
