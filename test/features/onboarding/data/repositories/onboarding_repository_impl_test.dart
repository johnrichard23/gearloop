import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('OnboardingRepositoryImpl', () {
    test('hasSeenOnboarding is false on a fresh install', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = OnboardingRepositoryImpl(
        await SharedPreferences.getInstance(),
      );

      expect(repository.hasSeenOnboarding, isFalse);
    });

    test('markSeen saves the flag and returns true', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = OnboardingRepositoryImpl(prefs);

      final saved = await repository.markSeen();

      expect(saved, isTrue);
      expect(repository.hasSeenOnboarding, isTrue);
      expect(prefs.getBool(OnboardingRepositoryImpl.seenKey), isTrue);
    });

    test('hasSeenOnboarding is true when the flag was stored earlier', () async {
      SharedPreferences.setMockInitialValues({
        OnboardingRepositoryImpl.seenKey: true,
      });
      final repository = OnboardingRepositoryImpl(
        await SharedPreferences.getInstance(),
      );

      expect(repository.hasSeenOnboarding, isTrue);
    });
  });
}
