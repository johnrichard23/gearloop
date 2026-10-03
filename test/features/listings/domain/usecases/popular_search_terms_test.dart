import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/listings/domain/entities/listing_entity.dart';
import 'package:rentra/features/listings/domain/usecases/popular_search_terms.dart';

ListingEntity _listing(String category, int reviews) {
  return ListingEntity(
    id: '$category$reviews',
    hostId: 'host-1',
    title: 'Item',
    category: category,
    pricePerDay: '₱500',
    location: 'Sorsogon City',
    hostName: 'Marco R.',
    rating: 4.5,
    isVerified: true,
    description: 'Test listing.',
    reviewCount: reviews,
    depositAmount: '₱250',
    minRentalDays: '1',
    isActive: true,
    isPaused: false,
    lat: 12.97,
    lng: 124.0,
  );
}

void main() {
  const popularTerms = PopularSearchTerms();

  test('is empty when there are no listings', () {
    expect(popularTerms([]), isEmpty);
  });

  test('ranks by total reviews, then listing count, then name', () {
    final result = popularTerms([
      _listing('Drones', 2),
      _listing('Cameras', 5),
      _listing('Cameras', 4),
      _listing('Audio', 0),
      _listing('Camping', 0),
      _listing('Camping', 0),
    ]);
    expect(result, ['Cameras', 'Drones', 'Camping', 'Audio']);
  });

  test('keeps only the top six categories', () {
    final result = popularTerms([
      for (final c in ['A', 'B', 'C', 'D', 'E', 'F', 'G']) _listing(c, 1),
    ]);
    expect(result.length, PopularSearchTerms.maxTerms);
  });
}
