import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

enum UserRole { admin, teacher, student, parent }

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String email,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    required UserRole role,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'organization_id') String? organizationId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}
