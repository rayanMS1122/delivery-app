import 'package:delivery_app/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller for Welcome Screen
class WelcomeController extends GetxController {
  // Method to navigate to the LoginScreen
  void navigateToNextScreen() {
    Get.to(() => LoginScreen());
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with Get.put
    final WelcomeController controller = Get.put(WelcomeController());
    final Size size = MediaQuery.of(context).size;

    // Main brand color
    const Color mainColor = Color(0xFFFA4A0C);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Top Section with Brand and Tagline
            Container(
              padding: const EdgeInsets.only(
                  top: 60, left: 50, right: 50, bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1AFA4A0C),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand logo
                  Container(
                    width: 73,
                    height: 73,
                    decoration: BoxDecoration(
                      color: mainColor,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        "assets/icon_1.png",
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Brand message
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Food ",
                          style: TextStyle(
                            color: Color(0xFFFA4A0C),
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "for\nEveryone",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Middle section with illustration
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circles
                    Positioned(
                      right: -50,
                      top: 30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainColor.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: 100,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainColor.withOpacity(0.08),
                        ),
                      ),
                    ),

                    // Main image
                    Image.asset(
                      "assets/charakter_icons.png",
                      width: 400,
                      height: 400,
                      fit: BoxFit.contain,
                    ),

                    // Bottom gradient
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom section with button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
              child: Column(
                children: [
                  // Features row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFeatureItem(Icons.local_shipping_outlined,
                          "Fast Delivery", mainColor),
                      _buildFeatureItem(Icons.local_dining_outlined,
                          "Quality Food", mainColor),
                      _buildFeatureItem(
                          Icons.star_outline, "Best Reviews", mainColor),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Get Started button
                  GestureDetector(
                    onTap: controller.navigateToNextScreen,
                    child: Container(
                      width: 314,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build feature items
  Widget _buildFeatureItem(IconData icon, String text, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
