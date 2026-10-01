import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Which provider a [SocialSignInButton] stands for.
enum SocialProvider { apple, google, facebook }

/// Square outlined button with a provider logo, for "or continue with" rows.
class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    required this.provider,
    required this.onTap,
    super.key,
  });

  final SocialProvider provider;
  final VoidCallback onTap;

  static const double _kSize = 56;
  static const double _kGlyphSize = 24;

  String get _label => switch (provider) {
    SocialProvider.apple => 'Continue with Apple',
    SocialProvider.google => 'Continue with Google',
    SocialProvider.facebook => 'Continue with Facebook',
  };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: _label,
      child: Material(
        color: AppColors.kColorSurface.withValues(alpha: 0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
          side: const BorderSide(color: AppColors.kColorBorderDark),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
          ),
          onTap: onTap,
          child: SizedBox(
            width: _kSize,
            height: _kSize,
            child: Center(child: _glyph()),
          ),
        ),
      ),
    );
  }

  Widget _glyph() {
    return switch (provider) {
      SocialProvider.apple => const Icon(
        Icons.apple,
        size: _kGlyphSize + 4,
        color: AppColors.kColorTextPrimary,
      ),
      SocialProvider.google => const SizedBox(
        width: _kGlyphSize,
        height: _kGlyphSize,
        child: CustomPaint(painter: _GoogleGlyphPainter()),
      ),
      SocialProvider.facebook => const _FacebookGlyph(size: _kGlyphSize),
    };
  }
}

/// Approximation of the Google "G" in its four brand colours. Swap for the
/// official asset when it is added to the project.
class _GoogleGlyphPainter extends CustomPainter {
  const _GoogleGlyphPainter();

  static const Color _blue = Color(0xFF4285F4);
  static const Color _green = Color(0xFF34A853);
  static const Color _yellow = Color(0xFFFBBC05);
  static const Color _red = Color(0xFFEA4335);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.22;
    final radius = (size.width - stroke) / 2;
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);
    double rad(double degrees) => degrees * math.pi / 180;

    void arc(Color color, double start, double sweep) {
      canvas.drawArc(
        rect,
        rad(start),
        rad(sweep),
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );
    }

    arc(_red, 200, 115);
    arc(_yellow, 135, 65);
    arc(_green, 45, 90);
    arc(_blue, 0, 45);
    canvas.drawRect(
      Rect.fromLTRB(
        center.dx,
        center.dy - stroke / 2,
        center.dx + radius + stroke / 2,
        center.dy + stroke / 2,
      ),
      Paint()..color = _blue,
    );
  }

  @override
  bool shouldRepaint(_GoogleGlyphPainter old) => false;
}

/// Approximation of the Facebook logo: a blue disc with a white "f". Swap for
/// the official asset when it is added to the project.
class _FacebookGlyph extends StatelessWidget {
  const _FacebookGlyph({required this.size});

  final double size;

  static const Color _blue = Color(0xFF1877F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: _blue),
      child: Text(
        'f',
        style: TextStyle(
          color: AppColors.kColorOnPrimary,
          fontSize: size * 0.95,
          fontWeight: FontWeight.w700,
          height: 0.95,
        ),
      ),
    );
  }
}
