import 'package:freezed_annotation/freezed_annotation.dart';
import 'schedule.dart';

part 'batch.freezed.dart';
part 'batch.g.dart';

@freezed
class Batch with _$Batch {
  const factory Batch({
    required String id,
    required String name,
    @JsonKey(name: 'course_id') required String courseId,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @Default(30) int capacity,
    @JsonKey(name: 'enrolled_count') @Default(0) int enrolledCount,
    @Default([]) List<Schedule> schedules,
    @JsonKey(name: 'organization_id') required String organizationId,
  }) = _Batch;

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);
}
