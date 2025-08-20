import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';

class CheckoutController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var token = ''.obs;

  bool _isTokenValid(String token) {
    try {
      return token.isNotEmpty && !JwtDecoder.isExpired(token);
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  Future<bool> placeOrder({
    required String addressId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
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

    isLoading.value = true;
    hasError.value = false;

    final url = Uri.parse('${AppConstants.baseUrl}/api/orders');
    final body = jsonEncode({
      'addressId': addressId,
      'items': items,
      'totalAmount': totalAmount,
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
        onRetry: (e) => print('Retrying placeOrder: $e'),
      );

      print('Place Order API Request: $url, Body: $body');
      print(
          'Place Order API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Order placed successfully',
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
      errorMessage.value = 'Network error: Unable to place order';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Place order error: $e');
      return false;
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
}
