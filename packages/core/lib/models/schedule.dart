import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

enum DayOfWeek { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

@freezed
class Schedule with _$Schedule {
  const factory Schedule({
    required String id,
    required String batchId,
    required DayOfWeek day,
    required String startTime,
    required String endTime,
    String? subjectId,
    String? teacherId,
    String? roomNumber,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);
}
