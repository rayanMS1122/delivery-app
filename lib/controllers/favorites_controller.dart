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

  // Backend: GET /api/foods/favorites
  Future<void> fetchFavorites({
    String? searchQuery,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to view favorites';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    clearError();
    final url =
        Uri.parse('${AppConstants.baseUrl}/api/foods/favorites').replace(
      queryParameters: {
        if (searchQuery != null && searchQuery.isNotEmpty)
          'search': searchQuery,
        if (category != null) 'category': category,
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
        if (sortBy != null) 'sortBy': sortBy,
        if (order != null) 'order': order,
      },
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Fetch Favorites API Request: $url');
      print(
          'Fetch Favorites API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['favorites'] ?? [];
        favoriteItems.value = data
            .map((item) {
              try {
                return FeaturedProduct.fromJson(item);
              } catch (e) {
                print('Error parsing favorite item: $item, Error: $e');
                return null;
              }
            })
            .where((item) => item != null)
            .cast<FeaturedProduct>()
            .toList();
        if (favoriteItems.isEmpty && data.isNotEmpty) {
          errorMessage.value =
              'Some favorite items could not be loaded due to invalid data';
          Get.snackbar('Warning', errorMessage.value,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange,
              colorText: Colors.white);
        }
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
        Get.snackbar('Error', errorMsg,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('Network Error: $e');
    }
  }

  // Backend: POST /api/foods/favorites/add
  Future<void> addFavorite(String productId) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to add favorites';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/favorites/add');
    final body = jsonEncode({'foodId': productId});

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
        final product = favoriteItems.firstWhere(
          (item) => item.id == productId,
          orElse: () => FeaturedProduct(
            id: '',
            name: '',
            description: '',
            category: '',
            price: 0.0,
            image: '',
            preparationTime: null,
            averageRating: 0.0,
            ratingCount: 0,
            restaurantId: '',
          ),
        );
        if (product.id.isNotEmpty) {
          product.isFavorite = true;
          favoriteItems.refresh();
        } else {
          await fetchFavorites(); // Refresh if product not in local list
        }
        Get.snackbar(
          'Added to Favorites',
          'Item added to your favorites',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'Failed to add favorite';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              errorData['error'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        Get.snackbar('Error', errorMsg,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('Error: $e');
    }
  }

  // Backend: DELETE /api/foods/favorites/remove/<id>
  Future<void> removeFavorite(String productId) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to remove favorites';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse(
        '${AppConstants.baseUrl}/api/foods/favorites/remove/$productId');

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
        final product = favoriteItems.firstWhere(
          (item) => item.id == productId,
          orElse: () => FeaturedProduct(
            id: '',
            name: '',
            description: '',
            category: '',
            price: 0.0,
            image: '',
            preparationTime: null,
            averageRating: 0.0,
            ratingCount: 0,
            restaurantId: '',
          ),
        );
        if (product.id.isNotEmpty) {
          product.isFavorite = false;
          favoriteItems.removeWhere((item) => item.id == productId);
          favoriteItems.refresh();
        }
        Get.snackbar(
            'Removed from Favorites', 'Item removed from your favorites',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);
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
        Get.snackbar('Error', errorMsg,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('Error: $e');
    }
  }

  // Add favorite item to cart
  Future<void> addFavoriteToCart(FeaturedProduct product,
      {int amount = 1}) async {
    if (product.id.isEmpty) {
      errorMessage.value = 'Product not found';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    await cartController.addToCart(product, amount: amount);
  }
}
