import 'dart:async';
import 'db/model/d_b_helper.dart';
import 'db/model/user.dart';

class Repository {
  final DbHelper _dbHelper = DbHelper();


  // Add user to the database
  Future<void> addUser(User user) async {
    await _dbHelper.insertUser(user);
  }

  // Validate login by checking username and password
  Future<bool> validateLogin(String username, String password) async {
    User? user = await _dbHelper.getUserByUsername(username);
    if (user != null && user.password == password) {
      return true;
    }
    return false; // Invalid username or password
  }

}
