import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/repositories/communication_repository.dart';
import 'package:core/services/supabase_service.dart';
import 'communication_event.dart';
import 'communication_state.dart';

class CommunicationBloc extends Bloc<CommunicationEvent, CommunicationState> {
  final CommunicationRepository _communicationRepository;
  final SupabaseService _supabaseService;

  CommunicationBloc(this._communicationRepository, this._supabaseService) : super(CommunicationInitial()) {
    on<SendAnnouncementRequested>(_onSendAnnouncement);
  }

  Future<void> _onSendAnnouncement(SendAnnouncementRequested event, Emitter<CommunicationState> emit) async {
    emit(CommunicationLoading());
    try {
      final orgId = _supabaseService.currentOrganizationId;
      if (orgId == null) throw Exception('No active organization');

      await _communicationRepository.sendAnnouncement(
        organizationId: orgId,
        title: event.title,
        message: event.message,
        role: event.targetRole,
      );

      emit(const CommunicationSuccess('Announcement sent successfully to all target users.'));
    } catch (e) {
      emit(CommunicationFailure(e.toString()));
    }
  }
}
