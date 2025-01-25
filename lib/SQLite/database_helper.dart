
import 'package:bagreportun/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper{
  final databaseName = "bagcount.db";

  //It must be same as your column in table with json model
  String accountTbl = '''
  CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL,
  password TEXT NOT NULL,

  )''';

  //Database connection
  Future<Database> init()async{
    final databasePath = await getApplicationDocumentsDirectory();
    final path = "${databasePath.path}/$databaseName";
    return openDatabase(path,version: 1,onCreate: (db,version)async{

      //Tables
      await db.execute(accountTbl);

    });
  }

  //CRUD Methods

  //Get
  Future<List<User>> getAccounts()async{
    final Database db = await init();
    List<Map<String,Object?>> result = await db.query("accounts",where: "accStatus = 1");
    return result.map((e) => User.fromMap(e)).toList();
  }


  //Insert
  Future<int> insertUser(User user)async{
    final Database db = await init();
    return db.insert("user", user.toMap());
  }

  //Update
  Future<int> updateUser(String username, String password, int id )async{
    final Database db = await init();
    return db.rawUpdate("update user set username = ?, password = ? where id = ?",[username, password, id]);
  }

  //Delete
  Future<int> deleteAccount(int id)async{
    final Database db = await init();
    return db.delete("accounts",where: "accId = ?",whereArgs: [id]);
  }

  // Future<List<User>> filter(String keyword)async{
  //   final Database db = await init();
  //   List<Map<String,Object?>> result = await db.rawQuery("select * from accounts where accHolder LIKE ? OR accName LIKE ?",["%$keyword%","%$keyword%"]);
  //   return result.map((e) => AccountsJson.fromMap(e)).toList();
  // }


Future<User?> getUserByUsername(String username) async {
  final db = await  init();
  List<Map<String, dynamic>> maps = await db.query(
    'user',
    where: 'username = ?',
    whereArgs: [username],
  );

  if (maps.isNotEmpty) {
    return User.fromMap(maps.first);
  } else {
    return null;
  }
}

Future<User?> getUserById(int id) async {
  final Database db = await init();
  List<Map<String, dynamic>> result = await db.query(
    "user",
    where: "id = ?",
    whereArgs: [id],
  );

  if (result.isNotEmpty) {
    return User.fromMap(result.first);
  } else {
    return null;
  }
}

Future<bool> checkUserCredentials(String username, String password) async {
  final Database db = await init();
  List<Map<String, dynamic>> result = await db.query(
    "user",
    where: "username = ? AND password = ?",
    whereArgs: [username, password],
  );

  return result.isNotEmpty;
}

// ...existing code...
 }