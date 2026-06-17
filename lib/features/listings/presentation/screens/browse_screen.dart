import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/listing_entity.dart';
import '../widgets/listing_card.dart';

/// Browse gear listings (dummy data until backend is wired).
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  static const List<String> _categories = [
    'All',
    'Cameras',
    'Drones',
    'Audio',
    'Lighting',
    'Camping',
    'Sports',
    'Instruments',
    'Events',
    'Tools',
  ];

  static const List<ListingEntity> _allListings = [
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
      description:
          'Sony A7III full-frame mirrorless camera body in excellent condition. Perfect for portraits, events, and video. Includes battery, charger, and body cap. Lens not included.',
      reviewCount: 24,
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
      description:
          'DJI Mini 3 Pro with RC controller. 4K video, obstacle avoidance, 34-min flight time. Includes 2 batteries and carrying case. Operator licensed.',
      reviewCount: 18,
      depositAmount: '₱8,000',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 13.1391,
      lng: 123.7438,
    ),
    ListingEntity(
      id: 'listing-3',
      hostId: 'host-3',
      title: 'Rode VideoMic Pro+',
      category: 'Audio',
      pricePerDay: '₱350',
      location: 'Naga City',
      hostName: 'Anna S.',
      rating: 4.5,
      isVerified: false,
      description:
          'Rode VideoMic Pro+ shotgun mic. Great for interviews, vlogs, and run-and-gun video. Includes deadcat windshield and cold shoe mount.',
      reviewCount: 11,
      depositAmount: '₱2,000',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 13.1391,
      lng: 123.7438,
    ),
    ListingEntity(
      id: 'listing-4',
      hostId: 'host-4',
      title: 'Godox SL-60W LED Light',
      category: 'Lighting',
      pricePerDay: '₱400',
      location: 'Legazpi, Albay',
      hostName: 'Ben T.',
      rating: 4.7,
      isVerified: true,
      description:
          'Godox SL-60W studio LED light with Bowens mount. Includes softbox diffuser and adjustable light stand. Perfect for portraits and product shoots.',
      reviewCount: 9,
      depositAmount: '₱2,500',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 13.1391,
      lng: 123.7438,
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
      description:
          'Coleman Sundome 4-person tent. Waterproof, easy setup, great for weekend camping trips. Includes rainfly, stakes, and carry bag. Used twice only.',
      reviewCount: 7,
      depositAmount: '₱1,500',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 13.1391,
      lng: 123.7438,
    ),
    ListingEntity(
      id: 'listing-6',
      hostId: 'host-6',
      title: 'Yamaha Acoustic Guitar',
      category: 'Instruments',
      pricePerDay: '₱200',
      location: 'Sorsogon City',
      hostName: 'Grace P.',
      rating: 4.9,
      isVerified: true,
      description:
          'Yamaha F310 acoustic guitar in great condition. Perfect for events, practices, and recordings. Includes soft case and extra strings.',
      reviewCount: 15,
      depositAmount: '₱1,200',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 13.1391,
      lng: 123.7438,
    ),
  ];

  String _selectedCategory = 'All';

  List<ListingEntity> get _filteredListings {
    if (_selectedCategory == 'All') {
      return _allListings;
    }
    return _allListings
        .where((listing) => listing.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final listings = _filteredListings;

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.kSpacing16,
                AppSpacing.kSpacing16,
                AppSpacing.kSpacing16,
                AppSpacing.kSpacing12,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search gear near you...',
                  hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
                    color: AppColors.kColorTextHint,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.kColorTextSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.kColorSurfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.kRadiusMedium),
                    borderSide: const BorderSide(color: AppColors.kColorBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.kRadiusMedium),
                    borderSide: const BorderSide(color: AppColors.kColorBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.kRadiusMedium),
                    borderSide:
                        const BorderSide(color: AppColors.kColorPrimary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.kSpacing12,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.kSpacing16,
                ),
                itemCount: _categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.kSpacing8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return _CategoryFilterChip(
                    label: category,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selectedCategory = category),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.kSpacing12,
                  mainAxisSpacing: AppSpacing.kSpacing12,
                  childAspectRatio: 0.58,
                ),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  final listing = listings[index];
                  return ListingCard(
                    listing: listing,
                    onTap: () => context.push(
                      '/listing/${listing.id}',
                      extra: listing,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilterChip extends StatelessWidget {
  const _CategoryFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.kColorPrimary
          : AppColors.kColorSurfaceVariant,
      borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing12,
            vertical: AppSpacing.kSpacing8,
          ),
          child: Text(
            label,
            style: AppTextStyles.kTextLabel.copyWith(
              color: isSelected
                  ? AppColors.kColorSurface
                  : AppColors.kColorTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
