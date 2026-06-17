class BookingPriceCalculation {
  const BookingPriceCalculation({
    required this.totalDays,
    required this.subtotal,
    required this.platformFee,
    required this.depositAmount,
    required this.totalAmount,
  });

  final int totalDays;
  final double subtotal;
  final double platformFee;
  final double depositAmount;
  final double totalAmount;
}

class CalculateBookingPrice {
  const CalculateBookingPrice();

  BookingPriceCalculation call({
    required DateTime startDate,
    required DateTime endDate,
    required double dailyRate,
    required double depositAmount,
  }) {
    final rawDays = endDate.difference(startDate).inDays;
    final totalDays = rawDays < 1 ? 1 : rawDays;
    final subtotal = dailyRate * totalDays;
    final platformFee = subtotal * 0.12;
    final totalAmount = subtotal + platformFee + depositAmount;

    return BookingPriceCalculation(
      totalDays: totalDays,
      subtotal: subtotal,
      platformFee: platformFee,
      depositAmount: depositAmount,
      totalAmount: totalAmount,
    );
  }
}
