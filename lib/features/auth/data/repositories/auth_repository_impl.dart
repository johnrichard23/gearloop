import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

/// [AuthRepository] backed by Supabase Auth and the public `users` table.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({SupabaseClient? client})
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  SupabaseClient get supabase => _supabase;

  @override
  Future<AuthSignInResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final authUser = response.user;
      if (authUser == null) {
        return const AuthSignInFailure(AuthSignInFailureReason.unknown);
      }
      final user = await _fetchUser(authUser.id);
      return AuthSignInSuccess(user);
    } on AuthException {
      return const AuthSignInFailure(AuthSignInFailureReason.invalidCredentials);
    } on Exception {
      return const AuthSignInFailure(AuthSignInFailureReason.unknown);
    }
  }

  /// Email registration — not on [AuthRepository]; used by the register flow.
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      final authUser = response.user;
      if (authUser == null) {
        return const Left(Failure('Registration failed. Please try again.'));
      }
      final user = await _fetchUser(authUser.id);
      return Right(user);
    } on AuthException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return const Left(
        Failure('Something went wrong. Please try again.'),
      );
    }
  }

  @override
  Future<AuthSignInResult> signInWithApple() async {
    return const AuthSignInFailure(AuthSignInFailureReason.providerNotAvailable);
  }

  @override
  Future<AuthSignInResult> signInWithGoogle() async {
    return const AuthSignInFailure(AuthSignInFailureReason.providerNotAvailable);
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Stream<UserEntity?> watchAuthUser() {
    return _supabase.auth.onAuthStateChange.asyncMap((data) async {
      final authUser = data.session?.user;
      if (authUser == null) {
        return null;
      }
      try {
        return await _fetchUser(authUser.id);
      } on Exception {
        return null;
      }
    });
  }

  Future<UserEntity> _fetchUser(String id) async {
    final row = await _supabase
        .from('users')
        .select()
        .eq('id', id)
        .single();
    return _mapUser(row);
  }

  UserEntity _mapUser(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      isHost: json['is_host'] as bool? ?? false,
      isIdVerified: json['is_id_verified'] as bool? ?? false,
      ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0,
      ratingCount: json['rating_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState());

  final AuthRepositoryImpl _repository;

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.signInWithEmail(
      email: email,
      password: password,
    );

    switch (result) {
      case AuthSignInSuccess():
        state = state.copyWith(isLoading: false, clearError: true);
        return true;
      case AuthSignInFailure(:final reason):
        state = state.copyWith(
          isLoading: false,
          errorMessage: _messageForSignInFailure(reason),
        );
        return false;
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false, clearError: true);
        return true;
      },
    );
  }
}

String _messageForSignInFailure(AuthSignInFailureReason reason) {
  return switch (reason) {
    AuthSignInFailureReason.invalidCredentials =>
      'Invalid email or password.',
    AuthSignInFailureReason.cancelledByUser => 'Sign in was cancelled.',
    AuthSignInFailureReason.network =>
      'Network error. Please check your connection.',
    AuthSignInFailureReason.providerNotAvailable =>
      'This sign-in method is not available yet.',
    AuthSignInFailureReason.unknown =>
      'Something went wrong. Please try again.',
  };
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthRepositoryImpl());
});
