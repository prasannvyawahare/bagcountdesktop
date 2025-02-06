import 'package:bagreportun/product_screen.dart';
import 'package:bagreportun/profile_screen.dart';
import 'package:bagreportun/shift_setting_screen.dart';
import 'package:bagreportun/vew_report_screen.dart';
import 'package:flutter/material.dart';

import 'com_setting.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // sqfliteFfiInit();
    // databaseFactory = databaseFactoryFfi;
  }
  final List<Widget> _screens = [
    ComSetting(),
    ShiftSettingScreen(),
    ProductScreen(),
    VewReportScreen (),
    ProfileScreen (userId: '1', softwareVersion: '3',),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side Navigation Bar
          Container(
            width: 200,
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LOGO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  selected: _selectedIndex == 0,
                  leading: Icon(Icons.confirmation_num_outlined, color: _selectedIndex == 0 ? Colors.blue : Colors.black),
                  title: Text('Port',style: TextStyle( color: _selectedIndex == 0 ? Colors.blue : Colors.black)),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                ListTile(
                  selected: _selectedIndex == 1,
                  leading:Icon(Icons.filter_tilt_shift, color: _selectedIndex == 1 ? Colors.blue : Colors.black),
                  title: Text('Shift',style: TextStyle( color: _selectedIndex == 1 ? Colors.blue : Colors.black)),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                ListTile(
                  selected: _selectedIndex == 2,
                  leading: Icon(Icons.computer, color: _selectedIndex == 2 ? Colors.blue : Colors.black),
                  title: Text('Product',style: TextStyle( color: _selectedIndex == 2 ? Colors.blue : Colors.black)),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
                ListTile(
                  selected: _selectedIndex == 3,
                  leading: Icon(Icons.account_balance_wallet_rounded, color: _selectedIndex == 3 ? Colors.blue : Colors.black),
                  title: Text('View Report',style: TextStyle( color: _selectedIndex == 3 ? Colors.blue : Colors.black)),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
                ListTile(
                  selected: _selectedIndex == 4,
                  leading: Icon(Icons.person, color: _selectedIndex == 4 ? Colors.blue : Colors.black),
                  title: Text('Profile',style: TextStyle( color: _selectedIndex == 4 ? Colors.blue : Colors.black)),
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Transparent Top Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello BRUNO, welcome back!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bags Count Reporting System - RCCPL Pvt. Ltd. Butibori (GU)',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.black54),
                          SizedBox(width: 16),
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              'B',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Dynamic Body Content
                Expanded(
                  child: _screens[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}