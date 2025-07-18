import 'package:delivery_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';

class ProfileController extends GetxController {
  var token = "".obs;
  final fullName = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final profileImagePath = "".obs;
  final isEditing = false.obs;
  final homeAddress = "".obs;
  final workAddress = "".obs;
  final isCardSelected = false.obs;
  final isBankSelected = false.obs;
  final isPaypalSelected = false.obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = "".obs;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController homeAddressController;
  late TextEditingController workAddressController;

  @override
  void onInit() {
    super.onInit();
    print('ProfileController initialized, token: ${token.value}');
    nameController = TextEditingController(text: fullName.value);
    emailController = TextEditingController(text: email.value);
    phoneController = TextEditingController(text: phone.value);
    homeAddressController = TextEditingController(text: homeAddress.value);
    workAddressController = TextEditingController(text: workAddress.value);

    if (token.value.isNotEmpty && _isTokenValid(token.value)) {
      fetchUserProfile();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    homeAddressController.dispose();
    workAddressController.dispose();
    super.onClose();
  }

  bool _isTokenValid(String token) {
    try {
      return token.isNotEmpty && !JwtDecoder.isExpired(token);
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  Future<void> fetchUserProfile() async {
    if (token.value.isEmpty || !_isTokenValid(token.value)) {
      print('Error: No valid token available for fetching profile');
      hasError.value = true;
      errorMessage.value = 'Please log in to view your profile';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      print('Fetching profile from: ${AppConstants.baseUrl}/api/users/profile');
      print('Using token: ${token.value}');
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.get(
          Uri.parse('${AppConstants.baseUrl}/api/users/profile'),
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying fetchUserProfile: $e'),
      );

      print('Profile API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['user'];
        fullName.value = data['name'] ?? '';
        email.value = data['email'] ?? '';
        phone.value = data['phone'] ?? '';
        profileImagePath.value = data['profileImage'] ?? '';
        print(
            'Fetched Profile: name=${fullName.value}, email=${email.value}, phone=${phone.value}, image=${profileImagePath.value}');
        nameController.text = fullName.value;
        emailController.text = email.value;
        phoneController.text = phone.value;
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        Get.snackbar("Error", errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value =
          'Network error: Unable to connect to server. Please check your connection or try again later.';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Fetch profile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _parseErrorResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ??
          'Failed to fetch profile: ${response.statusCode}';
    } catch (_) {
      if (response.body.contains('ngrok')) {
        return 'Server is offline. Please ensure the backend is running and try again.';
      }
      return 'Failed to parse server response: ${response.statusCode}';
    }
  }

  Future<void> saveUserData() async {
    if (!validateForm()) {
      return;
    }

    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Please log in to update your profile';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.patch(
          Uri.parse('${AppConstants.baseUrl}/api/users/profile'),
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
          }),
        ),
        onRetry: (e) => print('Retrying saveUserData: $e'),
      );

      print(
          'Save Profile API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        fullName.value = nameController.text.trim();
        email.value = emailController.text.trim();
        phone.value = phoneController.text.trim();
        homeAddress.value = homeAddressController.text.trim();
        workAddress.value = workAddressController.text.trim();

        Get.snackbar(
          "Success",
          "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        );

        isEditing.value = false;
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        Get.snackbar("Error", errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Save profile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadProfileImage(String imagePath) async {
    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Please log in to update your profile image';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.patch(
          Uri.parse('${AppConstants.baseUrl}/api/users/profile'),
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'profileImage': imagePath,
          }),
        ),
        onRetry: (e) => print('Retrying uploadProfileImage: $e'),
      );

      print(
          'Upload Image API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        profileImagePath.value = imagePath;
        Get.snackbar(
          "Success",
          "Profile picture updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
        );
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        Get.snackbar("Error", errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to upload image';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Upload image error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEditMode() {
    if (isEditing.value) {
      saveUserData();
    } else {
      isEditing.value = true;
    }
  }

  void toggleCardSelection(bool value) {
    isCardSelected.value = value;
    if (value) {
      isBankSelected.value = false;
      isPaypalSelected.value = false;
    }
    update();
  }

  void toggleBankSelection(bool value) {
    isBankSelected.value = value;
    if (value) {
      isCardSelected.value = false;
      isPaypalSelected.value = false;
    }
    update();
  }

  void togglePaypalSelection(bool value) {
    isPaypalSelected.value = value;
    if (value) {
      isCardSelected.value = false;
      isBankSelected.value = false;
    }
    update();
  }

  void resetForm() {
    nameController.text = fullName.value;
    emailController.text = email.value;
    phoneController.text = phone.value;
    homeAddressController.text = homeAddress.value;
    workAddressController.text = workAddress.value;
    isEditing.value = false;
    hasError.value = false;
    errorMessage.value = "";
  }

  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Name cannot be empty",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar("Error", "Please enter a valid email",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar("Error", "Phone number cannot be empty",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  void setToken(String newToken) {
    token.value = newToken;
    print('Token set: ${token.value}');
    if (_isTokenValid(newToken)) {
      fetchUserProfile();
    } else {
      hasError.value = true;
      errorMessage.value = 'Invalid or expired token';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
