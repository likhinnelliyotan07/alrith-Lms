import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class TeacherState extends Equatable {
  const TeacherState();

  @override
  List<Object?> get props => [];
}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeachersLoaded extends TeacherState {
  final List<Profile> teachers;
  const TeachersLoaded(this.teachers);

  @override
  List<Object?> get props => [teachers];
}

class TeacherFailure extends TeacherState {
  final String message;
  const TeacherFailure(this.message);

  @override
  List<Object?> get props => [message];
}
