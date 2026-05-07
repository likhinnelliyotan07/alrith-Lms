import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'live_class_event.dart';
import 'live_class_state.dart';

class LiveClassBloc extends Bloc<LiveClassEvent, LiveClassState> {
  final AdminRepository _repository;

  LiveClassBloc(this._repository) : super(LiveClassInitial()) {
    on<LoadLiveClasses>((event, emit) async {
      emit(LiveClassLoading());
      try {
        // Mocking live classes for now
        await Future.delayed(const Duration(seconds: 1));
        emit(const LiveClassesLoaded([
          {
            'title': 'Advanced Physics - Batch A',
            'instructor': 'Dr. John Doe',
            'status': 'ongoing',
            'studentsCount': 45,
            'startTime': '10 mins ago',
          },
          {
            'title': 'Mathematics 101 - Batch B',
            'instructor': 'Prof. Sarah Smith',
            'status': 'scheduled',
            'studentsCount': 0,
            'startTime': 'In 2 hours',
          }
        ]));
      } catch (e) {
        emit(LiveClassFailure(e.toString()));
      }
    });
  }
}
