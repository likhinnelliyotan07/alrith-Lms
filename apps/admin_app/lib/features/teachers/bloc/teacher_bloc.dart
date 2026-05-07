import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'teacher_event.dart';
import 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final AdminRepository _repository;

  TeacherBloc(this._repository) : super(TeacherInitial()) {
    on<LoadTeachers>((event, emit) async {
      emit(TeacherLoading());
      try {
        final teachers = await _repository.getTeachers();
        emit(TeachersLoaded(teachers));
      } catch (e) {
        emit(TeacherFailure(e.toString()));
      }
    });

    on<AddTeacherEvent>((event, emit) async {
      add(const LoadTeachers());
    });
  }
}
