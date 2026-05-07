import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/repositories/finance_repository.dart';
import 'package:core/services/supabase_service.dart';
import 'finance_event.dart';
import 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final FinanceRepository _financeRepository;
  final SupabaseService _supabaseService;

  FinanceBloc(this._financeRepository, this._supabaseService) : super(FinanceInitial()) {
    on<LoadFinanceStats>(_onLoadFinanceStats);
    on<CreateCouponRequested>(_onCreateCoupon);
  }

  Future<void> _onLoadFinanceStats(LoadFinanceStats event, Emitter<FinanceState> emit) async {
    emit(FinanceLoading());
    try {
      final orgId = _supabaseService.currentOrganizationId;
      if (orgId == null) throw Exception('No active organization');

      final revenue = await _financeRepository.getTotalRevenue(orgId);
      final invoices = await _financeRepository.getInvoices(orgId);
      final coupons = await _financeRepository.getCoupons(orgId);

      emit(FinanceLoaded(
        totalRevenue: revenue,
        invoices: invoices,
        coupons: coupons,
      ));
    } catch (e) {
      emit(FinanceFailure(e.toString()));
    }
  }

  Future<void> _onCreateCoupon(CreateCouponRequested event, Emitter<FinanceState> emit) async {
    try {
      await _financeRepository.createCoupon(event.coupon);
      add(LoadFinanceStats());
    } catch (e) {
      emit(FinanceFailure(e.toString()));
    }
  }
}
