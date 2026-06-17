import 'package:equatable/equatable.dart';

/// Domain model for a GearLoop user profile (not yet mapped from Supabase).
class UserProfileEntity extends Equatable {
  const UserProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    required this.memberSince,
    required this.ratingAvg,
    required this.ratingCount,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isIdVerified,
    required this.isHost,
    required this.totalListings,
    required this.totalRentals,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String memberSince;
  final double ratingAvg;
  final int ratingCount;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isIdVerified;
  final bool isHost;
  final int totalListings;
  final int totalRentals;

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        avatarUrl,
        memberSince,
        ratingAvg,
        ratingCount,
        isEmailVerified,
        isPhoneVerified,
        isIdVerified,
        isHost,
        totalListings,
        totalRentals,
      ];
}
