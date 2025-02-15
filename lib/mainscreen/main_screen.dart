import 'package:bagreportun/util/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/menu_app_controller.dart';
import '../dashboard_screen.dart';
import '../master_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MenuAppController menuAppController = Get.put(MenuAppController());

    return Scaffold(
      key: menuAppController.scaffoldKey,
      //drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: MasterScreen(),
            ),
          ],
        ),
      ),
    );
  }
}