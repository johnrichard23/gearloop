import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/onboarding_repository.dart';

/// [OnboardingRepository] backed by [SharedPreferences].
class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String seenKey = 'has_seen_onboarding';

  @override
  bool get hasSeenOnboarding => _prefs.getBool(seenKey) ?? false;

  @override
  Future<bool> markSeen() async {
    try {
      return await _prefs.setBool(seenKey, true);
    } on Exception {
      return false;
    }
  }
}
