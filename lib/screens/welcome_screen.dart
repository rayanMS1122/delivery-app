import 'package:delivery_app/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  void navigateToNextScreen() {
    Get.to(() => LoginScreen()); // Contextless navigation using Get.to()
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller with Get.put
    final WelcomeController controller = Get.put(WelcomeController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF460A),
        ),
        child: Column(
          children: [
            // Top Section with Icon and Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 51, vertical: 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circle Icon
                  Container(
                    width: 73,
                    height: 73,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset("assets/icon_1.png"),
                    ),
                  ),
                  const SizedBox(height: 41),
                  // Text
                  const Text(
                    "Food for Everyone",
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "San-Francisco-Pro-Fonts-master",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Image Section with Gradient Shadow in Foreground
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/charakter_icons.png",
                      width: 400,
                      height: 400,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF4A3A).withOpacity(.1),
                            Color(0xFFFF4B3A).withOpacity(.4),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 314,
                      margin: const EdgeInsets.only(
                          bottom: 40, top: 20, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 63),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            // Calling the navigateToNextScreen method from the controller
                            controller.navigateToNextScreen();
                          },
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                              color: Color(0xFFFF4B3A),
                              fontSize: 18,
                              fontFamily: "San-Francisco-Pro-Fonts-master",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
