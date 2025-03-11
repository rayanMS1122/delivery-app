import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class NoInternetConnectionScreen extends StatelessWidget {
  final NoInternetConnectionController _controller =
      Get.put(NoInternetConnectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              _buildStatusAnimation(),
              const SizedBox(height: 40),
              _buildStatusText(),
              const Spacer(flex: 1),
              _buildTryAgainButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusAnimation() {
    return Obx(() {
      return Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _controller.isConnected.value
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
        ),
        child: Center(
          child: _controller.isConnected.value
              ? Lottie.asset(
                  'assets/internet_connected.json',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                  // If you don't have this Lottie animation, you can use an Icon instead:
                  // Icon(
                  //   Icons.wifi,
                  //   size: 100,
                  //   color: Colors.green,
                  // ),
                )
              : Lottie.asset(
                  'assets/no_internet.json',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                  // If you don't have this Lottie animation, you can use an Icon instead:
                  // Icon(
                  //   Icons.wifi_off,
                  //   size: 100,
                  //   color: Colors.red,
                  // ),
                ),
        ),
      );
    });
  }

  Widget _buildStatusText() {
    return Obx(() {
      return Column(
        children: [
          Text(
            _controller.isConnected.value
                ? 'Connected to the Internet'
                : 'No Internet Connection',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _controller.isConnected.value
                  ? Colors.green.shade700
                  : Colors.red.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _controller.isConnected.value
                ? 'You\'re back online! You can continue using the app.'
                : 'Please check your internet connection and try again. Make sure Wi-Fi or mobile data is turned on.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTryAgainButton() {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFA4A0C),
              const Color(0xFFFF6433),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFA4A0C).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _controller.isLoading.value
                ? null
                : _controller.checkConnection,
            child: Center(
              child: _controller.isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _controller.isConnected.value
                              ? "Continue"
                              : "Try Again",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _controller.isConnected.value
                              ? Icons.arrow_forward_rounded
                              : Icons.refresh_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}

class NoInternetConnectionController extends GetxController {
  // Observable to track internet connection status
  var isConnected = false.obs;

  // Observable to track loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check connection when screen is first loaded
    checkConnection();
  }

  // Method to check internet connection
  void checkConnection() async {
    isLoading.value = true; // Show loading indicator

    // Simulate checking internet connection (replace with actual logic)
    await Future.delayed(Duration(seconds: 2));

    // Simulate connection status (replace with actual logic)
    // For demonstration, toggle between connected/disconnected
    isConnected.value = !isConnected.value;

    isLoading.value = false; // Hide loading indicator

    // Show a snackbar with the result
    if (isConnected.value) {
      Get.snackbar(
        'Connected',
        'You are now connected to the internet.',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 8,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.wifi, color: Colors.white),
      );
    } else {
      Get.snackbar(
        'Disconnected',
        'No internet connection found.',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 8,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.wifi_off, color: Colors.white),
      );
    }
  }
}
