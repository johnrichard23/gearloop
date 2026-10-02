import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/listings/domain/entities/listing_entity.dart';
import 'package:rentra/features/listings/domain/entities/listing_filter.dart';
import 'package:rentra/features/listings/domain/usecases/filter_listings.dart';

ListingEntity _listing(String id, String title, String category) {
  return ListingEntity(
    id: id,
    hostId: 'host-1',
    title: title,
    category: category,
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
  const filterListings = FilterListings();

  final sony = _listing('1', 'Sony A7III', 'Cameras');
  final dji = _listing('2', 'DJI Mini 3', 'Drones');
  final tent = _listing('3', 'Decathlon Tent', 'Camping');
  final listings = [sony, dji, tent];

  group('FilterListings', () {
    test('returns every listing when no filter is set', () {
      expect(filterListings(listings, const ListingFilter()), listings);
    });

    test('keeps only the chosen category', () {
      const filter = ListingFilter(category: 'Drones');
      expect(filterListings(listings, filter), [dji]);
    });

    test('matches the search text against the title, ignoring case', () {
      const filter = ListingFilter(query: 'sony');
      expect(filterListings(listings, filter), [sony]);
    });

    test('matches the search text against the category', () {
      const filter = ListingFilter(query: 'camp');
      expect(filterListings(listings, filter), [tent]);
    });

    test('ignores a search made only of spaces', () {
      const filter = ListingFilter(query: '   ');
      expect(filterListings(listings, filter), listings);
    });

    test('requires every criterion to match', () {
      const filter = ListingFilter(category: 'Cameras', query: 'dji');
      expect(filterListings(listings, filter), isEmpty);
    });

    test('returns an empty list when nothing matches', () {
      const filter = ListingFilter(query: 'zzz');
      expect(filterListings(listings, filter), isEmpty);
    });
  });
}
