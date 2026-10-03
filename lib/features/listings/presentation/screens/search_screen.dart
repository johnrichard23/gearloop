import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/entities/search_selection.dart';
import '../../domain/usecases/popular_search_terms.dart';
import '../../domain/usecases/suggest_searches.dart';
import '../providers/listings_provider.dart';
import '../providers/recent_searches_provider.dart';
import '../providers/recently_viewed_provider.dart';
import '../widgets/browse_search_field.dart';
import '../widgets/category_choice_chip.dart';
import '../widgets/category_icons.dart';
import '../widgets/match_highlight_text.dart';
import '../widgets/recent_searches_panel.dart';
import '../widgets/recently_viewed_row.dart';

/// Full-screen search. It opens with the keyboard up and nothing else to
/// look at: recent searches while the field is empty, suggestions as the
/// renter types. Leaving it hands back a [SearchSelection] (or nothing, if
/// they went back).
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({this.initialQuery = '', super.key});

  final String initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchFor(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      return;
    }
    ref.read(recentSearchesProvider.notifier).add(query);
    context.pop(SearchSelection(query: query));
  }

  /// Closes the keyboard and the screen together so neither waits on the other.
  /// Nothing is handed back, so the page underneath keeps its state.
  void _cancel() {
    FocusManager.instance.primaryFocus?.unfocus();
    context.pop();
  }

  void _browseCategory(String category) {
    context.pop(SearchSelection(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopRow(),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                children: [
                  if (_controller.text.trim().isEmpty)
                    ..._buildZeroState()
                  else
                    ..._buildSuggestions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.kSpacing16,
        AppSpacing.kSpacing8,
        AppSpacing.kSpacing4,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: BrowseSearchField(
              controller: _controller,
              autofocus: true,
              onChanged: (_) {},
              onSubmitted: _searchFor,
            ),
          ),
          // The way out: closes search and leaves the page underneath exactly
          // as it was, scroll position included.
          TextButton(
            onPressed: _cancel,
            style: TextButton.styleFrom(
              minimumSize: const Size(
                AppSpacing.kSpacing48,
                AppSpacing.kSpacing48,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.kSpacing12,
              ),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.kTextBodyMedium.copyWith(
                color: AppColors.kColorPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Before anything is typed: the renter's own recent searches, what is
  /// popular near them, then the listings they looked at last. Empty sections
  /// are left out.
  List<Widget> _buildZeroState() {
    final searches = ref.watch(recentSearchesProvider);
    final notifier = ref.read(recentSearchesProvider.notifier);
    final listings = ref.watch(listingsProvider).valueOrNull ?? const [];
    final popular = const PopularSearchTerms()(listings);
    final viewed = ref.watch(recentlyViewedListingsProvider);
    if (searches.isEmpty && popular.isEmpty && viewed.isEmpty) {
      return [
        Text(
          'Try "camera", "tent" or "drone".',
          style: AppTextStyles.kTextBodySmall,
        ),
      ];
    }
    final sections = <List<Widget>>[
      if (searches.isNotEmpty)
        [
          RecentSearchesPanel(
            searches: searches,
            onSelect: _searchFor,
            onRemove: notifier.remove,
            onClearAll: notifier.clear,
          ),
        ],
      if (popular.isNotEmpty) _buildPopular(popular),
      if (viewed.isNotEmpty) _buildViewed(viewed),
    ];
    // A section's own parts stay close; sections sit 24dp apart.
    return [
      for (var i = 0; i < sections.length; i++) ...[
        if (i > 0) const SizedBox(height: AppSpacing.kSpacing24),
        ...sections[i],
      ],
    ];
  }

  List<Widget> _buildPopular(List<String> popular) {
    return [
      Text('Popular near you', style: AppTextStyles.kTextLabel),
      const SizedBox(height: AppSpacing.kSpacing12),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final category in popular) ...[
              CategoryChoiceChip(
                label: category,
                icon: categoryIcon(category),
                isSelected: false,
                onTap: () => _browseCategory(category),
              ),
              if (category != popular.last)
                const SizedBox(width: AppSpacing.kSpacing8),
            ],
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildViewed(List<ListingEntity> viewed) {
    return [
      Text('Recently viewed', style: AppTextStyles.kTextLabel),
      const SizedBox(height: AppSpacing.kSpacing8),
      for (final listing in viewed)
        RecentlyViewedRow(
          listing: listing,
          onTap: () => context.push('/listing/${listing.id}', extra: listing),
        ),
    ];
  }

  List<Widget> _buildSuggestions() {
    final query = _controller.text.trim();
    final listings = ref.watch(listingsProvider).valueOrNull ?? const [];
    final suggestions = const SuggestSearches()(listings, query);
    return [
      _SuggestionRow(
        icon: Icons.search,
        label: Text(
          'Search for "$query"',
          style: AppTextStyles.kTextBodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => _searchFor(query),
      ),
      for (final category in suggestions.categories)
        _SuggestionRow(
          icon: Icons.grid_view_outlined,
          label: MatchHighlightText(text: category, query: query),
          hint: 'Category',
          onTap: () => _browseCategory(category),
        ),
      for (final title in suggestions.titles)
        _SuggestionRow(
          icon: Icons.north_west,
          label: MatchHighlightText(text: title, query: query),
          onTap: () => _searchFor(title),
        ),
    ];
  }
}

class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hint,
  });

  final IconData icon;
  final Widget label;
  final String? hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.kSpacing48),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSpacing.kIconMedium,
              color: AppColors.kColorTextSecondary,
            ),
            const SizedBox(width: AppSpacing.kSpacing12),
            Expanded(child: label),
            if (hint != null) Text(hint!, style: AppTextStyles.kTextBodySmall),
          ],
        ),
      ),
    );
  }
}
