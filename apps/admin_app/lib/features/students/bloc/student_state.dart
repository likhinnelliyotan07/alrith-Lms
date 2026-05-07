import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class StudentState extends Equatable {
  const StudentState();
  
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentsLoaded extends StudentState {
  final List<Profile> students;

  const StudentsLoaded(this.students);

  @override
  List<Object?> get props => [students];
}

class StudentFailure extends StudentState {
  final String message;

  const StudentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
