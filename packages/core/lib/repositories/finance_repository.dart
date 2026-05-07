import 'package:injectable/injectable.dart';
import '../services/supabase_service.dart';
import '../models/invoice.dart';
import '../models/coupon.dart';

@lazySingleton
class FinanceRepository {
  final SupabaseService _supabase;

  FinanceRepository(this._supabase);

  Future<double> getTotalRevenue(String organizationId) async {
    try {
      final response = await _supabase.client
          .from('payments')
          .select('amount, invoices!inner(organization_id)')
          .eq('invoices.organization_id', organizationId)
          .eq('status', 'success');

      final List data = response as List;
      double total = 0.0;
      for (final item in data) {
        total += (item['amount'] as num).toDouble();
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  Future<List<Invoice>> getInvoices(String organizationId) async {
    final response = await _supabase.client
        .from('invoices')
        .select('*, user_profiles(full_name)')
        .eq('organization_id', organizationId);
    
    return (response as List).map((json) {
      final data = Map<String, dynamic>.from(json);
      data['studentName'] = json['user_profiles']['full_name'];
      return Invoice.fromJson(data);
    }).toList();
  }

  Future<List<Coupon>> getCoupons(String organizationId) async {
    final response = await _supabase.client
        .from('coupons')
        .select()
        .eq('organization_id', organizationId);
    
    return (response as List).map((json) => Coupon.fromJson(json)).toList();
  }

  Future<void> createCoupon(Coupon coupon) async {
    await _supabase.client.from('coupons').insert(coupon.toJson());
  }

  Future<void> generateInvoice(String studentId, double amount) async {
    // Generate PDF logic will be added in Phase 2.2
  }
}
