import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/recently_viewed_provider.dart';

/// Wraps a listing's detail screen and notes that this listing was opened.
class ViewedListingRecorder extends ConsumerStatefulWidget {
  const ViewedListingRecorder({
    required this.listingId,
    required this.child,
    super.key,
  });

  final String listingId;
  final Widget child;

  @override
  ConsumerState<ViewedListingRecorder> createState() =>
      _ViewedListingRecorderState();
}

class _ViewedListingRecorderState extends ConsumerState<ViewedListingRecorder> {
  @override
  void initState() {
    super.initState();
    // Provider state may not change while the tree is building.
    Future.microtask(
      () => ref.read(recentlyViewedProvider.notifier).add(widget.listingId),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
