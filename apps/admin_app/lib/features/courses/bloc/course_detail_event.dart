import 'package:equatable/equatable.dart';

abstract class CourseDetailEvent extends Equatable {
  const CourseDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadCourseDetail extends CourseDetailEvent {
  final String courseId;
  const LoadCourseDetail(this.courseId);
  @override
  List<Object?> get props => [courseId];
}
