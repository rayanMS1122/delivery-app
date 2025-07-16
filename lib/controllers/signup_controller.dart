import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
  var token = ''.obs;
  late ProfileController profileController;

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
      Get.snackbar("Error", errorMessage.value);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'Passwords do not match';
      Get.snackbar("Error", errorMessage.value);
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      errorMessage.value = 'Invalid email format';
      Get.snackbar("Error", errorMessage.value);
      return;
    }

    if (!RegExp(r'^\+\d{10,15}$').hasMatch(phoneController.text)) {
      errorMessage.value = 'Invalid phone number format';
      Get.snackbar("Error", errorMessage.value);
      return;
    }

    final longitude = double.tryParse(longitudeController.text);
    final latitude = double.tryParse(latitudeController.text);
    if (longitude == null || latitude == null) {
      errorMessage.value = 'Invalid coordinates format';
      Get.snackbar("Error", errorMessage.value);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final url = Uri.parse('${AppConstants.baseUrl}/api/users/register');
    final body = jsonEncode({
      "name": nameController.text.trim(),
      "email": emailController.text.trim().toLowerCase(),
      "password": passwordController.text,
      "phone": phoneController.text.trim(),
      "address": {
        "street": streetController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "postalCode": postalCodeController.text.trim(),
        "country": countryController.text.trim(),
        "coordinates": [longitude, latitude]
      }
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

      print('Signup API Response: ${response.statusCode} - ${response.body}');

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        token.value = data['token'] ?? '';
        final user = data['user'] ?? {};

        if (token.value.isEmpty) {
          errorMessage.value = 'No token received from server';
          Get.snackbar("Error", errorMessage.value);
          return;
        }

        print('Signup successful: ${user['name']} (${user['email']})');
        print('Token: ${token.value}');
        profileController.setToken(token.value);
        Get.off(() => HomeScreen());
      } else {
        String errorMsg = 'Registration failed';
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
            'Error: Signup failed with status ${response.statusCode}: $errorMsg');
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
