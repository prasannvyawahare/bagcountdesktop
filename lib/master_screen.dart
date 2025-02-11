import 'package:bagreportun/product_screen.dart';
import 'package:bagreportun/profile_screen.dart';
import 'package:bagreportun/shift_setting_screen.dart';
import 'package:bagreportun/controller/serial_port_service.dart';
import 'package:bagreportun/vew_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'com_setting.dart';
import 'dashboard_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;
  bool _isCollapsed = false;
  final List<Widget> _screens = [
    DashboardScreen(),
    ComSetting(),
    ShiftSettingScreen(),
    ProductScreen(),
    VewReportScreen(),
    ProfileScreen(userId: '1', softwareVersion: '3'),
  ];
@override
  void initState() {
    // TODO: implement initState
  Get.put(SerialPortService());
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Collapsible Side Navigation Bar
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isCollapsed ? 70 : 200,
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Icon(_isCollapsed ? Icons.menu_open : Icons.menu),
                  ),
                ),
                _buildNavItem(Icons.dashboard, 'Dashboard', 0),
                _buildNavItem(Icons.confirmation_num_outlined, 'Port', 1),
                _buildNavItem(Icons.filter_tilt_shift, 'Shift', 2),
                _buildNavItem(Icons.computer, 'Brand', 3),
                _buildNavItem(Icons.account_balance_wallet_rounded, 'View Report', 4),
                _buildNavItem(Icons.person, 'Profile', 5),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
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
                            style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bags Count Reporting System - RCCPL Pvt. Ltd. Butibori (GU)',
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.black54),
                          SizedBox(width: 16),
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text('B', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: _screens[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return ListTile(
      selected: _selectedIndex == index,
      leading: Icon(icon, color: _selectedIndex == index ? Colors.blue : Colors.black),
      title: _isCollapsed ? null : Text(label, style: TextStyle(color: _selectedIndex == index ? Colors.blue : Colors.black)),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
