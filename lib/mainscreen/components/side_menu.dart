import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "images/icons/menu_dashboard.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Port",
            svgSrc: "images/icons/menu_store.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Shift",
            svgSrc: "images/icons/menu_doc.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Brand",
            svgSrc: "images/icons/menu_store.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "View Report",
            svgSrc: "images/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "images/icons/menu_profile.svg",
            press: () {},
          ),
        DrawerListTile(
            title: "Logout",
            svgSrc: "",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor:Colors.white60,
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),

    );
  }
}
