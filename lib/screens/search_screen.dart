import 'package:delivery_app/controllers/search_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  // Initialize the controller
  final SearchsController searchController = Get.put(SearchsController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color(0xFFEEEEEE),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.04), // Adjusted spacing
            CustomAppBar(
              title: "Search",
              onBackPressed: () {
                Get.back();
              },
            ),
            _buildSearchBar(context),
            SizedBox(height: screenHeight * 0.04), // Adjusted spacing
            Expanded(
              child: _buildResultsContainer(screenWidth, screenHeight),
            ),
          ],
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
            child: TextField(
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
              onChanged: (value) {
                // Update search query and results
                searchController.updateSearchResults(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsContainer(double screenWidth, double screenHeight) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: Color(0xFFF9F9F9),
      ),
      width: double.infinity,
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05), // Adjusted padding
              child: Obx(() => Text(
                    "Found ${searchController.searchResults.length} results",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.07, // Adjusted font size

                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ),
          SizedBox(height: screenHeight * 0.03), // Adjusted spacing
          Expanded(
            child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02), // Adjusted padding
                        child: ListView.builder(
                          itemCount: searchController.searchResults.length,
                          itemBuilder: (context, index) {
                            return _buildFeaturedProductCard(
                              searchController.searchResults[index],
                              "N1,900",
                              "assets/Mask Group.png",
                              screenWidth,
                              screenHeight,
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.02), // Adjusted padding
                        child: ListView.builder(
                          itemCount: searchController.searchResults.length,
                          itemBuilder: (context, index) {
                            return _buildFeaturedProductCard(
                              searchController.searchResults[index],
                              "N1,900",
                              "assets/Mask Group.png",
                              screenWidth,
                              screenHeight,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  // Featured Product Card Widget
  Widget _buildFeaturedProductCard(
    String title,
    String price,
    String image,
    double screenWidth,
    double screenHeight,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02, // Adjusted padding
        vertical: screenHeight * 0.01, // Adjusted padding
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: screenWidth * 0.45, // Adjusted width
            height: screenHeight * 0.25, // Adjusted height
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
                  top: screenHeight * 0.12, // Adjusted position
                  right: 0,
                  left: screenWidth * 0.05, // Adjusted position
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05, // Adjusted font size
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: screenHeight * 0.2, // Adjusted position
                  right: 0,
                  left: screenWidth * 0.1, // Adjusted position
                  child: Text(
                    price,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // Adjusted font size
                      color: const Color(0xFFFF4A3A),

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -screenHeight * 0.02, // Adjusted position
            left: screenWidth * 0.02, // Adjusted position
            child: Image.asset(
              image,
              width: screenWidth * 0.35, // Adjusted size
              height: screenWidth * 0.35, // Adjusted size
            ),
          ),
        ],
      ),
    );
  }
}
