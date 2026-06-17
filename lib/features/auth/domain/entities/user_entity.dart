/// Domain model for a GearLoop user — aligns with the public `users` table (ARCHITECTURE.md).
class UserEntity {
  const UserEntity({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.phone,
    this.bio,
    required this.isHost,
    required this.isIdVerified,
    required this.ratingAvg,
    required this.ratingCount,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Primary key; matches `auth.users.id`.
  final String id;

  final String fullName;
  final String? avatarUrl;
  final String? phone;
  final String? bio;

  final bool isHost;
  final bool isIdVerified;

  /// Average rating (1–5 scale), persisted as `numeric(3,2)`.
  final double ratingAvg;
  final int ratingCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is UserEntity &&
        other.id == id &&
        other.fullName == fullName &&
        other.avatarUrl == avatarUrl &&
        other.phone == phone &&
        other.bio == bio &&
        other.isHost == isHost &&
        other.isIdVerified == isIdVerified &&
        other.ratingAvg == ratingAvg &&
        other.ratingCount == ratingCount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        fullName,
        avatarUrl,
        phone,
        bio,
        isHost,
        isIdVerified,
        ratingAvg,
        ratingCount,
        createdAt,
        updatedAt,
      );
}
