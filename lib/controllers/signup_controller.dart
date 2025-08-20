import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();
  final longitudeController = TextEditingController();
  final latitudeController = TextEditingController();

  final errorMessage = ''.obs;
  final isLoading = false.obs;
  final ProfileController profileController = Get.find<ProfileController>();

  Future<void> signUp() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        phoneController.text.isEmpty ||
        streetController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        postalCodeController.text.isEmpty ||
        countryController.text.isEmpty ||
        longitudeController.text.isEmpty ||
        latitudeController.text.isEmpty) {
      errorMessage.value = 'Please fill in all required fields';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
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

    if (!GetUtils.isPhoneNumber(phoneController.text)) {
      errorMessage.value = 'Invalid phone number format';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final longitude = double.tryParse(longitudeController.text);
    final latitude = double.tryParse(latitudeController.text);
    if (longitude == null ||
        latitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      errorMessage.value =
          'Invalid coordinates format (latitude: -90 to 90, longitude: -180 to 180)';
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
    errorMessage.value = '';

    final url = Uri.parse('${AppConstants.baseUrl}/api/users/register');
    final body = jsonEncode({
      'name': nameController.text.trim(),
      'email': emailController.text.trim().toLowerCase(),
      'password': passwordController.text,
      'phone': phoneController.text.trim(),
      'address': {
        'street': streetController.text.trim(),
        'city': cityController.text.trim(),
        'state': stateController.text.trim(),
        'postalCode': postalCodeController.text.trim(),
        'country': countryController.text.trim(),
        'coordinates': [longitude, latitude],
      },
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
        onRetry: (e) => print('Retrying signUp: $e'),
      );

      print('Signup API Request: $url, Body: $body');
      print('Signup API Response: ${response.statusCode} - ${response.body}');

      isLoading.value = false;

      if (response.statusCode == 201) {
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
          print('Signup successful: ${user['name']} (${user['email']})');
          print('Token: $token');
          Get.snackbar(
            'Success',
            'Registration successful',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.offNamed('/home');
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
        String errorMsg = 'Registration failed';
        if (response.statusCode == 400) {
          errorMsg = 'Invalid input data';
        } else if (response.statusCode == 409) {
          errorMsg = 'Email already registered';
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
            'Error: Signup failed with status ${response.statusCode}: $errorMsg');
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    longitudeController.dispose();
    latitudeController.dispose();
    super.onClose();
  }
}
