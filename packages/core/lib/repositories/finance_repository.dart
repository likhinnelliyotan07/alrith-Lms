import 'package:injectable/injectable.dart';
import '../services/supabase_service.dart';

@lazySingleton
class FinanceRepository {
  final SupabaseService _supabase;

  FinanceRepository(this._supabase);

  Future<double> getTotalRevenue(String organizationId) async {
    try {
      final response = await _supabase.client
          .from('payments')
          .select('amount')
          .eq('organization_id', organizationId)
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

  Future<void> generateInvoice(String studentId, double amount) async {
    // Generate PDF and upload to Supabase storage
  }
}
