import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/core/errors/failures.dart';
import 'package:rentra/features/listings/domain/entities/listing_entity.dart';
import 'package:rentra/features/listings/domain/repositories/listings_repository.dart';
import 'package:rentra/features/listings/domain/usecases/create_listing.dart';
import 'package:mocktail/mocktail.dart';

class MockListingsRepository extends Mock implements ListingsRepository {}

void main() {
  late MockListingsRepository mockRepository;
  late CreateListing useCase;

  const validListing = ListingEntity(
    id: 'listing-test-1',
    hostId: 'host-1',
    title: 'Sony A7III Camera Body',
    category: 'Cameras',
    pricePerDay: '₱800',
    location: 'Legazpi, Albay',
    hostName: 'Marco R.',
    rating: 4.8,
    isVerified: true,
    description: 'Full-frame mirrorless camera body.',
    reviewCount: 10,
    depositAmount: '₱5,000',
    minRentalDays: '1',
    isActive: true,
    isPaused: false,
    lat: 13.1391,
    lng: 123.7440,
  );

  setUpAll(() {
    registerFallbackValue(validListing);
  });

  setUp(() {
    mockRepository = MockListingsRepository();
    useCase = CreateListing(mockRepository);
  });

  group('CreateListing usecase', () {
    test('returns ListingEntity when all fields are valid', () async {
      when(() => mockRepository.createListing(any()))
          .thenAnswer((_) async => const Right(validListing));

      final result = await useCase(validListing);

      expect(result, const Right(validListing));
      verify(() => mockRepository.createListing(validListing)).called(1);
    });

    test('returns Failure when title is empty', () async {
      const listing = ListingEntity(
        id: 'listing-test-1',
        hostId: 'host-1',
        title: '',
        category: 'Cameras',
        pricePerDay: '₱800',
        location: 'Legazpi, Albay',
        hostName: 'Marco R.',
        rating: 4.8,
        isVerified: true,
        description: 'Description',
        reviewCount: 10,
        depositAmount: '₱5,000',
        minRentalDays: '1',
        isActive: true,
        isPaused: false,
        lat: 13.1391,
        lng: 123.7440,
      );

      final result = await useCase(listing);

      expect(result, const Left(Failure('Title is required')));
      verifyNever(() => mockRepository.createListing(any()));
    });

    test('returns Failure when price is empty', () async {
      const listing = ListingEntity(
        id: 'listing-test-1',
        hostId: 'host-1',
        title: 'Sony A7III Camera Body',
        category: 'Cameras',
        pricePerDay: '',
        location: 'Legazpi, Albay',
        hostName: 'Marco R.',
        rating: 4.8,
        isVerified: true,
        description: 'Description',
        reviewCount: 10,
        depositAmount: '₱5,000',
        minRentalDays: '1',
        isActive: true,
        isPaused: false,
        lat: 13.1391,
        lng: 123.7440,
      );

      final result = await useCase(listing);

      expect(result, const Left(Failure('Price is required')));
      verifyNever(() => mockRepository.createListing(any()));
    });

    test('returns Failure when location is empty', () async {
      const listing = ListingEntity(
        id: 'listing-test-1',
        hostId: 'host-1',
        title: 'Sony A7III Camera Body',
        category: 'Cameras',
        pricePerDay: '₱800',
        location: '',
        hostName: 'Marco R.',
        rating: 4.8,
        isVerified: true,
        description: 'Description',
        reviewCount: 10,
        depositAmount: '₱5,000',
        minRentalDays: '1',
        isActive: true,
        isPaused: false,
        lat: 13.1391,
        lng: 123.7440,
      );

      final result = await useCase(listing);

      expect(result, const Left(Failure('Location is required')));
    });

    test('returns Failure when category is empty', () async {
      const listing = ListingEntity(
        id: 'listing-test-1',
        hostId: 'host-1',
        title: 'Sony A7III Camera Body',
        category: '',
        pricePerDay: '₱800',
        location: 'Legazpi, Albay',
        hostName: 'Marco R.',
        rating: 4.8,
        isVerified: true,
        description: 'Description',
        reviewCount: 10,
        depositAmount: '₱5,000',
        minRentalDays: '1',
        isActive: true,
        isPaused: false,
        lat: 13.1391,
        lng: 123.7440,
      );

      final result = await useCase(listing);

      expect(result, const Left(Failure('Category is required')));
    });

    test('returns Failure when repository fails', () async {
      when(() => mockRepository.createListing(any())).thenAnswer(
        (_) async => const Left(Failure('Server error')),
      );

      final result = await useCase(validListing);

      expect(result, const Left(Failure('Server error')));
      verify(() => mockRepository.createListing(validListing)).called(1);
    });
  });
}
