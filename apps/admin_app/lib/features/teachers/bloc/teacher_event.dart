import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class TeacherEvent extends Equatable {
  const TeacherEvent();

  @override
  List<Object?> get props => [];
}

class LoadTeachers extends TeacherEvent {
  final String query;
  const LoadTeachers({this.query = ''});

  @override
  List<Object?> get props => [query];
}

class AddTeacherEvent extends TeacherEvent {
  const AddTeacherEvent();
}
