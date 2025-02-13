import 'package:delivery_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigation extends StatelessWidget {
  final HomeController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => SalomonBottomBar(
          onTap: (index) => _controller.selectedNavIndex.value = index,
          curve: Curves.easeInOutCirc,
          items: _buildBottomNavItems(),
          selectedItemColor: const Color(0xFFFF4A3A),
          duration: const Duration(seconds: 1),
          currentIndex: _controller.selectedNavIndex.value,
          backgroundColor: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ));
  }

  List<SalomonBottomBarItem> _buildBottomNavItems() {
    return [
      _buildBottomNavItem("assets/heroicons-solid_home.png", "Home", 0),
      _buildBottomNavItem("assets/heart.png", "Fav", 1),
      _buildBottomNavItem("assets/user.png", "Account", 2),
      _buildBottomNavItem("assets/ic_sharp-history.png", "History", 3),
    ];
  }

  SalomonBottomBarItem _buildBottomNavItem(
      String iconPath, String title, int index) {
    return SalomonBottomBarItem(
      icon: Image.asset(
        iconPath,
        scale: 35,
        color: _controller.selectedNavIndex.value == index
            ? const Color(0xFFFF4A3A)
            : Colors.grey,
      ),
      title: Text(title),
    );
  }
}
