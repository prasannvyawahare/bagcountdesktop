import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../model/reading_with_count.dart';

Future<void> exportReadingsToExcel(List<ReadingWithCount> readings) async {
  var excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  // Add headers
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Timestamp'),
    TextCellValue('Bay'),
    TextCellValue('TruckNo'),
    TextCellValue('Brand'),
    TextCellValue('MRP'),
    TextCellValue('Ton'),
    TextCellValue('AllottedBag'),
    TextCellValue('Count'),
    TextCellValue('ReadingCountTimestamp'),
  ]);

  // Add data rows
  for (var reading in readings) {
    sheet.appendRow([
      IntCellValue(reading.id),  // ID is an integer
      TextCellValue(reading.timestamp.toString()), // Convert to String
      TextCellValue(reading.bay),
      TextCellValue(reading.truckNo),
      TextCellValue(reading.brand),
      TextCellValue(reading.mrp), // MRP is a double
      TextCellValue(reading.ton), // Ton is a double
      TextCellValue(reading.allottedBag), // Convert if necessary
      TextCellValue(reading.count), // Convert if necessary
      TextCellValue(reading.readingCountTimestamp.toString()), // Convert to String
    ]);
  }

  // Format current date and time for the filename
  String formattedDateTime = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

  // Get the directory path
  var directory = await getApplicationDocumentsDirectory();
  String filePath = '${directory.path}/readings_export_$formattedDateTime.xlsx';
  File file = File(filePath);

  // Ensure encode() does not return null
  List<int> bytes = await excel.encode() ?? [];

  // Write to file
  await file.writeAsBytes(bytes);

  print('Excel file saved at: $filePath');
}
