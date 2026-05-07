import 'package:admin_app/di/injection.dart';
import 'package:core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bloc/finance_bloc.dart';
import 'bloc/finance_event.dart';
import 'bloc/finance_state.dart';

class FinanceDashboardView extends StatelessWidget {
  const FinanceDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FinanceBloc(getIt<FinanceRepository>(), getIt<SupabaseService>())..add(LoadFinanceStats()),
      child: SharedScaffold(
        appBar: AppBar(
          title: Text('Financial Management', style: AppTextStyles.h3),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: BlocBuilder<FinanceBloc, FinanceState>(
            builder: (context, state) {
              if (state is FinanceLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is FinanceLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRevenueOverview(state.totalRevenue),
                    SizedBox(height: 32.h),
                    _buildSectionHeader('Recent Invoices', () {}),
                    SizedBox(height: 16.h),
                    _buildInvoiceTable(state.invoices),
                    SizedBox(height: 32.h),
                    _buildSectionHeader('Active Coupons', () => _showAddCouponDialog(context)),
                    SizedBox(height: 16.h),
                    _buildCouponTable(state.coupons),
                  ],
                );
              }
              if (state is FinanceFailure) {
                return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueOverview(double totalRevenue) {
    return NeumorphicContainer(
      padding: EdgeInsets.all(32.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_balance_wallet_rounded, color: Colors.green, size: 48.sp),
          ),
          SizedBox(width: 24.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Revenue', style: AppTextStyles.label),
              Text('\$${totalRevenue.toStringAsFixed(2)}', style: AppTextStyles.h1.copyWith(color: Colors.green)),
            ],
          ),
          const Spacer(),
          Column(
            children: [
               Text('+12% from last month', style: TextStyle(color: Colors.green, fontSize: 14.sp)),
               // Placeholder for small sparkline chart
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h3),
        AppButton(
          text: 'Add New',
          isFullWidth: false,
          width: 120.w,
          height: 40.h,
          onPressed: onAdd,
        ),
      ],
    );
  }

  Widget _buildInvoiceTable(List<Invoice> invoices) {
    return NeumorphicContainer(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Student')),
            DataColumn(label: Text('Amount')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Action')),
          ],
          rows: invoices.map((invoice) {
            return DataRow(cells: [
              DataCell(Text(invoice.studentName ?? 'Unknown')),
              DataCell(Text('\$${invoice.totalAmount}')),
              DataCell(_buildStatusBadge(invoice.status)),
              DataCell(Text(invoice.createdAt?.toLocal().toString().split(' ')[0] ?? 'N/A')),
              DataCell(IconButton(icon: const Icon(Icons.download_rounded), onPressed: () {})),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCouponTable(List<Coupon> coupons) {
     return NeumorphicContainer(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Discount')),
            DataColumn(label: Text('Usage')),
            DataColumn(label: Text('Expiry')),
            DataColumn(label: Text('Action')),
          ],
          rows: coupons.map((coupon) {
            final discount = coupon.discountPercentage != null 
              ? '${coupon.discountPercentage}%' 
              : '\$${coupon.discountAmount}';
            return DataRow(cells: [
              DataCell(Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold))),
              DataCell(Text(discount)),
              DataCell(Text('${coupon.usedCount}/${coupon.usageLimit ?? '∞'}')),
              DataCell(Text(coupon.validUntil?.toString().split(' ')[0] ?? 'No Expiry')),
              DataCell(IconButton(icon: const Icon(Icons.delete_rounded, color: Colors.red), onPressed: () {})),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
     Color color = Colors.orange;
     if (status == 'paid') color = Colors.green;
     if (status == 'failed') color = Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showAddCouponDialog(BuildContext context) {
    // Dialog to add coupon
  }
}
