import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
  @override
  List<Object?> get props => [];
}

class LoadCourses extends CourseEvent {}

class AddCourse extends CourseEvent {
  final Course course;
  const AddCourse(this.course);
  @override
  List<Object?> get props => [course];
}
