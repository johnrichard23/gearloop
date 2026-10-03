import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/failures.dart';
import '../../../date_selection/domain/entities/date_range_selection.dart';
import '../../../date_selection/presentation/date_range_label.dart';
import '../../domain/entities/listing_filter.dart';
import '../../domain/entities/search_selection.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../providers/browse_providers.dart';
import '../providers/listings_provider.dart';
import '../widgets/active_filter_chip.dart';
import '../widgets/browse_filter_button.dart';
import '../widgets/browse_filters_sheet.dart';
import '../widgets/browse_map_view.dart';
import '../widgets/search_entry_field.dart';
import '../widgets/listings_grid.dart';
import '../widgets/map_toggle_button.dart';

/// Browse gear listings: one search field, a filters button, and the results
/// as a list, with the map one tap away. Filtering lives in the providers;
/// this screen only arranges the pieces.
class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  bool _showMap = false;

  Future<void> _openSearch(String query) async {
    final selection = await context.push<SearchSelection>(
      '/search',
      extra: query,
    );
    if (selection != null && mounted) {
      applySearchSelection(ref, selection);
    }
  }

  Future<void> _openFilters() {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.kColorBackground,
      builder: (context) => const BrowseFiltersSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(browseFilterProvider);
    final dates = ref.watch(browseDatesProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchRow(filter, dates),
            if (filter.hasCategory || !dates.isEmpty)
              _buildActiveChips(filter, dates),
            Expanded(
              child: Stack(
                children: [
                  _buildResults(filter, bottomInset),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomInset + AppSpacing.kSpacing8,
                    child: Center(
                      child: MapToggleButton(
                        showingMap: _showMap,
                        onTap: () => setState(() => _showMap = !_showMap),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchRow(ListingFilter filter, DateRangeSelection dates) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.kSpacing16,
        AppSpacing.kSpacing8,
        AppSpacing.kSpacing16,
        AppSpacing.kSpacing8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SearchEntryField(
              query: filter.query,
              onTap: () => _openSearch(filter.query),
              onClear: () => ref.read(browseQueryProvider.notifier).state = '',
            ),
          ),
          const SizedBox(width: AppSpacing.kSpacing12),
          BrowseFilterButton(
            hasActiveFilter: filter.hasCategory || !dates.isEmpty,
            onTap: _openFilters,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChips(ListingFilter filter, DateRangeSelection dates) {
    final datesLabel = dateRangeLabel(dates);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.kSpacing16,
        0,
        AppSpacing.kSpacing16,
        AppSpacing.kSpacing8,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: AppSpacing.kSpacing8,
          runSpacing: AppSpacing.kSpacing8,
          children: [
            if (filter.hasCategory)
              ActiveFilterChip(
                label: filter.category,
                onClear: () => ref.read(browseCategoryProvider.notifier).state =
                    ListingFilter.allCategories,
              ),
            if (datesLabel != null)
              ActiveFilterChip(
                label: datesLabel,
                onClear: () => ref.read(browseDatesProvider.notifier).state =
                    DateRangeSelection.empty,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(ListingFilter filter, double bottomInset) {
    final bottomPadding = bottomInset + 48;
    return ref
        .watch(browseResultsProvider)
        .when(
          loading: () => _showMap
              ? const Center(child: CircularProgressIndicator())
              : ListingsGrid.skeleton(bottomPadding: bottomPadding),
          error: (error, _) => ErrorStateWidget(
            message: error is Failure
                ? error.message
                : 'Failed to load listings. Please try again.',
            onRetry: () => ref.invalidate(listingsProvider),
          ),
          data: (listings) {
            if (_showMap) {
              return BrowseMapView(listings: listings);
            }
            if (listings.isEmpty) {
              return _buildEmpty(filter);
            }
            return ListingsGrid(
              listings: listings,
              bottomPadding: bottomPadding,
            );
          },
        );
  }

  Widget _buildEmpty(ListingFilter filter) {
    final hasSearch = filter.query.trim().isNotEmpty;
    return EmptyStateWidget(
      title: hasSearch ? 'No matches' : 'No gear listed yet',
      subtitle: hasSearch
          ? 'Try a different search.'
          : filter.hasCategory
          ? 'No listings in ${filter.category} yet.'
          : 'Be the first to post gear in your area.',
      icon: Icons.camera_alt_outlined,
      action: hasSearch
          ? null
          : TextButton(
              onPressed: () => context.push('/create-listing'),
              child: const Text('Post your gear'),
            ),
    );
  }
}
