/// One slide of the first-run story: a headline with one highlighted word and
/// a supporting line.
class OnboardingSlide {
  const OnboardingSlide({
    required this.lead,
    required this.highlight,
    required this.body,
  });

  /// Headline text before the highlighted word.
  final String lead;

  /// The word that gets the hand-drawn underline.
  final String highlight;

  /// The supporting line under the headline.
  final String body;
}

/// The slides, in the order they play. Each pairs with a scene of the same
/// position (radar, earn, return).
const List<OnboardingSlide> kOnboardingSlides = [
  OnboardingSlide(
    lead: 'Rent what you ',
    highlight: 'need',
    body:
        'Cameras, drones, camping and audio gear from people near you, '
        'by the day.',
  ),
  OnboardingSlide(
    lead: 'Make your gear ',
    highlight: 'earn',
    body:
        'Earn from what you own. List it, set your daily rate, and '
        "you're done.",
  ),
  OnboardingSlide(
    lead: 'Rent. Use. ',
    highlight: 'Return.',
    body:
        'Book the dates, pick it up from a neighbor, and bring it back '
        'when you are done.',
  ),
];
