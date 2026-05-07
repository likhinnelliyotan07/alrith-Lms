import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final AdminRepository _adminRepository;

  StudentBloc(this._adminRepository) : super(StudentInitial()) {
    on<LoadStudents>((event, emit) async {
      emit(StudentLoading());
      try {
        final students = await _adminRepository.getStudents();
        if (event.query.isNotEmpty) {
          final filtered = students.where((s) => s.fullName.toLowerCase().contains(event.query.toLowerCase())).toList();
          emit(StudentsLoaded(filtered));
        } else {
          emit(StudentsLoaded(students));
        }
      } catch (e) {
        emit(StudentFailure(e.toString()));
      }
    });

    on<DeleteStudent>((event, emit) async {
      // Implement deletion in repo first
      try {
        // await _adminRepository.deleteStudent(event.studentId);
        add(const LoadStudents());
      } catch (e) {
        emit(StudentFailure(e.toString()));
      }
    });
  }
}
