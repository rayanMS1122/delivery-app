import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  final NoInternetConnectionController _controller =
      Get.put(NoInternetConnectionController());

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
                Obx(() {
                  return Text(
                    _controller.isConnected.value
                        ? 'Connected to the Internet'
                        : 'No internet Connection',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07, // Adjusted font size
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
                SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                Obx(() {
                  return Text(
                    _controller.isConnected.value
                        ? 'You are now connected to the internet.'
                        : 'Your internet connection is currently\nnot available please check or try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04, // Adjusted font size
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05), // Adjusted padding
              child: Obx(() {
                return _controller.isLoading.value
                    ? CircularProgressIndicator(
                        color: const Color(0xFFFA4A0C),
                      ) // Show loading indicator
                    : Container(
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
                              _controller
                                  .checkConnection(); // Check internet connection
                            },
                            child: Center(
                              child: Text(
                                "Try again",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class NoInternetConnectionController extends GetxController {
  // Observable to track internet connection status
  var isConnected = false.obs;

  // Observable to track loading state
  var isLoading = false.obs;

  // Method to check internet connection
  void checkConnection() async {
    isLoading.value = true; // Show loading indicator

    // Simulate checking internet connection (replace with actual logic)
    await Future.delayed(Duration(seconds: 2));

    // Simulate connection status (replace with actual logic)
    isConnected.value = true; // Set to true if connected, false otherwise

    isLoading.value = false; // Hide loading indicator

    // Show a snackbar with the result
    if (isConnected.value) {
      Get.snackbar(
        'Success',
        'You are now connected to the internet.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Error',
        'No internet connection found.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
