import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/listing_entity.dart';

/// Gear listing detail (dummy pricing until booking flow exists).
class ListingDetailScreen extends StatelessWidget {
  const ListingDetailScreen({
    required this.listing,
    super.key,
  });

  final ListingEntity listing;

  static const double _platformFeeRate = 0.12;

  String get _totalForOneDay {
    final daily = _parsePesoAmount(listing.pricePerDay);
    final total = (daily * (1 + _platformFeeRate)).round();
    return _formatPeso(total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PhotoSection(onBack: () => context.pop()),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: AppTextStyles.kTextHeading2,
                        ),
                        const SizedBox(height: AppSpacing.kSpacing8),
                        _CategoryChip(label: listing.category),
                        const SizedBox(height: AppSpacing.kSpacing16),
                        _HostInfoRow(listing: listing),
                        const Divider(color: AppColors.kColorBorder),
                        const SizedBox(height: AppSpacing.kSpacing16),
                        _PricingCard(
                          pricePerDay: listing.pricePerDay,
                          depositAmount: listing.depositAmount,
                          totalForOneDay: _totalForOneDay,
                        ),
                        const Divider(color: AppColors.kColorBorder),
                        const SizedBox(height: AppSpacing.kSpacing16),
                        Text(
                          'About this gear',
                          style: AppTextStyles.kTextHeading4,
                        ),
                        const SizedBox(height: AppSpacing.kSpacing8),
                        Text(
                          listing.description,
                          style: AppTextStyles.kTextBodyMedium.copyWith(
                            color: AppColors.kColorTextSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.kSpacing16),
                        Text(
                          'Pickup Location',
                          style: AppTextStyles.kTextHeading4,
                        ),
                        const SizedBox(height: AppSpacing.kSpacing8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.kColorAccent,
                              size: AppSpacing.kIconMedium,
                            ),
                            const SizedBox(width: AppSpacing.kSpacing8),
                            Expanded(
                              child: Text(
                                listing.location,
                                style: AppTextStyles.kTextBodyMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.kSpacing16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BottomBar(
            pricePerDay: listing.pricePerDay,
            onBookNow: () {
              context.push(
                '/booking-request',
                extra: listing,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(
            color: AppColors.kColorSurfaceVariant,
            child: Center(
              child: Icon(
                Icons.camera_alt_outlined,
                color: AppColors.kColorTextHint,
                size: AppSpacing.kIconXLarge,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + AppSpacing.kSpacing8,
            left: AppSpacing.kSpacing8,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.kColorSurface,
                foregroundColor: AppColors.kColorTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.kColorPrimaryFaded,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
      ),
      child: Text(
        label,
        style: AppTextStyles.kTextLabel.copyWith(
          color: AppColors.kColorPrimary,
        ),
      ),
    );
  }
}

class _HostInfoRow extends StatelessWidget {
  const _HostInfoRow({required this.listing});

  final ListingEntity listing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.kColorSurfaceVariant,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.kColorTextHint,
            size: AppSpacing.kIconMedium,
          ),
        ),
        const SizedBox(width: AppSpacing.kSpacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(listing.hostName, style: AppTextStyles.kTextBodyMedium),
              const SizedBox(height: AppSpacing.kSpacing4),
              Row(
                children: [
                  if (listing.isVerified) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.kSpacing8,
                        vertical: AppSpacing.kSpacing2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kColorPrimaryFaded,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.kRadiusSmall),
                      ),
                      child: Text(
                        'Verified ✓',
                        style: AppTextStyles.kTextLabel.copyWith(
                          color: AppColors.kColorPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.kSpacing8),
                  ],
                  const Icon(
                    Icons.star,
                    size: AppSpacing.kIconSmall,
                    color: AppColors.kColorWarning,
                  ),
                  const SizedBox(width: AppSpacing.kSpacing4),
                  Text(
                    '${listing.rating.toStringAsFixed(1)} (${listing.reviewCount} reviews)',
                    style: AppTextStyles.kTextBodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.pricePerDay,
    required this.depositAmount,
    required this.totalForOneDay,
  });

  final String pricePerDay;
  final String depositAmount;
  final String totalForOneDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      decoration: BoxDecoration(
        color: AppColors.kColorSurfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
      ),
      child: Column(
        children: [
          _PricingRow(
            label: 'Price per day',
            value: pricePerDay,
            valueStyle: AppTextStyles.kTextPrice,
          ),
          const SizedBox(height: AppSpacing.kSpacing8),
          _PricingRow(label: 'Deposit', value: depositAmount),
          const SizedBox(height: AppSpacing.kSpacing8),
          const _PricingRow(label: 'Platform fee', value: '12%'),
          const Divider(color: AppColors.kColorBorder),
          const SizedBox(height: AppSpacing.kSpacing8),
          _PricingRow(
            label: 'Total for 1 day',
            value: totalForOneDay,
            valueStyle: AppTextStyles.kTextHeading3.copyWith(
              color: AppColors.kColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  const _PricingRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.kTextBodyMedium),
        Text(
          value,
          style: valueStyle ?? AppTextStyles.kTextBodyMedium,
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.pricePerDay,
    required this.onBookNow,
  });

  final String pricePerDay;
  final VoidCallback onBookNow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kColorSurface,
        border: Border(top: BorderSide(color: AppColors.kColorBorder)),
      ),
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(pricePerDay, style: AppTextStyles.kTextPrice),
                Text('/day', style: AppTextStyles.kTextCaption),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 140,
              child: AppButton(
                label: 'Book Now',
                onTap: onBookNow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int _parsePesoAmount(String amount) {
  final digits = amount.replaceAll(RegExp(r'[^\d]'), '');
  return int.parse(digits);
}

String _formatPeso(int amount) {
  final buffer = StringBuffer('₱');
  final text = amount.toString();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[i]);
  }
  return buffer.toString();
}
