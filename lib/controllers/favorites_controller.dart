import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FavoritesController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final CartController cartController = Get.find<CartController>();
  var favoriteItems = <FeaturedProduct>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Backend: POST /api/foods/favorites/add
  Future<void> addToFavorites(String foodId) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to add to favorites';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/favorites/add');
    final body = jsonEncode({'foodId': foodId});

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );

      print(
          'Add Favorite API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        // Fetch updated favorites list
        await fetchFavorites();
        Get.snackbar(
          'Added to Favorites',
          'Item added to your favorites',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'Failed to add to favorites';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              errorData['error'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        Get.snackbar('Error', errorMsg);
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value);
      print('Error: $e');
    }
  }

  // Backend: GET /api/foods/favorites
  Future<void> fetchFavorites() async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to view favorites';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/favorites');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(
          'Fetch Favorites API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['favorites'] ?? [];
        favoriteItems.value =
            data.map((item) => FeaturedProduct.fromJson(item)).toList();
      } else {
        String errorMsg = 'Failed to fetch favorites';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              errorData['error'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        Get.snackbar('Error', errorMsg);
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value);
      print('Error: $e');
    }
  }

  // Backend: DELETE /api/foods/favorites/remove/<id>
  Future<void> removeFavorite(String foodId) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to remove favorite';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    final product = favoriteItems.firstWhereOrNull((item) => item.id == foodId);
    if (product == null) return;

    favoriteItems.removeWhere((item) => item.id == foodId);
    isLoading.value = true;
    clearError();
    final url =
        Uri.parse('${AppConstants.baseUrl}/api/foods/favorites/remove/$foodId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(
          'Remove Favorite API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        Get.snackbar(
          'Removed from Favorites',
          'Item removed from your favorites',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'Failed to remove favorite';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              errorData['error'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        Get.snackbar('Error', errorMsg);
        favoriteItems.add(product); // Revert local change
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value);
      print('Error: $e');
      favoriteItems.add(product); // Revert local change
    }
  }

  // Add item to cart
  Future<void> addToCart(FeaturedProduct product) async {
    await cartController.addToCart(product);
  }
}
