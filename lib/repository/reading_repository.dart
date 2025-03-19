import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../SQLite/database_helper.dart';
import '../model/reading.dart';
import '../model/reading_with_count.dart';

class ReadingRepository extends GetxService  {
  //final DatabaseHelper _databaseHelper = DatabaseHelper();

  final DatabaseHelper _databaseHelper  = Get.find<DatabaseHelper>();

  Future<int> insertReading(Reading reading) async {
    try {

      final db = await _databaseHelper.database;
      print("database $db");
      // Perform raw insert into the Reading table with all fields
      final id = await db.rawInsert(
        '''INSERT INTO Reading(
        timestamp,startTime,endTime, bay, truckNo, brand, mrp, ton,allottedBag,currentCount
      ) VALUES(?, ?, ?, ?, ?, ?,?,?,?,?)''',
        [
          reading.timestamp,
          reading.startTime,
          reading.endTime,      // timestamp
          reading.bay,          // bay
          reading.truckNo,      // truckNo
          reading.brand,        // brand
          reading.mrp,          // mrp
          reading.ton,
          reading.allottedBag,
          reading.currentCount
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

  Future<int> updateCurrentCount({required int id, required String newCount, required String endTime}) async {
    try {
      final db = await _databaseHelper.database;

      // Perform the update query
      final rowsAffected = await db.rawUpdate(
        '''UPDATE Reading 
         SET currentCount = ?, endTime = ?
         WHERE id = ?''',
        [newCount, endTime, id], // Ensure values match placeholders
      );

      print("Updated rows: $rowsAffected");
      return rowsAffected; // Returns the number of updated rows
    } catch (e) {
      print('Error updating currentCount and endTime: $e');
      return -1; // Indicate an error
    }
  }

  Future<List<Reading>> getReadings() async {
    try {
      final db = await _databaseHelper.database;

      // Fetch all records from the Reading table
      final List<Map<String, dynamic>> maps = await db.query('Reading');

      // Convert the list of maps into a list of Reading objects
      return List.generate(maps.length, (i) {
        return Reading(
          id: maps[i]['id'],
          timestamp: maps[i]['timestamp'],
          startTime: maps[i]['startTime'],
          endTime: maps[i]['endTime'],
          bay: maps[i]['bay'],
          truckNo: maps[i]['truckNo'],
          brand: maps[i]['brand'],
          mrp: maps[i]['mrp'],
          ton: maps[i]['ton'],
          allottedBag: maps[i]['allottedBag'],
          currentCount: maps[i]['currentCount'],
        );
      });
    } catch (e) {
      print('Error fetching readings: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<int> getTotalCurrentCountForDate(String date) async {
    try {
      final db = await _databaseHelper.database;
      // Query to sum currentCount for a specific date
      final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(currentCount) as totalCount 
      FROM Reading 
      WHERE DATE(timestamp) = ?
    ''', [date]);

      return result.first['totalCount'] as int? ?? 0; // Return sum or 0 if null
    } catch (e) {
      print('Error fetching total currentCount for $date: $e');
      return 0; // Return 0 in case of an error
    }
  }

   Future<double> getTotalWeightForDate(String date) async {
   try {
     final db = await _databaseHelper.database;

     // Query to sum 'ton' values for a specific date
     final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(ton) as totalTon 
      FROM Reading 
      WHERE DATE(timestamp) = ?
    ''', [date]);

     return result.first['totalTon'] as double? ?? 0.0; // Return sum or 0.0 if null
   } catch (e) {
     print('Error fetching total ton for $date: $e');
     return 0.0; // Return 0.0 in case of an error
   }
  }

  Future<int> getNegativeCurrentCountForDate(String date) async {
    try {
      final db = await _databaseHelper.database;

      // Query to sum only negative currentCount values for a specific date
      final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(currentCount) as totalNegativeCount 
      FROM Reading 
      WHERE DATE(timestamp) = ? AND currentCount < 0
    ''', [date]);

      return result.first['totalNegativeCount'] as int? ?? 0; // Return sum or 0 if null
    } catch (e) {
      print('Error fetching negative currentCount for $date: $e');
      return 0; // Return 0 in case of an error
    }
  }

  Future<List<Reading>> getFilteredReadings({
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? brand,
    String? bay,
  })
  async {
    try {
      final db = await _databaseHelper.database;

      // Base query
      String query = "SELECT * FROM Reading WHERE 1=1";
      List<dynamic> args = [];

      // Apply date filter (YYYY-MM-DD)
      if (startDate != null) {
        query += " AND DATE(timestamp) >= ?";
        args.add("${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}");
      }
      if (endDate != null) {
        query += " AND DATE(timestamp) <= ?";
        args.add("${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}");
      }

      // Apply time filter (HH:MM)
      if (startTime != null) {
        query += " AND TIME(startTime) >= ?";
        args.add("${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}");
      }
      if (endTime != null) {
        query += " AND TIME(endTime) <= ?";
        args.add("${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}");
      }

      // Apply brand filter
      if (brand != null && brand.isNotEmpty) {
        query += " AND brand = ?";
        args.add(brand);
      }

      // Apply bay filter
      if (bay != null && bay.isNotEmpty) {
        query += " AND bay = ?";
        args.add(bay);
      }

      // Execute query
      final List<Map<String, dynamic>> result = await db.rawQuery(query, args);

      // Convert result to list of Reading objects
      print("Readings from DB: $result");
      return result.map((map) => Reading.fromJson(map)).toList();
    } catch (e) {
      print('Error fetching filtered readings: $e');
      return [];
    }
  }


  Future<List<Reading>> searchReading(String searchTerm) async {
    try {
      final db = await _databaseHelper.database;

      // Define the columns to search in
      List<String> columns = [
        'timestamp',
        'startTime',
        'endTime',
        'bay',
        'truckNo',
        'brand',
        'mrp',
        'ton',
        'allottedBag',
        'currentCount'
      ];

      // Build a WHERE clause that searches in all columns
      String query = 'SELECT * FROM Reading WHERE ';
      List<String> conditions = [];
      List<dynamic> args = [];

      for (String column in columns) {
        conditions.add('$column LIKE ?');
        args.add('%$searchTerm%'); // Searching with LIKE for partial matches
      }

      query += conditions.join(' OR ');

      final List<Map<String, dynamic>> result = await db.rawQuery(query, args);

      // Convert the result into a List of Reading objects
      return result.map((data) => Reading.fromJson(data)).toList();
    } catch (e) {
      print('Error searching readings: $e');
      return [];
    }
  }

  Future<List<Reading>> getTodayReadings(String day) async {
    try {
      final db = await _databaseHelper.database;

      // Query to get readings from the current day
      final List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT * FROM Reading WHERE DATE(timestamp) = ?',
          [day]
      );

      // Convert the result into a List of Reading objects
      return result.map((data) => Reading.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching today\'s readings: $e');
      return [];
    }
  }

  Future<int> getTotalDifferentBrandCountByDate(String date) async {
    try {
      final db = await _databaseHelper.database;

      // Query to count distinct brands for the given date
      final List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT COUNT(DISTINCT brand) as totalBrands FROM Reading WHERE DATE(timestamp) = ?',
          [date]
      );

      return result.isNotEmpty ? result.first['totalBrands'] as int : 0;
    } catch (e) {
      print('Error fetching total different brand count for date $date: $e');
      return 0;
    }
  }

  Future<int> getTotalDifferentTruckCountByDate(String date) async {
    try {
      final db = await _databaseHelper.database;

      // Query to count distinct truck numbers for a given date
      final List<Map<String, dynamic>> result = await db.rawQuery(
          'SELECT COUNT(DISTINCT truckNo) as totalTrucks FROM Reading WHERE DATE(timestamp) = ?',
          [date]
      );

      return result.isNotEmpty ? result.first['totalTrucks'] as int : 0;
    } catch (e) {
      print('Error fetching total different truck count for date $date: $e');
      return 0;
    }
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

  Future<int> doesTodayReadingExist(String todayDate) async {
    try {
      final db = await _databaseHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery(
          '''
      SELECT 1 FROM Reading 
      WHERE timestamp LIKE ?
      LIMIT 1
      ''',
          ['$todayDate%'] // Match records starting with today's date
      );
    print(result.first.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', '));
      return result.isNotEmpty ? 1 : 0;
    } catch (e) {
      print('Error checking if today\'s reading exists: $e');
      return 0;
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
