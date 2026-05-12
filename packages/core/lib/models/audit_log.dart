import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
abstract class AuditLog with _$AuditLog {
  factory AuditLog({
    required String id,
    String? organizationId,
    String? userId,
    required String action,
    required String entityType,
    String? entityId,
    Map<String, dynamic>? details,
    String? ipAddress,
    DateTime? createdAt,
    String? userName, // Joined field
  }) = _$AuditLogImpl;

  factory AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);
}
