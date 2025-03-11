import 'package:delivery_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controllers for email and password fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables for error message and loading state
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  // Function to clear the error message
  void clearError() {
    errorMessage.value = '';
  }

  // Function to handle the login process
  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      return;
    }

    isLoading.value = true;

    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));

    // Check login credentials (dummy check)
    if (emailController.text == "user@example.com" &&
        passwordController.text == "password") {
      // Navigate to the home screen or perform other actions
      Get.to(HomeScreen());
    } else {
      errorMessage.value = 'Invalid email or password';
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
