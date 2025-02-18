import 'package:bagreportun/login_screen.dart';
import 'package:bagreportun/repository/reading_count_repository.dart';
import 'package:bagreportun/repository/reading_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'SQLite/database_helper.dart';
import 'controller/serial_port_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  Get.lazyPut(() => DatabaseHelper());
  Get.lazyPut(() => SerialPortService(), fenix: true);
  Get.lazyPut(() => ReadingRepository(), fenix: true);
  Get.lazyPut(() => ReadingCountRepository(), fenix: true);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bag Count Reporting System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: LoginScreen(),
    );
  }
}



