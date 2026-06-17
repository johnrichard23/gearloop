import 'package:flutter_test/flutter_test.dart';
import 'package:gearloop/features/bookings/domain/usecases/calculate_booking_price.dart';

void main() {
  group('CalculateBookingPrice', () {
    const useCase = CalculateBookingPrice();

    test(
      'calculates correct totalDays, subtotal, platformFee, and totalAmount for a 2-day rental',
      () {
        final today = DateTime.now();
        final result = useCase(
          startDate: today,
          endDate: today.add(const Duration(days: 2)),
          dailyRate: 800,
          depositAmount: 5000,
        );

        expect(result.totalDays, 2);
        expect(result.subtotal, 1600);
        expect(result.platformFee, 192);
        expect(result.totalAmount, 6792);
      },
    );

    test('enforces minimum of 1 day even if dates are the same', () {
      final today = DateTime.now();
      final result = useCase(
        startDate: today,
        endDate: today,
        dailyRate: 800,
        depositAmount: 5000,
      );

      expect(result.totalDays, 1);
    });

    test('calculates correctly for a 7-day rental', () {
      final today = DateTime.now();
      final result = useCase(
        startDate: today,
        endDate: today.add(const Duration(days: 7)),
        dailyRate: 200,
        depositAmount: 1200,
      );

      expect(result.totalDays, 7);
      expect(result.subtotal, 1400);
      expect(result.platformFee, 168);
      expect(result.totalAmount, 2768);
    });
  });
}
