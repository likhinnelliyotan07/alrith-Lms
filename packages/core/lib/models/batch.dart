import 'package:freezed_annotation/freezed_annotation.dart';
import 'schedule.dart';

part 'batch.freezed.dart';
part 'batch.g.dart';

@freezed
class Batch with _$Batch {
  const factory Batch({
    required String id,
    required String name,
    required String courseId,
    required DateTime startDate,
    DateTime? endDate,
    @Default(30) int capacity,
    @Default(0) int enrolledCount,
    @Default([]) List<Schedule> schedules,
    required String organizationId,
  }) = _Batch;

  factory Batch.fromJson(Map<String, dynamic> json) => _$BatchFromJson(json);
}
