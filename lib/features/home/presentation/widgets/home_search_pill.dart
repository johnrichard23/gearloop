import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../listings/domain/entities/search_selection.dart';
import '../../../listings/presentation/providers/browse_providers.dart';
import '../../../listings/presentation/widgets/search_entry_field.dart';

/// Home's search field. Tapping it opens the full-screen search; whatever is
/// picked there is applied to Browse and Browse is opened.
class HomeSearchPill extends ConsumerWidget {
  const HomeSearchPill({required this.onSearch, super.key});

  /// Opens Browse once something has been picked.
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SearchEntryField(
      onTap: () async {
        final selection = await context.push<SearchSelection>('/search');
        if (selection != null) {
          applySearchSelection(ref, selection);
          onSearch();
        }
      },
    );
  }
}
