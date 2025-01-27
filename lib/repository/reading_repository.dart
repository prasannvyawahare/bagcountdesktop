import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../SQLite/database_helper.dart';
import '../model/reading.dart';

class ReadingRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create a new reading
  Future<int> insertReading(Reading reading) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'Reading',
      reading.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all readings
  Future<List<Reading>> getAllReadings() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Reading');

    return List.generate(maps.length, (i) {
      return Reading.fromMap(maps[i]);
    });
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
      return Reading.fromMap(maps.first);
    }
    return null;
  }

  // Update a reading
  Future<int> updateReading(Reading reading) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Reading',
      reading.toMap(),
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
}
