import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'batch_event.dart';
import 'batch_state.dart';

class BatchBloc extends Bloc<BatchEvent, BatchState> {
  final AdminRepository _repository;

  BatchBloc(this._repository) : super(BatchInitial()) {
    on<LoadBatches>((event, emit) async {
      emit(BatchLoading());
      try {
        final batches = await _repository.getBatches();
        emit(BatchesLoaded(batches));
      } catch (e) {
        emit(BatchFailure(e.toString()));
      }
    });
  }
}
