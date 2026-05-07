import 'package:core/services/supabase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'parent_event.dart';
import 'parent_state.dart';

class ParentBloc extends Bloc<ParentEvent, ParentState> {
  final ParentRepository _parentRepository;
  final SupabaseService _supabaseService;

  ParentBloc(this._parentRepository, this._supabaseService) : super(ParentInitial()) {
    on<LoadParents>(_onLoadParents);
    on<LinkChild>(_onLinkChild);
    on<DeleteParent>(_onDeleteParent);
  }

  Future<void> _onLoadParents(LoadParents event, Emitter<ParentState> emit) async {
    emit(ParentLoading());
    try {
      final orgId = _supabaseService.currentOrganizationId;
      if (orgId == null) throw Exception('No active organization');
      
      final parents = await _parentRepository.getParents(orgId);
      
      if (event.query != null && event.query!.isNotEmpty) {
        final filtered = parents.where((p) => 
          p.fullName.toLowerCase().contains(event.query!.toLowerCase()) || 
          p.email.toLowerCase().contains(event.query!.toLowerCase())
        ).toList();
        emit(ParentsLoaded(filtered, query: event.query));
      } else {
        emit(ParentsLoaded(parents));
      }
    } catch (e) {
      emit(ParentFailure(e.toString()));
    }
  }

  Future<void> _onLinkChild(LinkChild event, Emitter<ParentState> emit) async {
    try {
      await _parentRepository.linkChild(event.parentId, event.studentId);
      emit(const ParentSuccess('Child linked successfully'));
      add(const LoadParents());
    } catch (e) {
      emit(ParentFailure(e.toString()));
    }
  }

  Future<void> _onDeleteParent(DeleteParent event, Emitter<ParentState> emit) async {
    try {
      await _parentRepository.deleteParent(event.parentId);
      emit(const ParentSuccess('Parent deleted successfully'));
      add(const LoadParents());
    } catch (e) {
      emit(ParentFailure(e.toString()));
    }
  }
}
