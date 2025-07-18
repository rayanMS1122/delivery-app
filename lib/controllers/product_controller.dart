import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:delivery_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';

class ProductController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final CartController cartController = Get.find<CartController>();
  final RxList<FeaturedProduct> featuredProducts = <FeaturedProduct>[].obs;
  final RxList<FeaturedProduct> favoriteProducts = <FeaturedProduct>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxInt quantity = 1.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (_isTokenValid(profileController.token.value)) {
      loadFeaturedProducts();
      loadFavorites();
    } else {
      errorMessage.value = 'Please log in to view products';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  bool _isTokenValid(String token) {
    try {
      return token.isNotEmpty && !JwtDecoder.isExpired(token);
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  void _showErrorSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () {
            if (message.contains('log in')) {
              Get.offAllNamed('/login');
            } else {
              loadFeaturedProducts(); // Retry loading products
            }
          },
          child: Text(
            message.contains('log in') ? 'Login' : 'Retry',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    });
  }

  Future<void> loadFeaturedProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final queryParams = {
        if (category != null) 'category': category,
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
        if (sortBy != null) 'sortBy': sortBy,
        if (order != null) 'order': order,
      };
      final uri = Uri.parse('${AppConstants.baseUrl}/api/foods')
          .replace(queryParameters: queryParams);
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => http.get(
          uri,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying loadFeaturedProducts: $e'),
      );
      print('Products API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['foods'] ?? [];
        featuredProducts.assignAll(
            data.map((item) => FeaturedProduct.fromJson(item)).toList());
      } else {
        String errorMsg = 'Failed to fetch products';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onProductTap(FeaturedProduct product) {
    if (product.id.isNotEmpty) {
      Get.to(() => ProductDetailScreen(product: product));
    } else {
      Get.snackbar(
        'Error',
        'Invalid product selected',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addToCart(FeaturedProduct product, {int quantity = 1}) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }
    await cartController.addToCart(product, amount: quantity);
    this.quantity.value = 1; // Reset quantity after adding to cart
  }

  Future<void> loadFavorites() async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => http.get(
          Uri.parse('${AppConstants.baseUrl}/api/foods/favorites'),
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying loadFavorites: $e'),
      );
      print(
          'Favorites API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['favorites'] ?? [];
        favoriteProducts.assignAll(
            data.map((item) => FeaturedProduct.fromJson(item)).toList());
      } else {
        String errorMsg = 'Failed to load favorites';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(FeaturedProduct product) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final uri = product.isFavorite
          ? Uri.parse(
              '${AppConstants.baseUrl}/api/foods/favorites/remove/${product.id}')
          : Uri.parse('${AppConstants.baseUrl}/api/foods/favorites/add');
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => (product.isFavorite ? http.delete : http.post)(
          uri,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: product.isFavorite ? null : jsonEncode({'foodId': product.id}),
        ),
        onRetry: (e) => print('Retrying toggleFavorite: $e'),
      );
      print(
          'Toggle Favorite API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        product.isFavorite = !product.isFavorite;
        if (product.isFavorite) {
          if (!favoriteProducts.any((p) => p.id == product.id)) {
            favoriteProducts.add(product);
          }
        } else {
          favoriteProducts.removeWhere((p) => p.id == product.id);
        }
        update();
        Get.snackbar(
          product.isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
          '${product.name} has been ${product.isFavorite ? 'added to' : 'removed from'} your favorites',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'Failed to update favorite';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeImage(int index, List<String> images) {
    if (index >= 0 && index < images.length) {
      selectedImageIndex.value = index;
    }
  }

  void previousImage(List<String> images) {
    if (selectedImageIndex.value > 0) {
      selectedImageIndex.value--;
    }
  }

  void nextImage(List<String> images) {
    if (selectedImageIndex.value < images.length - 1) {
      selectedImageIndex.value++;
    }
  }

  void increaseQuantity() {
    quantity.value++;
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }
}
