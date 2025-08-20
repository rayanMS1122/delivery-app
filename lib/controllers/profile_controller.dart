import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';

class ProfileController extends GetxController {
  var token = ''.obs;
  final fullName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final profileImagePath = ''.obs;
  final loyaltyPoints = 0.obs;
  final isEditing = false.obs;
  final addresses = <Map<String, dynamic>>[].obs;
  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

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

  void setUserData(
      {required String token, String name = '', String email = ''}) {
    this.token.value = token;
    fullName.value = name;
    this.email.value = email;
    nameController.text = name;
    emailController.text = email;
    if (_isTokenValid(token)) {
      fetchUserProfile();
    } else {
      hasError.value = true;
      errorMessage.value = 'Invalid or expired token';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  Future<void> fetchUserProfile() async {
    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Session expired. Please log in again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final url = Uri.parse('${AppConstants.baseUrl}/api/users/profile');
    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.get(
          url,
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying fetchUserProfile: $e'),
      );

      print('Fetch Profile API Request: $url');
      print(
          'Fetch Profile API Response: ${response.statusCode} - ${response.body}');

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
        if (response.statusCode == 401) {
          Get.offAllNamed('/login');
        }
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Fetch profile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String _parseErrorResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Server error (status: ${response.statusCode})';
    } catch (_) {
      return 'Failed to parse server response';
    }
  }

  Future<void> saveUserData() async {
    if (!validateForm()) {
      return;
    }

    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Session expired. Please log in again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    final url = Uri.parse('${AppConstants.baseUrl}/api/users/profile');
    final body = jsonEncode({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'addresses': addresses.asMap().entries.map((entry) {
        final index = entry.key;
        return {
          '_id': entry.value['_id'],
          'street': addressControllers[index]['street']?.text.trim(),
          'city': addressControllers[index]['city']?.text.trim(),
          'state': addressControllers[index]['state']?.text.trim(),
          'postalCode': addressControllers[index]['postalCode']?.text.trim(),
          'country': addressControllers[index]['country']?.text.trim(),
          'isDefault': entry.value['isDefault'] ?? false,
        };
      }).toList(),
    });

    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.patch(
          url,
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        ),
        onRetry: (e) => print('Retrying saveUserData: $e'),
      );

      print('Save Profile API Request: $url, Body: $body');
      print(
          'Save Profile API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        fullName.value = nameController.text.trim();
        email.value = emailController.text.trim();
        phone.value = phoneController.text.trim();
        addresses.value = addresses.asMap().entries.map((entry) {
          final index = entry.key;
          return {
            '_id': entry.value['_id'],
            'street': addressControllers[index]['street']?.text.trim(),
            'city': addressControllers[index]['city']?.text.trim(),
            'state': addressControllers[index]['state']?.text.trim(),
            'postalCode': addressControllers[index]['postalCode']?.text.trim(),
            'country': addressControllers[index]['country']?.text.trim(),
            'isDefault': entry.value['isDefault'] ?? false,
          };
        }).toList();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isEditing.value = false;
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        if (response.statusCode == 401) {
          Get.offAllNamed('/login');
        }
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      errorMessage.value = 'Session expired. Please log in again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
      return false;
    }

    if (street.trim().isEmpty ||
        city.trim().isEmpty ||
        state.trim().isEmpty ||
        postalCode.trim().isEmpty ||
        country.trim().isEmpty) {
      hasError.value = true;
      errorMessage.value = 'All address fields must be filled';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    isLoading.value = true;
    hasError.value = false;

    final url = Uri.parse('${AppConstants.baseUrl}/api/users/addresses');
    final body = jsonEncode({
      'street': street.trim(),
      'city': city.trim(),
      'state': state.trim(),
      'postalCode': postalCode.trim(),
      'country': country.trim(),
      'isDefault': isDefault,
    });

    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.post(
          url,
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        ),
        onRetry: (e) => print('Retrying addNewAddress: $e'),
      );

      print('Add Address API Request: $url, Body: $body');
      print(
          'Add Address API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final addedAddress = data['address'] ??
            {
              'street': street.trim(),
              'city': city.trim(),
              'state': state.trim(),
              'postalCode': postalCode.trim(),
              'country': country.trim(),
              'isDefault': isDefault,
            };
        addresses.add(addedAddress);
        addressControllers.add({
          'street': TextEditingController(text: addedAddress['street']),
          'city': TextEditingController(text: addedAddress['city']),
          'state': TextEditingController(text: addedAddress['state']),
          'postalCode': TextEditingController(text: addedAddress['postalCode']),
          'country': TextEditingController(text: addedAddress['country']),
        });
        if (isDefault) {
          for (var i = 0; i < addresses.length - 1; i++) {
            addresses[i]['isDefault'] = false;
          }
          addresses.refresh();
        }
        Get.snackbar(
          'Success',
          'Address added successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        if (response.statusCode == 401) {
          Get.offAllNamed('/login');
        }
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to add address';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Add address error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> removeAddress(int index) async {
    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Session expired. Please log in again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
      return false;
    }

    if (index < 0 || index >= addresses.length) {
      hasError.value = true;
      errorMessage.value = 'Invalid address index';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (addresses[index]['isDefault'] == true) {
      hasError.value = true;
      errorMessage.value = 'Cannot delete default address';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    isLoading.value = true;
    hasError.value = false;

    final addressId = addresses[index]['_id'];
    if (addressId == null) {
      hasError.value = true;
      errorMessage.value = 'Address ID is missing';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return false;
    }

    final url =
        Uri.parse('${AppConstants.baseUrl}/api/users/addresses/$addressId');
    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.delete(
          url,
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying removeAddress: $e'),
      );

      print('Remove Address API Request: $url');
      print(
          'Remove Address API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        addresses.removeAt(index);
        addressControllers[index]['street']?.dispose();
        addressControllers[index]['city']?.dispose();
        addressControllers[index]['state']?.dispose();
        addressControllers[index]['postalCode']?.dispose();
        addressControllers[index]['country']?.dispose();
        addressControllers.removeAt(index);
        Get.snackbar(
          'Success',
          'Address deleted successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        if (response.statusCode == 401) {
          Get.offAllNamed('/login');
        }
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to delete address';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Remove address error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> setDefaultAddress(int index) async {
    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Session expired. Please log in again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
      return false;
    }

    if (index < 0 || index >= addresses.length) {
      hasError.value = true;
      errorMessage.value = 'Invalid address index';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    final addressId = addresses[index]['_id'];
    if (addressId == null) {
      hasError.value = true;
      errorMessage.value = 'Address ID is missing';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    isLoading.value = true;
    hasError.value = false;

    final url = Uri.parse(
        '${AppConstants.baseUrl}/api/users/addresses/$addressId/default');
    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.patch(
          url,
          headers: {
            'Authorization': 'Bearer ${token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying setDefaultAddress: $e'),
      );

      print('Set Default Address API Request: $url');
      print(
          'Set Default Address API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        for (var i = 0; i < addresses.length; i++) {
          addresses[i]['isDefault'] = i == index;
        }
        addresses.refresh();
        Get.snackbar(
          'Success',
          'Default address updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(response);
        if (response.statusCode == 401) {
          Get.offAllNamed('/login');
        }
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to set default address';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Set default address error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadProfileImage(String imagePath) async {
    if (!_isTokenValid(token.value)) {
      hasError.value = true;
      errorMessage.value = 'Session expired. Please log in again.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    final url = Uri.parse('${AppConstants.baseUrl}/api/users/profile/image');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer ${token.value}',
      'Accept': 'application/json',
    });
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => request.send(),
        onRetry: (e) => print('Retrying uploadProfileImage: $e'),
      );

      final responseBody = await response.stream.bytesToString();
      print('Upload Image API Request: $url');
      print(
          'Upload Image API Response: ${response.statusCode} - $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseBody);
        profileImagePath.value = data['profileImage'] ?? imagePath;
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        hasError.value = true;
        errorMessage.value = _parseErrorResponse(
            http.Response(responseBody, response.statusCode));
        if (response.statusCode == 401) {
          Get.offAllNamed('/login');
        }
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: Unable to upload image';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
    isEditing.value = false;
    hasError.value = false;
    errorMessage.value = '';
  }

  bool validateForm() {
    if (nameController.text.trim().isEmpty) {
      hasError.value = true;
      errorMessage.value = 'Name cannot be empty';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text)) {
      hasError.value = true;
      errorMessage.value = 'Please enter a valid email';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (phoneController.text.trim().isEmpty ||
        !GetUtils.isPhoneNumber(phoneController.text)) {
      hasError.value = true;
      errorMessage.value = 'Please enter a valid phone number';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    for (var i = 0; i < addresses.length; i++) {
      if ((addressControllers[i]['street']?.text.trim().isEmpty ?? true) ||
          (addressControllers[i]['city']?.text.trim().isEmpty ?? true) ||
          (addressControllers[i]['state']?.text.trim().isEmpty ?? true) ||
          (addressControllers[i]['postalCode']?.text.trim().isEmpty ?? true) ||
          (addressControllers[i]['country']?.text.trim().isEmpty ?? true)) {
        hasError.value = true;
        errorMessage.value = 'All address fields must be filled';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }
    return true;
  }
}
