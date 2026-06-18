import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../listings/domain/entities/listing_entity.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.onBrowseTap,
    super.key,
  });

  final VoidCallback onBrowseTap;

  static const List<_CategoryItem> _categories = [
    _CategoryItem('Cameras', Icons.camera_alt_outlined),
    _CategoryItem('Drones', Icons.flight_outlined),
    _CategoryItem('Audio', Icons.mic_outlined),
    _CategoryItem('Lighting', Icons.lightbulb_outline),
    _CategoryItem('Camping', Icons.cabin_outlined),
  ];

  static const List<ListingEntity> _nearbyListings = [
    ListingEntity(
      id: 'listing-1',
      hostId: 'host-1',
      title: 'Sony A7III Camera Body',
      category: 'Cameras',
      pricePerDay: '₱800',
      location: 'Legazpi, Albay',
      hostName: 'Marco R.',
      rating: 4.8,
      isVerified: true,
      description: 'Sony A7III full-frame body in excellent condition.',
      reviewCount: 12,
      depositAmount: '₱5,000',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 13.1391,
      lng: 123.7438,
    ),
    ListingEntity(
      id: 'listing-2',
      hostId: 'host-2',
      title: 'DJI Mini 3 Pro Drone',
      category: 'Drones',
      pricePerDay: '₱1,200',
      location: 'Sorsogon City',
      hostName: 'Chard D.',
      rating: 5.0,
      isVerified: true,
      description: 'DJI Mini 3 Pro with RC controller.',
      reviewCount: 18,
      depositAmount: '₱8,000',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 12.9734,
      lng: 124.0067,
    ),
    ListingEntity(
      id: 'listing-5',
      hostId: 'host-5',
      title: 'Coleman 4-Person Tent',
      category: 'Camping',
      pricePerDay: '₱250',
      location: 'Bulan, Sorsogon',
      hostName: 'Leo M.',
      rating: 4.3,
      isVerified: false,
      description: 'Waterproof family tent with easy setup.',
      reviewCount: 7,
      depositAmount: '₱1,500',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 13.1391,
      lng: 123.7438,
    ),
  ];

  static const List<_HostItem> _topHosts = [
    _HostItem(
      name: 'Chard D.',
      rating: 5.0,
      color: AppColors.kColorPrimaryFaded,
    ),
    _HostItem(
      name: 'Marco R.',
      rating: 4.8,
      color: AppColors.kColorAccentLight,
    ),
    _HostItem(
      name: 'Grace P.',
      rating: 4.9,
      color: AppColors.kColorSuccessLight,
    ),
    _HostItem(
      name: 'Ben T.',
      rating: 4.7,
      color: AppColors.kColorPrimaryFaded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  color: AppColors.kColorPrimary,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.kSpacing20,
                    AppSpacing.kSpacing20,
                    AppSpacing.kSpacing20,
                    56,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Magandang umaga',
                                style: AppTextStyles.kTextBodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.65),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.kSpacing4),
                              Text(
                                'Hi, Chard 👋',
                                style: AppTextStyles.kTextHeading3.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.kSpacing8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.kRadiusCircular,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    const SizedBox(width: AppSpacing.kSpacing4),
                                    Text(
                                      'Sorsogon City',
                                      style: AppTextStyles.kTextCaption.copyWith(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/notifications'),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.kColorAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.kSpacing16,
                  right: AppSpacing.kSpacing16,
                  bottom: -38,
                  child: GestureDetector(
                    onTap: onBrowseTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.kSpacing16,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.kColorSurface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.kRadiusLarge),
                        border: Border.all(
                          color: AppColors.kColorBorder,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppColors.kColorTextSecondary,
                          ),
                          const SizedBox(width: AppSpacing.kSpacing12),
                          Text(
                            'Search cameras, drones, gear...',
                            style: AppTextStyles.kTextBodyMedium.copyWith(
                              color: AppColors.kColorTextHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.kSpacing16,
                54,
                AppSpacing.kSpacing16,
                AppSpacing.kSpacing16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Browse by category',
                    style: AppTextStyles.kTextHeading4,
                  ),
                  const SizedBox(height: AppSpacing.kSpacing12),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final item = _categories[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == _categories.length - 1
                                ? 0
                                : AppSpacing.kSpacing16,
                          ),
                          child: SizedBox(
                            width: 68,
                            child: Column(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: AppColors.kColorPrimaryFaded,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    color: AppColors.kColorPrimary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.kSpacing8),
                                Text(
                                  item.label,
                                  style: AppTextStyles.kTextCaption.copyWith(
                                    color: AppColors.kColorTextSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.kSpacing24),
                  GestureDetector(
                    onTap: () => context.push('/create-listing'),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.kSpacing20),
                      decoration: BoxDecoration(
                        color: AppColors.kColorPrimary,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.kRadiusLarge),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.camera_alt,
                              size: 80,
                              color: Colors.white.withValues(alpha: 0.10),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FOR GEAR OWNERS',
                                style: AppTextStyles.kTextCaption.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.kSpacing8),
                              Text(
                                'Your idle gear could earn\n₱500+ this week',
                                style: AppTextStyles.kTextHeading4.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.kSpacing8),
                              Text(
                                'Join hosts already earning\nin Bicol',
                                style: AppTextStyles.kTextBodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.kSpacing16,
                                  vertical: AppSpacing.kSpacing8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kColorAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'List your gear',
                                  style: AppTextStyles.kTextButton.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.kSpacing24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Near you in Sorsogon',
                        style: AppTextStyles.kTextHeading4,
                      ),
                      TextButton(
                        onPressed: onBrowseTap,
                        child: Text(
                          'See all',
                          style: AppTextStyles.kTextBodyMedium.copyWith(
                            color: AppColors.kColorPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _nearbyListings.length,
                      itemBuilder: (context, index) {
                        final listing = _nearbyListings[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == _nearbyListings.length - 1
                                ? 0
                                : AppSpacing.kSpacing12,
                          ),
                          child: GestureDetector(
                            onTap: () => context.push(
                              '/listing/${listing.id}',
                              extra: listing,
                            ),
                            child: Container(
                              width: 140,
                              decoration: BoxDecoration(
                                color: AppColors.kColorSurface,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.kRadiusLarge),
                                border: Border.all(
                                  color: AppColors.kColorBorder,
                                  width: 0.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 90,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: AppColors.kColorPrimaryFaded,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(
                                              AppSpacing.kRadiusLarge,
                                            ),
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            color: AppColors.kColorPrimary,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      if (listing.isVerified)
                                        Positioned(
                                          top: AppSpacing.kSpacing8,
                                          left: AppSpacing.kSpacing8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.kColorSurface,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.verified,
                                                  color: AppColors.kColorSuccess,
                                                  size: 10,
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  'Verified',
                                                  style:
                                                      AppTextStyles.kTextCaption
                                                          .copyWith(
                                                    color: AppColors.kColorSuccess,
                                                    fontSize: 8.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      9,
                                      8,
                                      11,
                                      8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listing.title,
                                          style: AppTextStyles.kTextLabel,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: AppSpacing.kSpacing4),
                                        Row(
                                          children: [
                                            Text(
                                              listing.pricePerDay,
                                              style: AppTextStyles.kTextPriceSmall,
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              Icons.star,
                                              color: AppColors.kColorWarning,
                                              size: 10,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              listing.rating.toStringAsFixed(1),
                                              style: AppTextStyles.kTextCaption
                                                  .copyWith(
                                                color: AppColors.kColorTextSecondary,
                                                fontSize: 10.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.kSpacing24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Top rated hosts',
                        style: AppTextStyles.kTextHeading4,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See all',
                          style: AppTextStyles.kTextBodyMedium.copyWith(
                            color: AppColors.kColorPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _topHosts.length,
                      itemBuilder: (context, index) {
                        final host = _topHosts[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == _topHosts.length - 1
                                ? 0
                                : AppSpacing.kSpacing16,
                          ),
                          child: SizedBox(
                            width: 68,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: host.color,
                                  child: Text(
                                    host.initials,
                                    style: AppTextStyles.kTextHeading4.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.kSpacing4),
                                Text(
                                  host.name,
                                  style: AppTextStyles.kTextCaption.copyWith(
                                    color: AppColors.kColorTextPrimary,
                                    fontSize: 10.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: AppColors.kColorWarning,
                                      size: 9,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      host.rating.toStringAsFixed(1),
                                      style: AppTextStyles.kTextCaption.copyWith(
                                        color: AppColors.kColorTextSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.kSpacing24),
                  GestureDetector(
                    onTap: () => context.push('/create-listing'),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                      decoration: BoxDecoration(
                        color: AppColors.kColorAccentLight,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.kRadiusLarge),
                        border: Border.all(
                          color: AppColors.kColorAccent.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.kColorAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.kSpacing12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Got gear sitting idle?',
                                style: AppTextStyles.kTextLabel.copyWith(
                                  color: AppColors.kColorTextPrimary,
                                ),
                              ),
                              Text(
                                'List it in under 5 minutes',
                                style: AppTextStyles.kTextCaption.copyWith(
                                  color: AppColors.kColorTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.kSpacing16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem {
  const _CategoryItem(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _HostItem {
  const _HostItem({
    required this.name,
    required this.rating,
    required this.color,
  });

  final String name;
  final double rating;
  final Color color;

  String get initials {
    if (name.isEmpty) return '?';
    return name[0].toUpperCase();
  }
}

