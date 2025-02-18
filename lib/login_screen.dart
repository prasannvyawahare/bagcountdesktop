import 'package:bagreportun/SQLite/database_helper.dart';
import 'package:bagreportun/master_screen.dart';
//import 'package:bagreportun/model/user.dart';
import 'package:flutter/material.dart';

import 'mainscreen/main_screen.dart';
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
        MaterialPageRoute(builder: (context) =>  MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left side - Branding Image (2:3 ratio)
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,

              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SizedBox(width: 300,height: 700,
                  child:ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('images/hd_image.png',    fit: BoxFit.cover,)),),
              ),
            ),
          ),
          // Right side - Login Content (3:3 ratio)
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 80,),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bag Count Reporting System',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue
                      ),
                    ),
                  SizedBox(height: 20,),
                  Text(
                      'WelcomeBack',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                          color:  Colors.black38
                      ),
                    ),
                  Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color:  Colors.black38
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 250,
                      color: Colors.white60,
                      child: TextField(
                        autofocus: true,
                        enableInteractiveSelection: false,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          errorText: _errorMessage.isEmpty ? null : _errorMessage,
                        //  filled: true,
                         // fillColor:  Colors.white60, // Visual cue
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                         //   borderSide: BorderSide.,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 250,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible, // Toggle password visibility
                        decoration: InputDecoration(
                         border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                        //   borderSide: BorderSide.,
                      ),
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
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      ),
                      child: Text("Submit", style: TextStyle(color: Colors.white)),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     // Add your forget password action here
                    //   },
                    //   child: Text('Forgot Username/Password?'),
                    // ),
                    SizedBox(height: 50,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          'Powered by' ,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey,
                          ),
                        ),
                        Text(
                          'Microtron Systems',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTextField(String label, TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label :",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 180,
          child: TextField(
            controller: controller,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200], // Visual cue
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
