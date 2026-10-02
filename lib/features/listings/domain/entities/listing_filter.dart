import 'package:equatable/equatable.dart';

import '../filters/listing_criterion.dart';

/// What the renter has asked to narrow the listings by. Each field that is set
/// contributes one [ListingCriterion]; a new kind of filter adds a field and a
/// criterion without touching the code that applies them.
class ListingFilter extends Equatable {
  const ListingFilter({this.category = allCategories, this.query = ''});

  /// Category value meaning "no category filter".
  static const String allCategories = 'All';

  final String category;
  final String query;

  /// Whether a category (not "All") is selected.
  bool get hasCategory => category != allCategories;

  /// The criteria this filter turns into.
  List<ListingCriterion> get criteria => [
    if (hasCategory) CategoryCriterion(category),
    if (query.trim().isNotEmpty) QueryCriterion(query),
  ];

  @override
  List<Object?> get props => [category, query];
}
