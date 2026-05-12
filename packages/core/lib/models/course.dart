import 'package:freezed_annotation/freezed_annotation.dart';
import 'subject.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
abstract class Course with _$Course {
  factory Course({
    required String id,
    required String title,
    required String description,
    String? thumbnail,
    @JsonKey(name: 'organization_id') required String organizationId,
    @JsonKey(name: 'teacher_ids') @Default([]) List<String> teacherIds,
    @Default(0) double price,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default([]) List<Subject> subjects,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _$CourseImpl;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
