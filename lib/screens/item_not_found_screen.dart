import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemNotFoundScreen extends StatelessWidget {
  final ItemNotFoundController _controller = Get.put(ItemNotFoundController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F8),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        "assets/chevron-left.png",
                        scale: 30,
                      ),
                      onPressed: () {
                        Get.back(); // Use GetX for navigation
                      },
                    ),
                    Text(
                      "Search",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.06,
                      ),
                    ),
                    const SizedBox(width: 48), // Placeholder for alignment
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Adjusted spacing
              _buildSearchBar(context),
              SizedBox(height: screenHeight * 0.2), // Adjusted spacing
              Obx(() {
                return _controller.isSearching.value
                    ? _buildSearchResults() // Show search results
                    : _buildNoResults(context); // Show "Item not found" message
              }),
            ],
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
                )
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              onChanged: (query) {
                _controller
                    .search(query); // Call search method in the controller
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show when no results are found
  Widget _buildNoResults(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Icon(
          Icons.search,
          size: screenWidth * 0.3, // Adjusted icon size
          color: Colors.black26,
        ),
        SizedBox(height: screenWidth * 0.02), // Adjusted spacing
        Text(
          'Item not found',
          style: TextStyle(
            fontSize: screenWidth * 0.07, // Adjusted font size
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenWidth * 0.02), // Adjusted spacing
        Text(
          'Try searching the item with\na different keyword.',
          style: TextStyle(
            fontSize: screenWidth * 0.04, // Adjusted font size
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Widget to show search results
  Widget _buildSearchResults() {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _controller.searchResults.length,
        itemBuilder: (context, index) {
          final item = _controller.searchResults[index];
          return ListTile(
            title: Text(item),
            onTap: () {
              // Handle item selection
            },
          );
        },
      );
    });
  }
}

class ItemNotFoundController extends GetxController {
  // Observable for search query
  var searchQuery = ''.obs;

  // Observable for search results
  var searchResults = <String>[].obs;

  // Observable to track if searching is in progress
  var isSearching = false.obs;

  // Method to handle search
  void search(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;

    // Simulate search results (replace with actual search logic)
    if (query.isNotEmpty) {
      searchResults.value = [
        "Item 1",
        "Item 2",
        "Item 3",
      ]
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      searchResults.clear();
    }
  }
}
