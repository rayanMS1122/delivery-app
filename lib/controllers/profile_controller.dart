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
  final loyaltyPoints = 0.obs;
  final isEditing = false.obs;
  final addresses = <Map<String, dynamic>>[].obs;
  final orders = <Map<String, dynamic>>[].obs;
  final notificationPreferences = <String, bool>{}.obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = "".obs;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  final addressControllers = <Map<String, TextEditingController>>[].obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: fullName.value);
    emailController = TextEditingController(text: email.value);
    phoneController = TextEditingController(text: phone.value);
    if (token.value.isNotEmpty && _isTokenValid(token.value)) {
      fetchUserProfile();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    for (var controllerMap in addressControllers) {
      controllerMap['street']?.dispose();
      controllerMap['city']?.dispose();
      controllerMap['state']?.dispose();
      controllerMap['postalCode']?.dispose();
      controllerMap['country']?.dispose();
    }
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
        loyaltyPoints.value = data['loyaltyPoints'] ?? 0;
        addresses.value =
            List<Map<String, dynamic>>.from(data['addresses'] ?? []);
        orders.value = List<Map<String, dynamic>>.from(data['orders'] ?? []);
        notificationPreferences.value =
            Map<String, bool>.from(data['preferences']['notifications'] ?? {});

        nameController.text = fullName.value;
        emailController.text = email.value;
        phoneController.text = phone.value;

        addressControllers.clear();
        for (var address in addresses) {
          addressControllers.add({
            'street': TextEditingController(text: address['street'] ?? ''),
            'city': TextEditingController(text: address['city'] ?? ''),
            'state': TextEditingController(text: address['state'] ?? ''),
            'postalCode':
                TextEditingController(text: address['postalCode'] ?? ''),
            'country': TextEditingController(text: address['country'] ?? ''),
          });
        }
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
      print('Fetch profile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _parseErrorResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ??
          data['errors']?.join(', ') ??
          'Failed to fetch profile: ${response.statusCode}';
    } catch (_) {
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
      final updatedAddresses = addresses.asMap().entries.map((entry) {
        final index = entry.key;
        return {
          '_id': entry.value['_id'],
          'street': addressControllers[index]['street']?.text.trim(),
          'city': addressControllers[index]['city']?.text.trim(),
          'state': addressControllers[index]['state']?.text.trim(),
          'postalCode': addressControllers[index]['postalCode']?.text.trim(),
          'country': addressControllers[index]['country']?.text.trim(),
          'isDefault': entry.value['isDefault'],
          'coordinates': entry.value['coordinates'],
        };
      }).toList();

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
            'addresses': updatedAddresses,
            'preferences': {
              'notifications': Map<String, bool>.from(notificationPreferences)
            },
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
        addresses.value = updatedAddresses;
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
          margin: EdgeInsets.all(8 * _scaleFactor(Get.context!)),
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

  Future<bool> addNewAddress({
    required String street,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    bool isDefault = false,
  }) async {
    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Please log in to add an address';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (street.trim().isEmpty ||
        city.trim().isEmpty ||
        state.trim().isEmpty ||
        postalCode.trim().isEmpty ||
        country.trim().isEmpty) {
      hasError.value = true;
      errorMessage.value = 'All address fields must be filled';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final newAddress = {
        'street': street.trim(),
        'city': city.trim(),
        'state': state.trim(),
        'postalCode': postalCode.trim(),
        'country': country.trim(),
        'isDefault': isDefault,
        'coordinates': {
          'type': 'Point',
          'coordinates': [0, 0]
        },
      };

      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.post(
          Uri.parse('${AppConstants.baseUrl}/api/users/addresses'),
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(newAddress),
        ),
        onRetry: (e) => print('Retrying addNewAddress: $e'),
      );

      print(
          'Add Address API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final addedAddress = data['address'] ?? newAddress;
        addresses.add(addedAddress);
        addressControllers.add({
          'street': TextEditingController(text: addedAddress['street']),
          'city': TextEditingController(text: addedAddress['city']),
          'state': TextEditingController(text: addedAddress['state']),
          'postalCode': TextEditingController(text: addedAddress['postalCode']),
          'country': TextEditingController(text: addedAddress['country']),
        });
        Get.snackbar(
          "Success",
          "Address added successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
        );
        return true;
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        Get.snackbar("Error", errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to add address';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Add address error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteAddress(int index) async {
    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Please log in to delete an address';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    if (index < 0 ||
        index >= addresses.length ||
        addresses[index]['isDefault']) {
      Get.snackbar("Error", "Cannot delete default address or invalid index",
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final addressId = addresses[index]['_id'];
      if (addressId == null) {
        throw Exception('Address ID is missing');
      }

      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.delete(
          Uri.parse('${AppConstants.baseUrl}/api/users/addresses/$addressId'),
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying deleteAddress: $e'),
      );

      print(
          'Delete Address API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        addresses.removeAt(index);
        addressControllers[index]['street']?.dispose();
        addressControllers[index]['city']?.dispose();
        addressControllers[index]['state']?.dispose();
        addressControllers[index]['postalCode']?.dispose();
        addressControllers[index]['country']?.dispose();
        addressControllers.removeAt(index);
        Get.snackbar(
          "Success",
          "Address deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[400],
          colorText: Colors.white,
        );
        return true;
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        Get.snackbar("Error", errorMessage.value,
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to delete address';
      Get.snackbar("Error", errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Delete address error: $e');
      return false;
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
          body: jsonEncode({'profileImage': imagePath}),
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

  void removeAddress(int index) {
    deleteAddress(index);
  }

  void setDefaultAddress(int index) {
    for (var i = 0; i < addresses.length; i++) {
      addresses[i]['isDefault'] = i == index;
    }
    addresses.refresh();
  }

  void updateNotificationPreference(String key, bool value) {
    notificationPreferences[key] = value;
    notificationPreferences.refresh();
  }

  void resetForm() {
    nameController.text = fullName.value;
    emailController.text = email.value;
    phoneController.text = phone.value;
    for (var i = 0; i < addresses.length; i++) {
      addressControllers[i]['street']?.text = addresses[i]['street'] ?? '';
      addressControllers[i]['city']?.text = addresses[i]['city'] ?? '';
      addressControllers[i]['state']?.text = addresses[i]['state'] ?? '';
      addressControllers[i]['postalCode']?.text =
          addresses[i]['postalCode'] ?? '';
      addressControllers[i]['country']?.text = addresses[i]['country'] ?? '';
    }
    notificationPreferences
        .assignAll(Map<String, bool>.from(notificationPreferences));
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
    for (var i = 0; i < addresses.length; i++) {
      if ((addressControllers[i]['street']?.text.trim().isEmpty ?? true) ||
          (addressControllers[i]['city']?.text.trim().isEmpty ?? true) ||
          (addressControllers[i]['state']?.text.trim().isEmpty ?? true) ||
          (addressControllers[i]['postalCode']?.text.trim().isEmpty ?? true) ||
          (addressControllers[i]['country']?.text.trim().isEmpty ?? true)) {
        Get.snackbar("Error", "All address fields must be filled",
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
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

  double _scaleFactor(BuildContext context) =>
      MediaQuery.of(context).size.width / 360;
}
