import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../model/reading_with_count.dart';

Future<String> exportReadingsToPdf(List<ReadingWithCount> readings) async {
  final pdf = pw.Document();

  // Add Title
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Readings Report',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: [
                'ID',
                'Timestamp',
                'Bay',
                'TruckNo',
                'Brand',
                'MRP',
                'Ton',
                'AllottedBag',
                'Count',
                'ReadingCountTimestamp'
              ],
              data: readings.map((reading) {
                return [
                  reading.id ?? 0,
                  reading.timestamp?.toString() ?? '',
                  reading.bay ?? '',
                  reading.truckNo ?? '',
                  reading.brand ?? '',
                  reading.mrp?.toString() ?? '0.0',
                  reading.ton?.toString() ?? '0.0',
                  reading.allottedBag?.toString() ?? '0',
                  reading.count?.toString() ?? '0',
                  reading.readingCountTimestamp?.toString() ?? '',
                ];
              }).toList(),
              border: pw.TableBorder.all(),
              cellAlignment: pw.Alignment.center,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(fontSize: 10),
            ),
          ],
        );
      },
    ),
  );

  // Format current date and time for filename
  String formattedDateTime = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

  // Get directory path
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/readings_export_$formattedDateTime.pdf';
  File file = File(filePath);

  // Write PDF to file
  await file.writeAsBytes(await pdf.save());

  print('PDF file saved at: $filePath');
  // Open the PDF file
  return filePath;




}
