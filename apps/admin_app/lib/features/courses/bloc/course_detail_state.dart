import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class CourseDetailState extends Equatable {
  const CourseDetailState();
  @override
  List<Object?> get props => [];
}

class CourseDetailInitial extends CourseDetailState {}

class CourseDetailLoading extends CourseDetailState {}

class CourseDetailLoaded extends CourseDetailState {
  final Course course;
  const CourseDetailLoaded(this.course);
  @override
  List<Object?> get props => [course];
}

class CourseDetailFailure extends CourseDetailState {
  final String message;
  const CourseDetailFailure(this.message);
  @override
  List<Object?> get props => [message];
}
