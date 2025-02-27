import 'package:delivery_app/controllers/offers_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOffersScreen extends StatelessWidget {
  final MyOffersController _controller = Get.put(MyOffersController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFF5F5F8),
          ),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05, // Adjusted padding
                0,
                screenWidth * 0.05, // Adjusted padding
                screenHeight * 0.3, // Adjusted padding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                  CustomAppBar(
                    title: "Offers",
                    onBackPressed: () {
                      Get.back(); // Use GetX for navigation
                    },
                  ),
                  SizedBox(height: screenHeight * 0.05), // Adjusted spacing
                  Text(
                    'My offers',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08, // Adjusted font size
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1.7,
                    ),
                    semanticsLabel: 'My offers',
                  ),
                  SizedBox(height: screenHeight * 0.05), // Adjusted spacing
                  Obx(() {
                    return _controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                            color: const Color(0xFFFA4A0C),
                          )) // Show loading indicator
                        : _controller.offers.isEmpty
                            ? _buildNoOffersMessage(screenWidth,
                                screenHeight) // Show no offers message
                            : _buildOffersList(); // Show list of offers
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget to show when no offers are available
  Widget _buildNoOffersMessage(double screenWidth, double screenHeight) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.2), // Adjusted spacing
          Text(
            'ohh snap! No offers yet',
            style: TextStyle(
              fontSize: screenWidth * 0.07, // Adjusted font size
              fontWeight: FontWeight.w500,
              letterSpacing: -0.56,
            ),
            textAlign: TextAlign.center,
            semanticsLabel: 'No offers available',
          ),
          SizedBox(height: screenHeight * 0.02), // Adjusted spacing
          Text(
            'Bella doesn\'t have any offers\nyet please check again.',
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Adjusted font size
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
            semanticsLabel: 'Bella has no offers, please check again',
          ),
        ],
      ),
    );
  }

  // Widget to show list of offers
  Widget _buildOffersList() {
    final MyOffersController _controller = Get.find();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _controller.offers.length,
      itemBuilder: (context, index) {
        final offer = _controller.offers[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(offer.title),
            subtitle: Text(offer.description),
            trailing: Text(
              offer.discount,
              style: TextStyle(
                color: const Color(0xFFFA4A0C),
              ),
            ),
          ),
        );
      },
    );
  }
}
