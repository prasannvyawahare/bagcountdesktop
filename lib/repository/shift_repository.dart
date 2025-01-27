import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../SQLite/database_helper.dart';
import '../model/shift.dart';

class ShiftRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create a new shift
  Future<int> insertShift(Shift shift) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'Shift',
      shift.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all shifts
  Future<List<Shift>> getAllShifts() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Shift');

    return List.generate(maps.length, (i) {
      return Shift.fromMap(maps[i]);
    });
  }

  // Get a shift by ID
  Future<Shift?> getShiftById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Shift',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Shift.fromMap(maps.first);
    }
    return null;
  }

  // Update a shift
  Future<int> updateShift(Shift shift) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Shift',
      shift.toMap(),
      where: 'id = ?',
      whereArgs: [shift.id],
    );
  }

  // Delete a shift
  Future<int> deleteShift(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Shift',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
