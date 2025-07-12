import 'package:delivery_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigation extends StatelessWidget {
  final HomeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, contrains) {
      double iconSize = contrains.maxWidth * 0.06;
      return Obx(
        () => SalomonBottomBar(
          onTap: (index) => _controller.selectedNavIndex.value = index,
          curve: Curves.easeInOutCirc,
          items: _buildBottomNavItems(context, iconSize),
          selectedItemColor: const Color(0xFFFF4A3A),
          duration: const Duration(seconds: 1),
          currentIndex: _controller.selectedNavIndex.value,
          backgroundColor: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      );
    });
  }

  List<SalomonBottomBarItem> _buildBottomNavItems(
      BuildContext context, double iconSize) {
    return [
      _buildBottomNavItem(
          "assets/heroicons-solid_home.png", "Home", 0, context, iconSize),
      _buildBottomNavItem("assets/heart.png", "Fav", 1, context, iconSize),
      _buildBottomNavItem("assets/user.png", "Account", 2, context, iconSize),
      _buildBottomNavItem(
          "assets/ic_sharp-history.png", "History", 3, context, iconSize),
    ];
  }

  SalomonBottomBarItem _buildBottomNavItem(String iconPath, String title,
      int index, BuildContext context, double iconSize) {
    return SalomonBottomBarItem(
      icon: Image.asset(
        iconPath,
        width: iconSize,
        height: iconSize,
        color: _controller.selectedNavIndex.value == index
            ? const Color(0xFFFF4A3A)
            : Colors.grey,
      ),
      title: Text(title),
    );
  }
}
