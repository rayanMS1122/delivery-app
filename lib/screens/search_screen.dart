import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFEEEEEE),
        child: Column(
          children: [
            const SizedBox(height: 73),
            _buildSearchBar(context),
            const SizedBox(height: 39),
            Expanded(
              child: _buildResultsContainer(),
            ),
          ],
        ),
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 42),
      child: Row(
        children: [
          // Back Icon
          GestureDetector(
            onTap: () {
              // Handle back button press
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 24,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 16), // Adjusted spacing
          // Search TextField
          Container(
            width: MediaQuery.sizeOf(context).width * 0.75, // Adjusted width
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsContainer() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Color(0xFFF9F9F9),
      ),
      width: double.infinity,
      child: Column(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.all(22.0),
              child: Text(
                "Found 6 results",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontFamily: "San-Francisco-Pro-Fonts-master",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return _buildFeaturedProductCard(
                            "    Veggie\ntomato mix",
                            "N1,900",
                            "assets/Mask Group.png");
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: ListView.builder(
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return _buildFeaturedProductCard(
                            "    Veggie\ntomato mix",
                            "N1,900",
                            "assets/Mask Group.png");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Result Item Widget
  Widget _buildResultItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Featured Product Card Widget
  Widget _buildFeaturedProductCard(String title, String price, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none, // Changed to Clip.hardEdge
        children: [
          Container(
            width: 220,
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
                  left: 30,
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
                  left: 55,
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
            top: -15,
            left: 5,
            child: Image.asset(image, width: 150, height: 150),
          ),
        ],
      ),
    );
  }
}
