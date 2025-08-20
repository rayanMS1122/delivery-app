import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController(text: "adminest@gmail.com");
  final passwordController = TextEditingController(text: "password");
  final errorMessage = ''.obs;
  final isLoading = false.obs;
  final ProfileController profileController = Get.find<ProfileController>();

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      errorMessage.value = 'Please fill in all fields';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      errorMessage.value = 'Invalid email format';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/users/login');
    final body = jsonEncode({
      'email': emailController.text.trim().toLowerCase(),
      'password': passwordController.text,
    });

    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        ),
        onRetry: (e) => print('Retrying login: $e'),
      );

      print('Login API Request: $url, Body: $body');
      print('Login API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] ?? '';
        final user = data['user'] ?? {};

        if (token.isEmpty) {
          errorMessage.value = 'No token received from server';
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        if (!JwtDecoder.isExpired(token)) {
          profileController.setUserData(
            token: token,
            name: user['name'] ?? '',
            email: user['email'] ?? '',
          );
          print('Login successful: ${user['name']} (${user['email']})');
          print('Token: $token');
          Get.to(HomeScreen());
        } else {
          errorMessage.value = 'Received expired token';
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        String errorMsg = 'Login failed';
        if (response.statusCode == 401) {
          errorMsg = 'Invalid email or password';
        } else {
          try {
            final errorData = jsonDecode(response.body);
            errorMsg = errorData['message'] ??
                'Server error (status: ${response.statusCode})';
          } catch (_) {
            errorMsg = 'Failed to parse server response';
          }
        }
        errorMessage.value = errorMsg;
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(
            'Error: Login failed with status ${response.statusCode}: $errorMsg');
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Network Error: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
