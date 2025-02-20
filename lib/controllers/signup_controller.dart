import 'package:delivery_app/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // Controllers for text fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables for error message and loading state
  final errorMessage = ''.obs;
  final isLoading = false.obs;

  // Function to handle the signup process
  void signUp() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      return;
    }

    isLoading.value = true;

    // Simulate a network call
    await Future.delayed(const Duration(seconds: 2));

    // Dummy signup logic
    if (emailController.text == "user@example.com") {
      errorMessage.value = 'Email already registered';
    } else {
      // Navigate to the login screen or perform other actions
      Get.offAll(() => LoginScreen());
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
