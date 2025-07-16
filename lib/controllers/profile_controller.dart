import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileController extends GetxController {
  final String baseUrl =
      "https://c5bb3b297311.ngrok-free.app/api/users/profile";
  var token = "".obs; // Observable token
  final fullName = "".obs; // Remove default for production
  final email = "".obs;
  final phone = "".obs;
  final profileImagePath = "".obs; // Observable for image URL
  final isEditing = false.obs;
  final homeAddress = "".obs; // Not in API, keep local
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

    // Only fetch profile if token is available
    if (token.value.isNotEmpty) {
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

  Future<void> fetchUserProfile() async {
    if (token.value.isEmpty) {
      print('Error: No token available for fetching profile');
      hasError.value = true;
      errorMessage.value = 'No authentication token available';
      Get.snackbar("Error", errorMessage.value);
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      print('Fetching profile with token: ${token.value}');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
      );

      print('Profile API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['user'];
        fullName.value = data['name'] ?? fullName.value;
        email.value = data['email'] ?? email.value;
        phone.value = data['phone'] ?? phone.value;
        profileImagePath.value = data['profileImage'] ?? '';
        print('Fetched Profile Image URL: ${profileImagePath.value}');
        nameController.text = fullName.value;
        emailController.text = email.value;
        phoneController.text = phone.value;
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to fetch profile: ${response.statusCode}';
        Get.snackbar("Error", errorMessage.value);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error fetching profile: $e';
      Get.snackbar("Error", errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveUserData() async {
    isLoading.value = true;
    hasError.value = false;

    if (!validateForm()) {
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.patch(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
        }),
      );

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
        errorMessage.value = 'Failed to update profile: ${response.statusCode}';
        Get.snackbar("Error", errorMessage.value);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error updating profile: $e';
      Get.snackbar("Error", errorMessage.value);
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

  Future<void> uploadProfileImage(String imagePath) async {
    isLoading.value = true;

    try {
      final response = await http.patch(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'profileImage': imagePath,
        }),
      );

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
        errorMessage.value = 'Failed to upload image: ${response.statusCode}';
        Get.snackbar("Error", errorMessage.value);
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error uploading image: $e';
      Get.snackbar("Error", errorMessage.value);
    } finally {
      isLoading.value = false;
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
      Get.snackbar("Error", "Name cannot be empty");
      return false;
    }
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      Get.snackbar("Error", "Please enter a valid email");
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar("Error", "Phone number cannot be empty");
      return false;
    }
    return true;
  }

  void setToken(String newToken) {
    token.value = newToken;
    print('Token set: ${token.value}');
    fetchUserProfile();
  }
}
