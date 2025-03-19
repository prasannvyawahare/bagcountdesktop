import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

import '../model/reading.dart';
import '../model/reading_with_count.dart';

Future<String> exportReadingsToExcel(List<Reading> readings) async {
  var excel = Excel.createExcel();
  Sheet sheet = excel['RCCPL Pvt. Ltd. Butibori (GU)'];
  int count = 1;

  // Add headers
  sheet.appendRow([
    TextCellValue('Sr.No.'),
    TextCellValue('Timestamp'),
    TextCellValue('StartTime'),
    TextCellValue('EmdTime'),
    TextCellValue('Bay'),
    TextCellValue('TruckNo'),
    TextCellValue('Brand'),
    TextCellValue('MRP'),
    TextCellValue('Ton'),
    TextCellValue('AllottedBag'),
    TextCellValue('Count'),
    TextCellValue('Extra Bags'),
  ]);

  // Add data rows
  for (var reading in readings) {
    sheet.appendRow([
      TextCellValue("${count++}"),
      TextCellValue(reading.timestamp.toString()),
      TextCellValue(reading.startTime.toString()),
      TextCellValue(reading.endTime.toString()),
      TextCellValue(reading.bay),
      TextCellValue(reading.truckNo),
      TextCellValue(reading.brand),
      TextCellValue(reading.mrp.toString()),
      TextCellValue(reading.ton.toString()),
      TextCellValue(reading.allottedBag),
      TextCellValue(int.parse(reading.currentCount) < 0 ? '0' : reading.currentCount.toString()),
      TextCellValue(int.parse(reading.currentCount) < 0 ? reading.currentCount.toString() : '0'),
    ]);
  }

  // Format current date and time for the filename
  String formattedDateTime = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

  // Get the Windows desktop directory
  String? userProfile = Platform.environment['USERPROFILE'];
  if (userProfile == null) {
    throw Exception('USERPROFILE environment variable not found.');
  }

  String desktopPath = path.join(userProfile, 'Desktop');

  // Ensure Desktop exists
  Directory desktopDir = Directory(desktopPath);
  if (!await desktopDir.exists()) {
   // throw Exception('Desktop directory not found at: $desktopPath');
  }

  // Create excel folder if it doesn't exist
  String excelFolderPath = path.join(desktopPath, 'RCCPL_Excel');
  Directory excelFolder = Directory(excelFolderPath);
  try {
    if (!await excelFolder.exists()) {
      await excelFolder.create(recursive: true); // recursive: true ensures parent dirs are created if needed
    }
  } catch (e) {
    throw Exception('Failed to create excel folder at $excelFolderPath: $e');
  }

  // Set the file path
  String filePath = path.join(excelFolderPath, 'Packer_Data_$formattedDateTime.xlsx');
  File file = File(filePath);

  // Ensure encode() does not return null
  List<int> bytes = await excel.encode() ?? [];

  // Write to file
  await file.writeAsBytes(bytes);

  print('Excel file saved at: $filePath');
  return filePath;
}