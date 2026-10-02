import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../listings/presentation/providers/browse_providers.dart';
import '../../../listings/presentation/providers/listings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({required this.onBrowseTap, super.key});

  final VoidCallback onBrowseTap;

  static const List<_CategoryItem> _categories = [
    _CategoryItem('Cameras', Icons.camera_alt_outlined),
    _CategoryItem('Drones', Icons.flight_outlined),
    _CategoryItem('Audio', Icons.mic_outlined),
    _CategoryItem('Lighting', Icons.lightbulb_outline),
    _CategoryItem('Camping', Icons.cabin_outlined),
  ];

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(listingsProvider);
    final topHostsAsync = ref.watch(topRatedHostsProvider);

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SingleChildScrollView(
        // The floating tab bar overlays the bottom of the screen.
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.kSpacing20,
                  AppSpacing.kSpacing8,
                  AppSpacing.kSpacing20,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _LocationPicker(
                            onTap: () => _showComingSoon(context),
                          ),
                        ),
                        _NotificationsButton(
                          onTap: () => context.push('/notifications'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.kSpacing16),
                    _SearchPill(onTap: onBrowseTap),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.kSpacing16,
                AppSpacing.kSpacing24,
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
                          child: GestureDetector(
                            onTap: () {
                              ref.read(browseCategoryProvider.notifier).state =
                                  item.label;
                              onBrowseTap();
                            },
                            behavior: HitTestBehavior.opaque,
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
                    child: listingsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => Center(
                        child: TextButton(
                          onPressed: () => ref.invalidate(listingsProvider),
                          child: const Text(
                            'Could not load listings. Tap to retry.',
                          ),
                        ),
                      ),
                      data: (nearbyListings) {
                        if (nearbyListings.isEmpty) {
                          return Center(
                            child: Text(
                              'No gear listed nearby yet.',
                              style: AppTextStyles.kTextBodySmall.copyWith(
                                color: AppColors.kColorTextSecondary,
                              ),
                            ),
                          );
                        }
                        final previewListings = nearbyListings.take(5).toList();
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: previewListings.length,
                          itemBuilder: (context, index) {
                            final listing = previewListings[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index == previewListings.length - 1
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
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.kRadiusLarge,
                                    ),
                                    border: Border.all(
                                      color: AppColors.kColorBorder,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(
                                                    AppSpacing.kRadiusLarge,
                                                  ),
                                                ),
                                            child: SizedBox(
                                              height: 90,
                                              width: double.infinity,
                                              child:
                                                  listing.photoUrls.isNotEmpty
                                                  ? Image.network(
                                                      listing.photoUrls.first,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: 90,
                                                      loadingBuilder:
                                                          (
                                                            context,
                                                            child,
                                                            progress,
                                                          ) => progress == null
                                                          ? child
                                                          : Container(
                                                              color: AppColors
                                                                  .kColorSurfaceVariant,
                                                              child: const Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2,
                                                                    ),
                                                              ),
                                                            ),
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => Container(
                                                            color: AppColors
                                                                .kColorSurfaceVariant,
                                                            child: const Icon(
                                                              Icons
                                                                  .broken_image_outlined,
                                                              color: AppColors
                                                                  .kColorTextHint,
                                                            ),
                                                          ),
                                                    )
                                                  : Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: AppColors
                                                                .kColorPrimaryFaded,
                                                          ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          color: AppColors
                                                              .kColorPrimary,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          if (listing.isVerified)
                                            Positioned(
                                              top: AppSpacing.kSpacing8,
                                              left: AppSpacing.kSpacing8,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppColors.kColorSurface,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.verified,
                                                      color: AppColors
                                                          .kColorSuccess,
                                                      size: 10,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      'Verified',
                                                      style: AppTextStyles
                                                          .kTextCaption
                                                          .copyWith(
                                                            color: AppColors
                                                                .kColorSuccess,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              listing.title,
                                              style: AppTextStyles.kTextLabel,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.kSpacing4,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  listing.pricePerDay,
                                                  style: AppTextStyles
                                                      .kTextPriceSmall,
                                                ),
                                                const Spacer(),
                                                const Icon(
                                                  Icons.star,
                                                  color:
                                                      AppColors.kColorWarning,
                                                  size: 10,
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  listing.rating
                                                      .toStringAsFixed(1),
                                                  style: AppTextStyles
                                                      .kTextCaption
                                                      .copyWith(
                                                        color: AppColors
                                                            .kColorTextSecondary,
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
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.kSpacing24),
                  topHostsAsync.when(
                    loading: () => const SizedBox(
                      height: 90,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (topHosts) {
                      if (topHosts.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                              itemCount: topHosts.length,
                              itemBuilder: (context, index) {
                                final host = topHosts[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: index == topHosts.length - 1
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
                                            style: AppTextStyles.kTextHeading4
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: AppSpacing.kSpacing4,
                                        ),
                                        Text(
                                          host.name,
                                          style: AppTextStyles.kTextCaption
                                              .copyWith(
                                                color:
                                                    AppColors.kColorTextPrimary,
                                                fontSize: 10.5,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: AppColors.kColorWarning,
                                              size: 9,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              host.rating.toStringAsFixed(1),
                                              style: AppTextStyles.kTextCaption
                                                  .copyWith(
                                                    color: AppColors
                                                        .kColorTextSecondary,
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
                        ],
                      );
                    },
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

/// "Location" label over the current city, with a chevron for a future picker.
class _LocationPicker extends StatelessWidget {
  const _LocationPicker({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Change location, Sorsogon City',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Location',
              style: AppTextStyles.kTextCaption.copyWith(
                color: AppColors.kColorTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.kSpacing2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: AppSpacing.kIconMedium,
                  color: AppColors.kColorPrimary,
                ),
                const SizedBox(width: AppSpacing.kSpacing4),
                // TODO: Replace with real device location or user-set preference in a future iteration
                Text('Sorsogon City', style: AppTextStyles.kTextHeading4),
                const SizedBox(width: AppSpacing.kSpacing4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: AppSpacing.kIconMedium,
                  color: AppColors.kColorTextSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Round bell button with an unread dot.
class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton({required this.onTap});

  final VoidCallback onTap;

  static const double _kSize = 48;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Notifications',
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: _kSize,
              height: _kSize,
              decoration: BoxDecoration(
                color: AppColors.kColorSurface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.kColorBorder),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.kColorTextPrimary,
              ),
            ),
            // TODO: Wire to real unread notification count once notification system is built
            Positioned(
              right: 12,
              top: 12,
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
    );
  }
}

/// Tappable search field that opens Browse.
class _SearchPill extends StatelessWidget {
  const _SearchPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search cameras, drones, gear',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing16,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: AppColors.kColorSurface,
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
            border: Border.all(color: AppColors.kColorBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.kColorTextSecondary),
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

final homeUserGreetingProvider = FutureProvider<String?>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) {
    return null;
  }
  try {
    final data = await Supabase.instance.client
        .from('users')
        .select('full_name')
        .eq('id', userId)
        .single();
    return data['full_name'] as String?;
  } on Exception {
    return null;
  }
});

final topRatedHostsProvider = FutureProvider<List<_HostItem>>((ref) async {
  try {
    final data = await Supabase.instance.client
        .from('users')
        .select('id, full_name, rating_avg')
        .eq('is_host', true)
        .gt('rating_count', 0)
        .order('rating_avg', ascending: false)
        .limit(4);

    const avatarColors = [
      AppColors.kColorPrimaryFaded,
      AppColors.kColorAccentLight,
      AppColors.kColorSuccessLight,
      AppColors.kColorPrimaryFaded,
    ];

    final hosts = <_HostItem>[];
    for (final row in data as List) {
      final map = row as Map<String, dynamic>;
      final name = map['full_name'] as String?;
      if (name == null || name.trim().isEmpty) {
        continue;
      }
      final rating = (map['rating_avg'] as num?)?.toDouble() ?? 0;
      hosts.add(
        _HostItem(
          name: name.trim(),
          rating: rating,
          color: avatarColors[hosts.length % avatarColors.length],
        ),
      );
    }
    return hosts;
  } on Exception {
    return [];
  }
});
