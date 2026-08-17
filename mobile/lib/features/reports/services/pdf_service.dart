import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../groups/models/group.dart';
import '../../settlements/models/settlement.dart';

class PdfService {
  const PdfService._();

  static Future<void> generateReport({
    required Group group,
    required List<Settlement> settlements,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [

            pw.Header(
              level: 0,
              child: pw.Text(
                "Splitly Expense Report",
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 15),

            pw.Text(
              "Group: ${group.name}",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 18,
              ),
            ),

            if (group.description.isNotEmpty)
              pw.Text(group.description),

            pw.SizedBox(height: 20),

            pw.Text(
              "Members",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 18,
              ),
            ),

            pw.Bullet(
              text: group.members
                  .map((e) => e.name)
                  .join("\n"),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              "Expenses",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 18,
              ),
            ),

            pw.Table.fromTextArray(
              headers: const [
                "Title",
                "Paid By",
                "Amount"
              ],
              data: group.expenses.map((expense) {
                return [
                  expense.title,
                  expense.paidBy,
                  "₱${expense.amount.toStringAsFixed(2)}",
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              "Suggested Settlements",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 18,
              ),
            ),

            pw.Table.fromTextArray(
              headers: const [
                "From",
                "To",
                "Amount",
              ],
              data: settlements.map((s) {
                return [
                  s.from,
                  s.to,
                  "₱${s.amount.toStringAsFixed(2)}",
                ];
              }).toList(),
            ),

            pw.SizedBox(height: 30),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated: ${DateTime.now()}",
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}