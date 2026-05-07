import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String organizationId,
    required String studentId,
    required double amount,
    @Default(0) double taxAmount,
    required double totalAmount,
    required String status,
    DateTime? dueDate,
    DateTime? paidAt,
    String? pdfUrl,
    DateTime? createdAt,
    String? studentName, // Joined field
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
}
