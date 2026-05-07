import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class CourseState extends Equatable {
  const CourseState();
  @override
  List<Object?> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CoursesLoaded extends CourseState {
  final List<Course> courses;
  const CoursesLoaded(this.courses);
  @override
  List<Object?> get props => [courses];
}

class CourseFailure extends CourseState {
  final String message;
  const CourseFailure(this.message);
  @override
  List<Object?> get props => [message];
}
