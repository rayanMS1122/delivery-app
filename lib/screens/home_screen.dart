import 'package:delivery_app/controllers/home_controller.dart';
import 'package:delivery_app/screens/profile_screen.dart';
import 'package:delivery_app/widgets/bottom_navigation.dart';
import 'package:delivery_app/widgets/category_tabs.dart';
import 'package:delivery_app/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'history_screen.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = Get.put(HomeController());
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          switch (_controller.selectedNavIndex.value) {
            case 0:
              return _buildHomeScreen(context);
            case 1:
              return _buildFavoritesScreen();
            case 2:
              return ProfileScreen();
            case 3:
              return const HistoryScreen();
            default:
              return _buildHomeScreen(context);
          }
        }),
        bottomNavigationBar: BottomNavigation(),
      ),
      drawer: DrawerWidget(onSignOut: () {}),
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFF460A),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      openScale: 0.6,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            offset: Offset(-15, 50),
            spreadRadius: 15,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2F2F2), Colors.white],
          ),
        ),
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          screenHeight * 0.05,
          screenWidth * 0.05,
          screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAppBar(),
            SizedBox(height: screenHeight * 0.02),
            _buildTitle(),
            SizedBox(height: screenHeight * 0.02),
            _buildSearchBar(screenWidth),
            SizedBox(height: screenHeight * 0.02),
            CategoryTabs(),
            SizedBox(height: screenHeight * 0.01),
            _buildSeeMoreText(),
            SizedBox(height: screenHeight * 0.01),
            _buildFeaturedProducts(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Image.asset("assets/menu.png", scale: 30),
          onPressed: () => _advancedDrawerController.showDrawer(),
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderScreen()),
          ),
          child: Image.asset("assets/shopping-cart.png", scale: 25),
        ),
      ],
    );
  }

  Widget _buildFavoritesScreen() {
    return const Center(
      child: Text(
        "Favorites Screen",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTitle() {
    return const Row(
      children: [
        Text(
          "Delicious\nfood for you",
          style: TextStyle(
            fontSize: 34,
            fontFamily: "San-Francisco-Pro-Fonts-master",
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Container(
      width: screenWidth * 0.9,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF4A3A).withOpacity(0.1),
            const Color(0xFFFF4A3A).withOpacity(0.05),
          ],
        ),
        border: Border.all(
            color: const Color(0xFFFF4A3A).withOpacity(0.2), width: 1),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(
              fontFamily: "San-Francisco-Pro-Fonts-master",
              color: Colors.black54,
            ),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Color(0xFFFF4A3A)),
          ),
        ),
      ),
    );
  }

  Widget _buildSeeMoreText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "see more",
            style: TextStyle(
              fontFamily: "SF-Pro-Italic.ttf",
              color: Color(0xFFFF4A3A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts(double screenWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFeaturedProductCard("Veggie\ntomato mix", "N1,900",
              "assets/Mask Group.png", screenWidth),
          _buildFeaturedProductCard("Spicy \nfish sauce", "N1,1900",
              "assets/Mask Group (1).png", screenWidth),
        ],
      ),
    );
  }

  Widget _buildFeaturedProductCard(
      String title, String price, String image, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: screenWidth * 0.7,
            height: 215,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.9)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(57, 57, 57, 0.1),
                  blurRadius: 60,
                  offset: Offset(0, 30),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  top: 95,
                  right: 0,
                  left: 50,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: "San-Francisco-Pro-Fonts-master",
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 180,
                  right: 0,
                  left: 80,
                  child: Text(
                    price,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFFF4A3A),
                      fontFamily: "San-Francisco-Pro-Fonts-master",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -20,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Image.asset(image, width: 160, height: 160),
          ),
        ],
      ),
    );
  }
}
