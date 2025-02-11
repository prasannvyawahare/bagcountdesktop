import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../SQLite/database_helper.dart';
import '../model/reading_count.dart';

class ReadingCountRepository  {

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  //final DatabaseHelper _databaseHelper  = Get.find<DatabaseHelper>();

  Future<int> getReadingCount() async {
    return 0;
  }


  Future<int> insertReadingCount(ReadingCount readingCount) async {
    final db = await _databaseHelper.database;
    return await db.insert('ReadingCount', readingCount.toJson());
  }



}