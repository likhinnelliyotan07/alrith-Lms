import 'package:freezed_annotation/freezed_annotation.dart';
import 'subject.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
class Course with _$Course {
  const factory Course({
    required String id,
    required String title,
    required String description,
    String? thumbnail,
    required String organizationId,
    @Default([]) List<String> teacherIds,
    @Default(0) double price,
    @Default(true) bool isActive,
    @Default([]) List<Subject> subjects,
    DateTime? createdAt,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
