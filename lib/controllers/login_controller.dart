import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final emailController = TextEditingController(text: "adminest@gmail.com");
  final passwordController = TextEditingController(text: "password");
  final errorMessage = ''.obs;
  final isLoading = false.obs;
  var token = ''.obs;
  ProfileController profileController = Get.find();

  @override
  void onInit() {
    super.onInit();
    try {
      profileController = Get.find<ProfileController>();
    } catch (e) {
      print('Error: ProfileController not found. Registering new instance.');
      Get.put(ProfileController());
      profileController = Get.find<ProfileController>();
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      Get.snackbar("Error", errorMessage.value);
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      errorMessage.value = 'Invalid email format';
      Get.snackbar("Error", errorMessage.value);
      return;
    }

    isLoading.value = true;
    clearError();

    final url = Uri.parse('${AppConstants.baseUrl}/api/users/login');

    final body = jsonEncode({
      "email": emailController.text.trim().toLowerCase(),
      "password": passwordController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      print('Login API Response: ${response.statusCode} - ${response.body}');

      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        token.value = data['token'] ?? '';
        final user = data['user'] ?? {};

        if (token.value.isEmpty) {
          errorMessage.value = 'No token received from server';
          Get.snackbar("Error", errorMessage.value);
          return;
        }

        print('Login successful: ${user['name']} (${user['email']})');
        print('Token: ${token.value}');
        profileController.setToken(token.value);
        Get.off(() => HomeScreen());
      } else {
        String errorMsg = 'Login failed';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              errorData['error'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        Get.snackbar("Error", errorMsg);
        print(
            'Error: Login failed with status ${response.statusCode}: $errorMsg');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar("Error", errorMessage.value);
      print('Error: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
