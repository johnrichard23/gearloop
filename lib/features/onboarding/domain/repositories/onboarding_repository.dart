/// Remembers whether this device has already finished the first-run story.
abstract interface class OnboardingRepository {
  /// `true` once the user left onboarding through any of its exits.
  bool get hasSeenOnboarding;

  /// Records that onboarding was seen. Returns `false` if the flag could not
  /// be saved; callers continue either way (the story just shows again).
  Future<bool> markSeen();
}
