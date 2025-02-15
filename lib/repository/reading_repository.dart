import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../SQLite/database_helper.dart';
import '../model/reading.dart';
import '../model/reading_with_count.dart';

class ReadingRepository extends GetxService  {
  //final DatabaseHelper _databaseHelper = DatabaseHelper();

  final DatabaseHelper _databaseHelper  = Get.find<DatabaseHelper>();
  // Create a new reading
  Future<int> insertReading(Reading reading) async {
    try {

      final db = await _databaseHelper.database;
      print("database $db");
      // Perform raw insert into the Reading table with all fields
      final id = await db.rawInsert(
        '''INSERT INTO Reading(
        timestamp, bay, truckNo, brand, mrp, ton,allottedBag
      ) VALUES(?, ?, ?, ?, ?, ?,?)''',
        [
          reading.timestamp,    // timestamp
          reading.bay,          // bay
          reading.truckNo,      // truckNo
          reading.brand,        // brand
          reading.mrp,          // mrp
          reading.ton,
          reading. allottedBag
        ],
      );
    print("id db ${reading.allottedBag}");
    print("id db $id");
      // Return the id of the inserted record
      return id;
    } catch (e) {
      // Handle any errors that occur during the insert
      print('Error inserting reading: $e');
      return -1; // Return a negative value to indicate an error
    }
  }




  // Get all readings
  Future<List<Reading>> getAllReadings() async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('Reading');
      print("Readings from DB: $maps");
      return maps.map((map) => Reading.fromJson(map)).toList();
    } catch (e) {
      print('Error inserting reading: $e');
      return [];
    }
  }



  Future<List<ReadingWithCount>> getCombinedReadings() async {
    try{
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        r.id, 
        r.timestamp, 
        r.bay, 
        r.truckNo, 
        r.brand, 
        r.mrp, 
        r.ton, 
        r.allottedBag, 
        rc.count, 
        rc.timestamp AS readingCountTimestamp 
      FROM Reading r
      INNER JOIN ReadingCount rc ON r.id = rc.readingId
      WHERE r.id IS NOT NULL AND rc.readingId IS NOT NULL
      ORDER BY r.timestamp;
    ''');
      print("Readings111 from DB: $result");
      return result.map((map) => ReadingWithCount.fromJson(map)).toList();
    }catch(e){
      print('Error inserting reading1: $e');
      return [];
    }

  }

  // Get a specific reading by ID
  Future<Reading?> getReadingById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Reading',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Reading.fromJson(maps.first);
    }
    return null;
  }

  // Update a reading
  Future<int> updateReading(Reading reading) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Reading',
      reading.toJson(),
      where: 'id = ?',
      whereArgs: [reading.id],
    );
  }

  // Delete a reading
  Future<int> deleteReading(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Reading',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllReadings() async {
    final db = await _databaseHelper.database;
    return await db.rawDelete('DELETE FROM Reading');
  }

  Future<void> printDatabasePath() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = '$databasesPath/my_database.db'; // Replace with your DB name

    print("Database Path: $dbPath");

    // Check if the database file exists
    File dbFile = File(dbPath);
    if (await dbFile.exists()) {
      print("Database file exists.");
    } else {
      print("Database file not found.");
    }
  }
  Future<void> deleteDatabaseFile() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = '$databasesPath/app_database.db'; // Replace with your DB name

    File dbFile = File(dbPath);
    if (await dbFile.exists()) {
      await dbFile.delete();
      print("Database deleted successfully.");
    } else {
      print("Database file not found.");
    }
  }

  Future<void> closeDb() async {
    await _databaseHelper.closeDatabase();
  }
}
