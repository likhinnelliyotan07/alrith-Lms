import 'package:equatable/equatable.dart';
import 'package:core/core.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudents extends StudentEvent {
  final String query;
  const LoadStudents({this.query = ''});

  @override
  List<Object?> get props => [query];
}

class DeleteStudent extends StudentEvent {
  final String studentId;
  const DeleteStudent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
