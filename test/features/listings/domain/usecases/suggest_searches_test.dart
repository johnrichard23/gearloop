import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/listings/domain/entities/listing_entity.dart';
import 'package:rentra/features/listings/domain/usecases/suggest_searches.dart';

ListingEntity _listing(String id, String title) {
  return ListingEntity(
    id: id,
    hostId: 'host-1',
    title: title,
    category: 'Cameras',
    pricePerDay: '₱500',
    location: 'Sorsogon City',
    hostName: 'Marco R.',
    rating: 4.5,
    isVerified: true,
    description: 'Test listing.',
    reviewCount: 3,
    depositAmount: '₱250',
    minRentalDays: '1',
    isActive: true,
    isPaused: false,
    lat: 12.97,
    lng: 124.0,
  );
}

void main() {
  const suggestSearches = SuggestSearches();
  final listings = [
    _listing('1', 'Sony A7 IV'),
    _listing('2', 'Sony A6400 kit'),
    _listing('3', 'Decathlon Tent'),
  ];

  test('suggests nothing for an empty query', () {
    expect(suggestSearches(listings, '  ').isEmpty, isTrue);
  });

  test('matches listing titles, ignoring case', () {
    final result = suggestSearches(listings, 'SONY');
    expect(result.titles, ['Sony A7 IV', 'Sony A6400 kit']);
    expect(result.categories, isEmpty);
  });

  test('matches categories but never "All"', () {
    expect(suggestSearches(listings, 'cam').categories, ['Cameras', 'Camping']);
    expect(suggestSearches(listings, 'all').categories, isEmpty);
  });

  test('repeats a title once and caps titles at four', () {
    final many = [
      _listing('1', 'Tent A'),
      _listing('2', 'Tent A'),
      for (var i = 0; i < 6; i++) _listing('x$i', 'Tent B$i'),
    ];
    final titles = suggestSearches(many, 'tent').titles;
    expect(titles.length, SuggestSearches.maxTitles);
    expect(titles.where((title) => title == 'Tent A').length, 1);
  });
}
