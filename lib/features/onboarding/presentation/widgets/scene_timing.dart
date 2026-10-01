import 'package:flutter/animation.dart';

/// Space every onboarding scene keeps free at the bottom of its area, because
/// the clouds overlap that part of the screen. Scenes lay out (and grow from)
/// the centre of the remaining space.
const double sceneCloudClearance = 66;

/// Maps [t] to 0–1 across `[begin, end]`, then applies [curve].
double sceneInterval(
  double t,
  double begin,
  double end, [
  Curve curve = Curves.linear,
]) {
  final x = ((t - begin) / (end - begin)).clamp(0.0, 1.0);
  return curve.transform(x);
}

/// Scale shared by every onboarding scene: it grows out of the centre point
/// over the first 18% of the slide and collapses back into it from 85%.
double sceneGrowth(double t) {
  final enter = sceneInterval(t, 0, 0.18, Curves.easeOutCubic);
  final exit = sceneInterval(t, 0.85, 1, Curves.easeInCubic);
  return enter * (1 - exit);
}
