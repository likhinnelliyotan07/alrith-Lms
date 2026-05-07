import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'course_detail_event.dart';
import 'course_detail_state.dart';

class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final AdminRepository _repository;

  CourseDetailBloc(this._repository) : super(CourseDetailInitial()) {
    on<LoadCourseDetail>((event, emit) async {
      emit(CourseDetailLoading());
      try {
        final course = await _repository.getCourseById(event.courseId);
        emit(CourseDetailLoaded(course));
      } catch (e) {
        emit(CourseDetailFailure(e.toString()));
      }
    });
  }
}
