import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

enum UserRole { admin, teacher, student, parent }

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String email,
    required String fullName,
    String? avatarUrl,
    required UserRole role,
    String? phoneNumber,
    String? organizationId,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
