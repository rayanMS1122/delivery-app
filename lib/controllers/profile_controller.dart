import 'package:delivery_app/api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User data observables
  final fullName = "".obs;
  final email = "".obs;
  final phone = "".obs;
  final isEditing = false.obs;
  final RxString? profileImagePath = null;

  // Address data with observables
  final homeAddress = "".obs;
  final workAddress = "".obs;

  // Payment method selection observables
  final isCardSelected = false.obs;
  final isBankSelected = false.obs;
  final isPaypalSelected = false.obs;

  // Form controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController homeAddressController;
  late TextEditingController workAddressController;

  // Loading state
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    homeAddressController = TextEditingController();
    workAddressController = TextEditingController();

    // Fetch user data
    fetchUserData();
  }

  @override
  void onClose() {
    // Dispose of controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    homeAddressController.dispose();
    workAddressController.dispose();
    super.onClose();
  }

  // Fetch user data from API
  Future<void> fetchUserData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final data = await Api.getUserData();

      if (data != null) {
        // Update observables
        fullName.value = data["name"] ?? "";
        email.value = data["email"] ?? "";
        phone.value = data["phone"] ?? "";
        homeAddress.value = data["homeAddress"] ?? "";
        workAddress.value = data["workAddress"] ?? "";

        // Update text controllers
        nameController.text = fullName.value;
        emailController.text = email.value;
        phoneController.text = phone.value;
        homeAddressController.text = homeAddress.value;
        workAddressController.text = workAddress.value;

        update();
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to load user data: ${e.toString()}";
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Save user data to API
  Future<bool> saveUserData() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      // Update observables with form values
      fullName.value = nameController.text.trim();
      email.value = emailController.text.trim();
      phone.value = phoneController.text.trim();
      homeAddress.value = homeAddressController.text.trim();
      workAddress.value = workAddressController.text.trim();

      // Create payload for API
      final userData = {
        "name": fullName.value,
        "email": email.value,
        "phone": phone.value,
        "homeAddress": homeAddress.value,
        "workAddress": workAddress.value,
      };

      // Call API to update user data
      final success = await Api.updateUserData(userData);

      if (success) {
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
          margin: const EdgeInsets.all(8),
          borderRadius: 8,
        );
        return true;
      } else {
        throw Exception("API returned failure status");
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Failed to save user data: ${e.toString()}";
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle edit mode
  void toggleEditMode() {
    if (isEditing.value) {
      // Save changes
      saveUserData().then((success) {
        if (success) {
          isEditing.value = false;
        }
      });
    } else {
      // Enter edit mode
      isEditing.value = true;
    }
  }

  // Upload profile image
  Future<void> uploadProfileImage(String imagePath) async {
    isLoading.value = true;

    try {
      final success = await Api.uploadProfileImage(imagePath);

      if (success) {
        Get.snackbar(
          "Success",
          "Profile picture updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
        );
      } else {
        throw Exception("Failed to upload image");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to upload profile picture: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400],
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Payment method selection handlers
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

  // Reset form to current values
  void resetForm() {
    nameController.text = fullName.value;
    emailController.text = email.value;
    phoneController.text = phone.value;
    homeAddressController.text = homeAddress.value;
    workAddressController.text = workAddress.value;
    isEditing.value = false;
  }

  // Validate form fields
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
}
