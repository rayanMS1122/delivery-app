import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // User data observables
  final fullName = "John Doe".obs;
  final email = "john.doe@example.com".obs;
  final phone = "+1234567890".obs;
  final isEditing = false.obs;
  final RxString? profileImagePath = null;

  // Address data with observables
  final homeAddress = "123 Main St, City".obs;
  final workAddress = "456 Work Ave, City".obs;

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
    // Initialize controllers with default values
    nameController = TextEditingController(text: fullName.value);
    emailController = TextEditingController(text: email.value);
    phoneController = TextEditingController(text: phone.value);
    homeAddressController = TextEditingController(text: homeAddress.value);
    workAddressController = TextEditingController(text: workAddress.value);
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

  // Save user data locally
  void saveUserData() {
    isLoading.value = true;
    hasError.value = false;

    if (!validateForm()) {
      isLoading.value = false;
      return;
    }

    // Simulate saving data
    Future.delayed(Duration(seconds: 1), () {
      // Update observables with form values
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
      isLoading.value = false;
    });
  }

  // Toggle edit mode
  void toggleEditMode() {
    if (isEditing.value) {
      // Save changes
      saveUserData();
    } else {
      // Enter edit mode
      isEditing.value = true;
    }
  }

  // Upload profile image
  void uploadProfileImage(String imagePath) {
    isLoading.value = true;

    // Simulate image upload
    Future.delayed(Duration(seconds: 1), () {
      profileImagePath?.value = imagePath;

      Get.snackbar(
        "Success",
        "Profile picture updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[400],
        colorText: Colors.white,
      );

      isLoading.value = false;
    });
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
