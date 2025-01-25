import 'package:bagreportun/SQLite/database_helper.dart';
import 'package:bagreportun/master_screen.dart';
import 'package:bagreportun/model/user.dart';
import 'package:flutter/material.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late DatabaseHelper handler;
  final String _errorMessage = '';
  final db = DatabaseHelper();

 @override
  void initState() {
    handler = db;
    super.initState();
  }

  _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    print("object");
  //  print(username);
   // print(password);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => MasterScreen()));

    try {
      if(await handler.checkUserCredentials(username, password)){
        print("User already exists");
         Navigator.push(context,  MaterialPageRoute( 
                            builder: (context) => 
                                MasterScreen()));
      }else{
        print("User does not exist");
          var user = User(username: username, password: password);
          //handler.insertUser(user);
          Navigator.push(context,  MaterialPageRoute( 
                            builder: (context) => 
                                MasterScreen()));
      }
    
    } catch (e) {
      //print(e);
      print("error");
    }
  
   // bool isValid = await _userRepository.validateLogin(username, password);
    // if (isValid) {
    //   // Proceed to the next screen or show success
    //   //Navigator.pushReplacementNamed(context, '/home');
    //   print("doneeeeeeeeeeeeeeee");

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Login successful")),
    //   );
    // } else {
    // //  _userRepository.addUser(User(username: username, password: password));
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("User Added")),
    //   );
    //   setState(() {
    //     _errorMessage = 'Invalid username or password';
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: _errorMessage.isEmpty ? null : _errorMessage,
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
           ElevatedButton(
                        onPressed: () {
                       //   print("object");
                       _login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: Text("Submit", style: TextStyle(color: Colors.white)),
                      ),
          ],
        ),
      ),
    );
  }
}

