import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/invoice.dart';

@lazySingleton
class InvoiceService {
  Future<File> generateInvoicePdf(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Arlith LMS - Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Invoice ID: ${invoice.id}'),
              pw.Text('Date: ${DateTime.now().toString().split(' ')[0]}'),
              pw.SizedBox(height: 40),
              pw.Text('Student: ${invoice.studentName ?? 'N/A'}'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Description'),
                  pw.Text('Amount'),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Course Fee'),
                  pw.Text('\$${invoice.amount.toStringAsFixed(2)}'),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Tax'),
                  pw.Text('\$${invoice.taxAmount.toStringAsFixed(2)}'),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('\$${invoice.totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 100),
              pw.Center(child: pw.Text('Thank you for choosing Arlith LMS!')),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/invoice_${invoice.id}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
