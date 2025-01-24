import 'dart:async';
import 'package:bagreportun/db/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbHelper {
  static Database? _database;
  final databaseName= 'bagreportun.db';
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDb();
      return _database!;
    }
  }
  final userTable='''CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          password TEXT
        )''';
  _initDb() async {
    final databasePath = await getApplicationDocumentsDirectory();
    final path = '${databasePath.path}/$databaseName';
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(userTable);
    });
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null; // No user found
  }
}
