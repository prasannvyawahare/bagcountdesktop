import 'package:bagreportun/login_screen.dart';
import 'package:bagreportun/product_screen.dart';
import 'package:bagreportun/profile_screen.dart';
import 'package:bagreportun/shift_setting_screen.dart';
import 'package:bagreportun/controller/serial_port_service.dart';
import 'package:bagreportun/vew_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'com_setting.dart';
import 'dashboard_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}
int _selectedIndex = 0;
class _MasterScreenState extends State<MasterScreen> {

  bool _isCollapsed = false;

  final List<Widget> _screens = [
    DashboardScreen(),
    ComSetting(),
    ShiftSettingScreen(),
    ProductScreen(),
    VewReportScreen(),
    ProfileScreen(userId: '1', softwareVersion: '3'),
  ];

  final List<String> _screenTitles = [
    'Dashboard',
    'Communication Settings',
    'Shift Settings',
    'Product Management',
    'View Report',
    'Profile',
    'Logout'
  ];

  @override
  void initState() {
    super.initState();
    Get.put(SerialPortService());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Fixed Side Menu with Rounded Corners
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            width: _isCollapsed ? 70 : 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(2, 0), // Shadow to the right
                ),
              ],
            ),
            child: SideMenu(
              onItemSelected: _onNavItemTapped,
              isCollapsed: _isCollapsed,
              toggleCollapse: _toggleMenu,
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Header Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bag Count Reporting System - RCCPL Pvt. Ltd. Btibory(GU)",
                        style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                      ),

                      Text(
                        _screenTitles[_selectedIndex],
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          // IconButton(
                          //   icon: Icon(Icons.menu, color: Colors.black),
                          //   onPressed: _toggleMenu,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Selected Screen Content
                Expanded(child: _screens[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleMenu() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }
}

// Side Menu (Fixed Sidebar)
class SideMenu extends StatelessWidget {
  final Function(int) onItemSelected;
  final bool isCollapsed;
  final VoidCallback toggleCollapse;

  const SideMenu({
    Key? key,
    required this.onItemSelected,
    required this.isCollapsed,
    required this.toggleCollapse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // IconButton(
        //   icon: Icon(isCollapsed ? Icons.chevron_right : Icons.chevron_left),
        //   onPressed: toggleCollapse,
        // ),
        SizedBox(height: 150,),
        Divider(height: 1, color: Colors.grey[200],),
        SizedBox(height: 20,),
        Expanded(
          child: ListView(
            children: [
              _buildDrawerItem(
                  "Dashboard", "images/icons/menu_dashboard.svg", 0,context),
              _buildDrawerItem("Port", "images/icons/menu_store.svg", 1,context),
              _buildDrawerItem("Shift", "images/icons/menu_doc.svg", 2,context),
              _buildDrawerItem("Brand", "images/icons/pdf_file.svg", 3,context),
              _buildDrawerItem("View Report", "images/icons/menu_tran.svg", 4,context),
              _buildDrawerItem("Profile", "images/icons/menu_profile.svg", 5,context),
              _buildDrawerItem("Logout", "images/icons/menu_store.svg", -1,context),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Image.asset(
            "images/person_laptop_img.png", // Replace with your actual image path
            height: isCollapsed ? 40 : 100, // Adjust size based on menu state
            width: isCollapsed ? 40 : 100,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem(String title, String svgSrc, int index,BuildContext context) {
    bool isSelected = index == _selectedIndex; // Check if item is selected

    return ListTile(
      tileColor: isSelected ? Colors.blue[100] : Colors.white60,
      // Background color
      onTap: () {

        if (index == -1) {
          // If Logout is tapped, navigate to LoginScreen and replace stack
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          onItemSelected(index); // Change selected index normally
        } // Change selected index
      },
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(
          isSelected ? Colors.blue : Colors.black, // Icon color change
          BlendMode.srcIn,
        ),
        height: 20,
      ),
      title: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: isCollapsed
            ? SizedBox()
            : Text(
          title,
          key: ValueKey(title),
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black, // Text color change
            fontWeight: isSelected ? FontWeight.bold : FontWeight
                .normal, // Bold text if selected
          ),
        ),
      ),
    );
  }
}
