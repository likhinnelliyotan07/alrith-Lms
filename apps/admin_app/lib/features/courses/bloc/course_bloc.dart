import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final AdminRepository _repository;

  CourseBloc(this._repository) : super(CourseInitial()) {
    on<LoadCourses>((event, emit) async {
      emit(CourseLoading());
      try {
        final courses = await _repository.getCourses('arlith-default');
        emit(CoursesLoaded(courses));
      } catch (e) {
        emit(CourseFailure(e.toString()));
      }
    });

    on<AddCourse>((event, emit) async {
      try {
        await _repository.createCourse(event.course);
        add(LoadCourses());
      } catch (e) {
        emit(CourseFailure(e.toString()));
      }
    });
  }
}
