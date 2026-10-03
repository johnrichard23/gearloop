import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../listings/presentation/providers/listings_provider.dart';
import '../widgets/home_category_row.dart';
import '../widgets/home_header.dart';
import '../widgets/home_near_you_section.dart';
import '../widgets/home_search_pill.dart';

/// Home has one job: help a renter find gear nearby. Search first, then the
/// popular categories, then a short list of nearby listings.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({required this.onBrowseTap, super.key});

  final VoidCallback onBrowseTap;

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
  }

  /// Reloads the listings. The old ones stay on screen until the new ones
  /// arrive; a failure shows in the Near you section, so it is not rethrown.
  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(listingsProvider);
    try {
      await ref.read(listingsProvider.future);
    } on Object {
      // The error state in the Near you section already tells the renter.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        color: AppColors.kColorPrimary,
        backgroundColor: AppColors.kColorSurface,
        edgeOffset: MediaQuery.paddingOf(context).top,
        onRefresh: () => _refresh(ref),
        child: SingleChildScrollView(
          // Lets a short page be pulled to refresh too.
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.kSpacing16,
                    AppSpacing.kSpacing8,
                    AppSpacing.kSpacing16,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HomeHeader(
                        onLocationTap: () => _showComingSoon(context),
                        onNotificationsTap: () =>
                            context.push('/notifications'),
                      ),
                      const SizedBox(height: AppSpacing.kSpacing12),
                      HomeSearchPill(onSearch: onBrowseTap),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.kSpacing24),
                HomeCategoryRow(onBrowseTap: onBrowseTap),
                const SizedBox(height: AppSpacing.kSpacing24),
                HomeNearYouSection(onSeeAll: onBrowseTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
