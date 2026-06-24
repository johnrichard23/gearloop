import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_skeleton.dart';
import '../../domain/entities/listing_entity.dart';
import '../providers/listings_provider.dart';
import '../widgets/listing_card.dart';

/// Browse gear listings from Supabase.
class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
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

  String _selectedCategory = 'All';

  List<ListingEntity> _filterByCategory(List<ListingEntity> listings) {
    if (_selectedCategory == 'All') {
      return listings;
    }
    return listings
        .where((listing) => listing.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(listingsProvider);

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
              child: listingsAsync.when(
                loading: () => GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.kSpacing12,
                    mainAxisSpacing: AppSpacing.kSpacing12,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return const LoadingSkeleton(
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                ),
                error: (error, _) => ErrorStateWidget(
                  message: error is Failure
                      ? error.message
                      : 'Failed to load listings. Please try again.',
                  onRetry: () => ref.invalidate(listingsProvider),
                ),
                data: (allListings) {
                  final listings = _filterByCategory(allListings);
                  if (listings.isEmpty) {
                    return EmptyStateWidget(
                      title: 'No gear listed yet',
                      subtitle: _selectedCategory == 'All'
                          ? 'Be the first to post gear in your area.'
                          : 'No listings in $_selectedCategory yet.',
                      icon: Icons.camera_alt_outlined,
                      action: TextButton(
                        onPressed: () => context.push('/create-listing'),
                        child: const Text('Post your gear'),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
