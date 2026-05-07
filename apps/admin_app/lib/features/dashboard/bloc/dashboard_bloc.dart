import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AdminRepository _adminRepository;

  DashboardBloc(this._adminRepository) : super(DashboardInitial()) {
    on<LoadDashboardStats>((event, emit) async {
      emit(DashboardLoading());
      try {
        final stats = await _adminRepository.getDashboardStats('arlith-default');
        emit(DashboardLoaded(stats));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
