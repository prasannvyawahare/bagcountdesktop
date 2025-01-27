import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../SQLite/database_helper.dart';
import '../model/user.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Create a new user
  Future<int> insertUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.insert(
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('User');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Get a specific user by username
  Future<User?> getUserByUsername(String username) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Update a user
  Future<int> updateUser(User user) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'User',
      user.toMap(),
      where: 'username = ?',
      whereArgs: [user.username],
    );
  }

  // Delete a user
  Future<int> deleteUser(String username) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'User',
      where: 'username = ?',
      whereArgs: [username],
    );
  }
}
