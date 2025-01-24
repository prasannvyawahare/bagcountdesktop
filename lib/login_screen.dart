import 'package:flutter/material.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';

  _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    print(username);
    print(password);
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
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

