import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;
  static final _lock = Object(); // Prevent race conditions

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Ensure only one instance initializes the database
    return await _initDatabase();
  }



  Future<Database> _initDatabase() async {
    sqfliteFfiInit();
    final dbFactory = databaseFactoryFfi;
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'app_database.db');

    // Synchronize initialization to avoid multiple instances
    return _database ??= await dbFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 1,
          singleInstance: true, // Ensures only one instance
          onCreate: (db, version) async {
            await db.execute('''
            CREATE TABLE Port (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              port_name TEXT NOT NULL,
              baud_rate INTEGER NOT NULL,
              data_bits INTEGER NOT NULL,
              parity TEXT NOT NULL,
              stop_bits INTEGER NOT NULL,
              is_connect INTEGER NOT NULL DEFAULT 0
            );
          ''');

            await db.execute('''
            CREATE TABLE Shift (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              shift_name TEXT NOT NULL,
              start_time TEXT NOT NULL,
              end_time TEXT NOT NULL,
              is_active INTEGER NOT NULL DEFAULT 1
            );
          ''');

            await db.execute('''
            CREATE TABLE Reading (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              timestamp TEXT,
              bay TEXT,
              truckNo TEXT,
              brand TEXT,
              mrp REAL,
              ton REAL
            );
          ''');

            await db.execute('''
            CREATE TABLE ReadingCount (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              readingId INTEGER NOT NULL,
              count INTEGER NOT NULL,
              timestamp TEXT NOT NULL,
              FOREIGN KEY (readingId) REFERENCES Reading(id) ON DELETE CASCADE
            )
          ''');

            await db.execute('''
            CREATE TABLE User (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT NOT NULL,
              password TEXT NOT NULL
            );
          ''');

            await db.execute('''
            CREATE TABLE Product (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT NOT NULL,
              brand TEXT NOT NULL,
              value REAL NOT NULL
            );
          ''');
          },
        ));
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
