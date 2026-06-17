import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Tappable 1–5 star rating control.
class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({
    required this.initialRating,
    required this.onRatingChanged,
    this.size = 36,
    super.key,
  });

  final int initialRating;
  final ValueChanged<int> onRatingChanged;
  final double size;

  @override
  State<StarRatingWidget> createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  void didUpdateWidget(covariant StarRatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _rating = widget.initialRating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isFilled = starValue <= _rating;
        return GestureDetector(
          onTap: () {
            setState(() => _rating = starValue);
            widget.onRatingChanged(starValue);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size * 0.08),
            child: Icon(
              isFilled ? Icons.star : Icons.star_outline,
              size: widget.size,
              color: isFilled
                  ? AppColors.kColorWarning
                  : AppColors.kColorTextHint,
            ),
          ),
        );
      }),
    );
  }
}
