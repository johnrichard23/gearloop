/// Says which days a particular screen cannot offer, such as days a listing is
/// already booked. The calendar depends on this, not on where the answer comes
/// from.
abstract interface class DayAvailability {
  bool isDisabled(DateTime day);
}

/// Every day is open.
class AllDaysAvailable implements DayAvailability {
  const AllDaysAvailable();

  @override
  bool isDisabled(DateTime day) => false;
}
