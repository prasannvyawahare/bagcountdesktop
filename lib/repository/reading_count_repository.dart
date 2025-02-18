import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../SQLite/database_helper.dart';
import '../model/reading_count.dart';

class ReadingCountRepository extends GetxService {

 // final DatabaseHelper _databaseHelper = DatabaseHelper();

  final DatabaseHelper _databaseHelper  = Get.find<DatabaseHelper>();

  Future<int> getReadingCount() async {
    return 0;
  }


  Future<int> insertReadingCount(ReadingCount readingCount) async {
    final db = await _databaseHelper.database;
    return await db.insert('ReadingCount', readingCount.toJson());
  }

  Future<List<Map<String, dynamic>>> getNegativeValues() async {
    final db = await _databaseHelper.database;
    return await db.query('ReadingCount', where: 'count < 0');
  }

  Future<int> printNegativeValues() async {
    List<Map<String, dynamic>> negativeValues = await getNegativeValues();
    print("negative value ${negativeValues.length}");
    for (var row in negativeValues) {

      print(row);
    }
  return negativeValues.length;

  }



}