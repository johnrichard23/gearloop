import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rentra/features/listings/domain/entities/listing_entity.dart';
import 'package:rentra/features/listings/domain/entities/search_selection.dart';
import 'package:rentra/features/listings/domain/repositories/recent_searches_repository.dart';
import 'package:rentra/features/listings/domain/repositories/recently_viewed_repository.dart';
import 'package:rentra/features/listings/presentation/providers/listings_provider.dart';
import 'package:rentra/features/listings/presentation/providers/recently_viewed_provider.dart';
import 'package:rentra/features/listings/presentation/providers/recent_searches_provider.dart';
import 'package:rentra/features/listings/presentation/screens/search_screen.dart';
import 'package:rentra/features/listings/presentation/widgets/category_choice_chip.dart';

class _FakeRepository implements RecentSearchesRepository {
  _FakeRepository(this.saved);

  List<String> saved;

  @override
  List<String> load() => saved;

  @override
  Future<bool> save(List<String> searches) async {
    saved = searches;
    return true;
  }
}

class _FakeViewedRepository implements RecentlyViewedRepository {
  _FakeViewedRepository(this.saved);

  List<String> saved;

  @override
  List<String> load() => saved;

  @override
  Future<bool> save(List<String> listingIds) async {
    saved = listingIds;
    return true;
  }
}

class _FakeListings extends ListingsNotifier {
  @override
  Future<List<ListingEntity>> build() async => [
    const ListingEntity(
      id: '1',
      hostId: 'h',
      title: 'Sony A7 IV',
      category: 'Cameras',
      pricePerDay: '₱500',
      location: 'Sorsogon City',
      hostName: 'Marco R.',
      rating: 4.5,
      isVerified: true,
      description: '',
      reviewCount: 3,
      depositAmount: '₱250',
      minRentalDays: '1',
      isActive: true,
      isPaused: false,
      lat: 0,
      lng: 0,
    ),
  ];
}

void main() {
  late _FakeRepository repository;
  SearchSelection? result;

  Future<void> openSearch(
    WidgetTester tester,
    List<String> recents, {
    List<String> viewed = const [],
  }) async {
    repository = _FakeRepository(recents);
    result = null;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async =>
                    result = await context.push<SearchSelection>('/search'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recentSearchesRepositoryProvider.overrideWithValue(repository),
          recentlyViewedRepositoryProvider.overrideWithValue(
            _FakeViewedRepository(viewed),
          ),
          listingsProvider.overrideWith(_FakeListings.new),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('opens with the field focused and recents listed', (
    tester,
  ) async {
    await openSearch(tester, ['tent', 'drone']);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode?.hasFocus, isTrue);
    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('tent'), findsOneWidget);
  });

  testWidgets('with no history it shows only popular terms', (tester) async {
    await openSearch(tester, []);
    expect(find.text('Recent searches'), findsNothing);
    expect(find.text('Popular near you'), findsOneWidget);
  });

  testWidgets('shows recents above popular terms, and popular ones browse', (
    tester,
  ) async {
    await openSearch(tester, ['tent']);
    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('Popular near you'), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    expect(tester.getSize(find.byType(CategoryChoiceChip).first).height, 48);

    await tester.tap(find.text('Cameras'));
    await tester.pumpAndSettle();
    expect(result?.category, 'Cameras');
    expect(repository.saved, ['tent']);
  });

  testWidgets('tapping a recent returns it and saves it first', (tester) async {
    await openSearch(tester, ['tent', 'drone']);
    await tester.tap(find.text('drone'));
    await tester.pumpAndSettle();

    expect(result?.query, 'drone');
    expect(repository.saved, ['drone', 'tent']);
  });

  testWidgets('typing shows suggestions and submitting returns the query', (
    tester,
  ) async {
    await openSearch(tester, []);
    await tester.enterText(find.byType(TextField), 'son');
    await tester.pumpAndSettle();

    expect(find.text('Search for "son"'), findsOneWidget);
    expect(find.text('Sony A7 IV', findRichText: true), findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(result?.query, 'son');
    expect(repository.saved, ['son']);
  });

  testWidgets('tapping a category suggestion returns the category', (
    tester,
  ) async {
    await openSearch(tester, []);
    await tester.enterText(find.byType(TextField), 'cam');
    await tester.pump();
    await tester.tap(find.text('Cameras'));
    await tester.pumpAndSettle();

    expect(result?.category, 'Cameras');
    expect(result?.query, '');
    expect(repository.saved, isEmpty);
  });

  testWidgets('the clear button appears when typing and erases the query', (
    tester,
  ) async {
    await openSearch(tester, ['tent']);
    expect(find.byTooltip('Clear search'), findsNothing);

    await tester.enterText(find.byType(TextField), 'camera');
    await tester.pump();
    expect(find.byTooltip('Clear search'), findsOneWidget);

    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
    expect(field.focusNode?.hasFocus, isTrue);
    expect(find.byTooltip('Clear search'), findsNothing);
    expect(find.text('Recent searches'), findsOneWidget);
  });

  testWidgets('shows recently viewed listings, and hides it when empty', (
    tester,
  ) async {
    await openSearch(tester, [], viewed: ['1', 'gone']);
    expect(find.text('Recently viewed'), findsOneWidget);
    expect(find.text('Sony A7 IV'), findsOneWidget);
    expect(find.text('₱500/day', findRichText: true), findsOneWidget);
  });

  testWidgets('has no recently viewed section without history', (tester) async {
    await openSearch(tester, []);
    expect(find.text('Recently viewed'), findsNothing);
  });

  testWidgets('Cancel closes search and returns nothing', (tester) async {
    await openSearch(tester, ['tent']);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });
}
