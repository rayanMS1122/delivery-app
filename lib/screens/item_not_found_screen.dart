import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemNotFoundScreen extends StatelessWidget {
  const ItemNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F8),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.1), // Adjusted spacing
                _buildSearchBar(context),
                SizedBox(height: screenHeight * 0.2), // Adjusted spacing
                Icon(
                  Icons.search,
                  size: screenWidth * 0.3, // Adjusted icon size
                  color: Colors.black26,
                ),
                SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                Text(
                  'Item not found',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07, // Adjusted font size
                    fontWeight: FontWeight.w600,
                    fontFamily: 'San-Francisco-Pro-Fonts-master',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                Text(
                  'Try searching the item with\na different keyword.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Adjusted font size
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SF Pro Text',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.1), // Adjusted padding
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
          SizedBox(width: screenWidth * 0.04), // Adjusted spacing
          // Search TextField
          Container(
            width: screenWidth * 0.75, // Adjusted width
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ItemNotFoundController extends GetxController {
  // Add any necessary controller logic here
}
