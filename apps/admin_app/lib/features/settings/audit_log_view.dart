import 'package:admin_app/di/injection.dart';
import 'package:core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuditLogView extends StatefulWidget {
  const AuditLogView({super.key});

  @override
  State<AuditLogView> createState() => _AuditLogViewState();
}

class _AuditLogViewState extends State<AuditLogView> {
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    try {
      final orgId = getIt<SupabaseService>().currentOrganizationId;
      if (orgId != null) {
        final logs = await getIt<AdminRepository>().getAuditLogs(orgId);
        setState(() {
          _logs = logs;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBar: AppBar(
        title: Text('Security Audit Logs', style: AppTextStyles.h3),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.all(24.w),
            child: NeumorphicContainer(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Action')),
                    DataColumn(label: Text('Entity')),
                    DataColumn(label: Text('Time')),
                    DataColumn(label: Text('IP Address')),
                  ],
                  rows: _logs.map((log) {
                    return DataRow(cells: [
                      DataCell(Text(log['user_profiles']?['full_name'] ?? 'System')),
                      DataCell(_buildActionBadge(log['action'])),
                      DataCell(Text(log['entity_type'])),
                      DataCell(Text(log['created_at']?.toString().split('.')[0] ?? 'N/A')),
                      DataCell(Text(log['ip_address']?.toString() ?? 'N/A')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildActionBadge(String action) {
    Color color = Colors.blue;
    if (action.contains('delete')) color = Colors.red;
    if (action.contains('create') || action.contains('add')) color = Colors.green;
    if (action.contains('update')) color = Colors.orange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        action.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
