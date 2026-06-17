import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

class BookingCountdownTimer extends StatefulWidget {
  const BookingCountdownTimer({required this.createdAt, super.key});

  final DateTime createdAt;

  @override
  State<BookingCountdownTimer> createState() => _BookingCountdownTimerState();
}

class _BookingCountdownTimerState extends State<BookingCountdownTimer> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _calcRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remaining = _calcRemaining();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration _calcRemaining() {
    final expiry = widget.createdAt.add(const Duration(hours: 24));
    return expiry.difference(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining <= Duration.zero) {
      return Row(
        children: [
          const Icon(
            Icons.timer_off_outlined,
            size: AppSpacing.kIconSmall,
            color: AppColors.kColorError,
          ),
          const SizedBox(width: AppSpacing.kSpacing8),
          Text(
            'Request expired',
            style: AppTextStyles.kTextBodySmall.copyWith(
              color: AppColors.kColorError,
            ),
          ),
        ],
      );
    }

    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);

    return Row(
      children: [
        const Icon(
          Icons.timer_outlined,
          size: AppSpacing.kIconSmall,
          color: AppColors.kColorWarning,
        ),
        const SizedBox(width: AppSpacing.kSpacing8),
        Text(
          '${hours}h ${minutes}m left to respond',
          style: AppTextStyles.kTextBodySmall.copyWith(
            color: AppColors.kColorWarning,
          ),
        ),
      ],
    );
  }
}

