import '../entities/user_entity.dart';

/// Outcome of a sign-in attempt (Success / Failure pattern per CONSTITUTION.md).
sealed class AuthSignInResult {
  const AuthSignInResult();
}

final class AuthSignInSuccess extends AuthSignInResult {
  const AuthSignInSuccess(this.user);
  final UserEntity user;
}

final class AuthSignInFailure extends AuthSignInResult {
  const AuthSignInFailure(this.reason);
  final AuthSignInFailureReason reason;
}

enum AuthSignInFailureReason {
  invalidCredentials,
  cancelledByUser,
  network,
  providerNotAvailable,
  unknown,
}

/// Contract for authentication — implemented in `data/` later.
abstract interface class AuthRepository {
  Future<AuthSignInResult> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthSignInResult> signInWithApple();

  Future<AuthSignInResult> signInWithGoogle();

  Future<void> signOut();

  /// Emits `null` when signed out; otherwise the latest `users` profile for the session.
  Stream<UserEntity?> watchAuthUser();
}
