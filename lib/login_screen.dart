import 'package:bagreportun/SQLite/database_helper.dart';
import 'package:bagreportun/master_screen.dart';
//import 'package:bagreportun/model/user.dart';
import 'package:flutter/material.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
//  late DatabaseHelper handler;
  final String _errorMessage = '';
  bool _isPasswordVisible = false;
 // final db = DatabaseHelper();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
   // sqfliteFfiInit();
    //databaseFactory = databaseFactoryFfi;
   // handler = db;
    super.initState();
  }

  _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    if (username == "admin" && password == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MasterScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Row(
        children: [
          // Left side - Branding Image (2:3 ratio)
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,

              ),
            ),
          ),
          // Right side - Login Content (3:3 ratio)
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 100,vertical: 100),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                                errorText: _errorMessage.isEmpty ? null : _errorMessage,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 300,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible, // Toggle password visibility
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible; // Toggle the visibility
                                    });
                                  },
                                ),
                              ),
                            )
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              _login();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                            ),
                            child: Text("Submit", style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add your forget password action here
                            },
                            child: Text('Forgot Username/Password?'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
