import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemNotFoundScreen extends StatelessWidget {
  const ItemNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 73),
              _buildSearchBar(context),
              const SizedBox(height: 190),
              Icon(
                Icons.search,
                size: 125,
                color: Colors.black26,
              ),
              Text(
                'Item not found',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'San-Francisco-Pro-Fonts-master',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 17),
              Text(
                'Try searching the item with\na different keyword.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro Text',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  } // Search Bar Widget

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
}

class ItemNotFoundController extends GetxController {
  // Add any necessary controller logic here
}
