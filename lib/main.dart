import 'package:flutter/material.dart';

import 'master_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bag Count Reporting System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MasterScreen(),
    );
  }
}



