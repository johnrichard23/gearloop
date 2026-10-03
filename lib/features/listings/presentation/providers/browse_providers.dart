import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../date_selection/domain/entities/date_range_selection.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/entities/listing_filter.dart';
import '../../domain/entities/search_selection.dart';
import '../../domain/usecases/filter_listings.dart';
import 'listings_provider.dart';

/// Category chosen on Browse. Home sets it before opening Browse so a tapped
/// category lands on its results.
final browseCategoryProvider = StateProvider<String>(
  (ref) => ListingFilter.allCategories,
);

/// Text typed in Browse's search field.
final browseQueryProvider = StateProvider<String>((ref) => '');

/// Days chosen on the dates screen. Not yet applied to the results: that needs
/// per-listing availability from the backend.
final browseDatesProvider = StateProvider<DateRangeSelection>(
  (ref) => DateRangeSelection.empty,
);

/// The filter Browse is currently applying.
final browseFilterProvider = Provider<ListingFilter>((ref) {
  return ListingFilter(
    category: ref.watch(browseCategoryProvider),
    query: ref.watch(browseQueryProvider),
  );
});

/// The use case that applies a filter, replaceable in tests.
final filterListingsProvider = Provider<FilterListings>(
  (ref) => const FilterListings(),
);

/// Listings after the Browse filter, keeping the load and error states.
final browseResultsProvider = Provider<AsyncValue<List<ListingEntity>>>((ref) {
  final filter = ref.watch(browseFilterProvider);
  final filterListings = ref.watch(filterListingsProvider);
  return ref
      .watch(listingsProvider)
      .whenData((listings) => filterListings(listings, filter));
});

/// Makes Browse show what the renter picked on the search screen.
void applySearchSelection(WidgetRef ref, SearchSelection selection) {
  ref.read(browseQueryProvider.notifier).state = selection.query;
  ref.read(browseCategoryProvider.notifier).state = selection.category;
}
