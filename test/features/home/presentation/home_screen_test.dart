import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/home/presentation/screens/home_screen.dart';
import 'package:rentra/features/home/presentation/widgets/home_category_row.dart';
import 'package:rentra/features/listings/domain/entities/listing_entity.dart';
import 'package:rentra/features/listings/presentation/providers/browse_providers.dart';
import 'package:rentra/features/listings/presentation/providers/listings_provider.dart';

/// Counts how many times the listings were loaded.
class _CountingListings extends ListingsNotifier {
  static int loads = 0;

  @override
  Future<List<ListingEntity>> build() async {
    loads++;
    return const [
      ListingEntity(
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
}

void main() {
  late ProviderContainer container;
  var browseOpened = 0;

  Future<void> pumpHome(WidgetTester tester) async {
    _CountingListings.loads = 0;
    browseOpened = 0;
    container = ProviderContainer(
      overrides: [listingsProvider.overrideWith(_CountingListings.new)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(home: HomeScreen(onBrowseTap: () => browseOpened++)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('pulling down reloads the listings', (tester) async {
    await pumpHome(tester);
    expect(_CountingListings.loads, 1);

    await tester.fling(
      find.byType(SingleChildScrollView).first,
      const Offset(0, 400),
      1000,
    );
    await tester.pumpAndSettle();

    expect(_CountingListings.loads, 2);
    expect(find.text('Sony A7 IV'), findsOneWidget);
  });

  testWidgets('the All tile opens every category and picking one browses it', (
    tester,
  ) async {
    await pumpHome(tester);
    final rowScrollable = find.descendant(
      of: find.byType(HomeCategoryRow),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('All'),
      200,
      scrollable: rowScrollable,
    );
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();

    expect(find.text('All categories'), findsOneWidget);
    await tester.tap(find.text('Utility').last);
    await tester.pumpAndSettle();

    expect(container.read(browseCategoryProvider), 'Utility');
    expect(browseOpened, 1);
    expect(find.text('All categories'), findsNothing);
  });
}
