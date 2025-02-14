import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOffersScreen extends StatelessWidget {
  const MyOffersScreen({Key? key}) : super(key: key);

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Get.back(),
                      ),
                      const Text(
                        'Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 48), // Placeholder for alignment
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.05), // Adjusted spacing
                  Text(
                    'My offers',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08, // Adjusted font size
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1.7,
                      fontFamily: 'Poppins',
                    ),
                    semanticsLabel: 'My offers',
                  ),
                  SizedBox(height: screenHeight * 0.3), // Adjusted spacing
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'ohh snap! No offers yet',
                          style: TextStyle(
                            fontSize: screenWidth * 0.07, // Adjusted font size
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.56,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                          semanticsLabel: 'No offers available',
                        ),
                        SizedBox(
                            height: screenHeight * 0.02), // Adjusted spacing
                        Text(
                          'Bella doesn\'t have any offers\nyet please check again.',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Adjusted font size
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                          semanticsLabel:
                              'Bella has no offers, please check again',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
