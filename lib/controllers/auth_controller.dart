import 'package:delivery_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  void signUp() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar("Error", "Passwords do not match",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      // Simulate a successful signup
      Get.snackbar("Success", "Account created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      // Navigate to HomeScreen after successful signup
      Get.offAll(
          () => HomeScreen()); // Use offAll to remove all previous routes
    } else {
      Get.snackbar("Error", "Please fill all fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = "Please fill in all fields.";
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));

    if (emailController.text == "test@example.com" &&
        passwordController.text == "password") {
      Get.offAllNamed('/home'); // Navigate to home screen on success
    } else {
      errorMessage.value = "Invalid email or password.";
    }

    isLoading.value = false;
  }

  void clearError() {
    errorMessage.value = '';
  }
}
