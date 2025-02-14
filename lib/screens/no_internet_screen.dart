import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  const NoInternetConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: screenHeight * 0.1), // Adjusted spacing
            Column(
              children: [
                Text(
                  'No internet Connection',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07, // Adjusted font size
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Text',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                Text(
                  'Your internet connection is currently\nnot available please check or try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // Adjusted font size
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05), // Adjusted padding
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFFFA4A0C),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFA4A0C).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      // Add navigation or action here#
                    },
                    child: Center(
                      child: Text(
                        "Try again",
                        style: TextStyle(
                          fontFamily: "SF-Pro-Text",
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
