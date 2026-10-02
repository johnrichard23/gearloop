import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
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

  static String _filipinoGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Magandang umaga';
    }
    if (hour < 18) {
      return 'Magandang hapon';
    }
    return 'Magandang gabi';
  }

  static String _greetingLine(String? fullName) {
    final trimmed = fullName?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return 'Hi there 👋';
    }
    return 'Hi, $trimmed 👋';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listingsAsync = ref.watch(listingsProvider);
    final greetingAsync = ref.watch(homeUserGreetingProvider);
    final topHostsAsync = ref.watch(topRatedHostsProvider);

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SingleChildScrollView(
        // The floating tab bar overlays the bottom of the screen.
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
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
                                _filipinoGreeting(),
                                style: AppTextStyles.kTextBodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.65),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.kSpacing4),
                              greetingAsync.when(
                                loading: () => Text(
                                  'Hi there 👋',
                                  style: AppTextStyles.kTextHeading3.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                error: (_, __) => Text(
                                  'Hi there 👋',
                                  style: AppTextStyles.kTextHeading3.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                data: (fullName) => Text(
                                  _greetingLine(fullName),
                                  style: AppTextStyles.kTextHeading3.copyWith(
                                    color: Colors.white,
                                  ),
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
                                    // TODO: Replace with real device location or user-set preference in a future iteration
                                    Text(
                                      'Sorsogon City',
                                      style: AppTextStyles.kTextCaption
                                          .copyWith(
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
                              // TODO: Wire to real unread notification count once notification system is built
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
                        borderRadius: BorderRadius.circular(
                          AppSpacing.kRadiusLarge,
                        ),
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
                        borderRadius: BorderRadius.circular(
                          AppSpacing.kRadiusLarge,
                        ),
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
                                    color: AppColors.kColorOnAccent,
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
                  const SizedBox(height: AppSpacing.kSpacing24),
                  GestureDetector(
                    onTap: () => context.push('/create-listing'),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                      decoration: BoxDecoration(
                        color: AppColors.kColorAccentLight,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.kRadiusLarge,
                        ),
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
                              color: AppColors.kColorOnAccent,
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
