import 'package:delivery_app/api/api.dart';
import 'package:delivery_app/screens/authentication/login.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // Controllers for email and password fields
  final emailController = TextEditingController(text: "raean@gmail.com");
  final passwordController = TextEditingController(text: "raean");

  // Observable variables for error message and loading state
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    Get.off(LoginScreen());
    print("User logged out");
  }

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

    // // Check login credentials (dummy check)
    // if (emailController.text == "user@example.com" &&
    //     passwordController.text == "password") {
    //   // Navigate to the home screen or perform other actions
    //   Get.to(HomeScreen());
    // } else {
    //   errorMessage.value = 'Invalid email or password';
    // }
    Api.loginUser(emailController.text, passwordController.text, HomeScreen());

    isLoading.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
