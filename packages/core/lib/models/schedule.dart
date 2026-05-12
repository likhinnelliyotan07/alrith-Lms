import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

enum DayOfWeek { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

@freezed
abstract class Schedule with _$Schedule {
  factory Schedule({
    required String id,
    required String batchId,
    required DayOfWeek day,
    required String startTime,
    required String endTime,
    String? subjectId,
    String? teacherId,
    String? roomNumber,
  }) = _$ScheduleImpl;

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
}
