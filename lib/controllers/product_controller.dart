import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/controllers/favorites_controller.dart';

class ProductController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final CartController cartController = Get.find<CartController>();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  final RxList<FeaturedProduct> featuredProducts = <FeaturedProduct>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxInt quantity = 1.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (_isTokenValid(profileController.token.value)) {
      loadFeaturedProducts();
      syncFavorites();
    } else {
      errorMessage.value = 'Session expired. Please log in again.';
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
        'Error',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () {
            if (message.contains('log in')) {
              Get.offAllNamed('/login');
            } else {
              loadFeaturedProducts();
            }
          },
          child: const Text(
            'Retry',
            style: TextStyle(color: Colors.white),
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

    final queryParams = {
      if (category != null && category.isNotEmpty) 'category': category,
      if (minPrice != null) 'minPrice': minPrice.toString(),
      if (maxPrice != null) 'maxPrice': maxPrice.toString(),
      if (sortBy != null) 'sortBy': sortBy,
      if (order != null) 'order': order,
    };
    final uri = Uri.parse('${AppConstants.baseUrl}/api/foods')
        .replace(queryParameters: queryParams);

    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
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

      print('Load Products API Request: $uri');
      print(
          'Load Products API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        featuredProducts.assignAll(
          data
              .map((item) {
                try {
                  return FeaturedProduct.fromJson(item);
                } catch (e) {
                  print('Error parsing product: $item, Error: $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<FeaturedProduct>()
              .toList(),
        );
        await syncFavorites(); // Sync favorite status after loading products
        if (featuredProducts.isEmpty && data.isNotEmpty) {
          errorMessage.value =
              'Some products could not be loaded due to invalid data';
          Get.snackbar(
            'Warning',
            errorMessage.value,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        String errorMsg = 'Failed to fetch products';
        if (response.statusCode == 401) {
          errorMsg = 'Session expired. Please log in again.';
          Get.offAllNamed('/login');
        } else {
          try {
            final errorData = jsonDecode(response.body);
            errorMsg = errorData['message'] ??
                'Server error (status: ${response.statusCode})';
          } catch (_) {
            errorMsg = 'Failed to parse server response';
          }
        }
        errorMessage.value = errorMsg;
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Network Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncFavorites() async {
    final favoriteIds = await favoritesController.getFavoriteIds();
    featuredProducts.assignAll(
      featuredProducts.map((product) {
        return product.copyWith(isFavorite: favoriteIds.contains(product.id));
      }).toList(),
    );
  }

  void onProductTap(FeaturedProduct product) {
    if (product.id.isNotEmpty) {
      Get.toNamed('/product-detail', arguments: {'product': product});
    } else {
      errorMessage.value = 'Invalid product selected';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
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
    this.quantity.value = 1;
  }

  Future<void> toggleFavorite(FeaturedProduct product) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }
    final index = featuredProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      if (product.isFavorite) {
        await favoritesController.removeFavorite(product.id);
        featuredProducts[index] = product.copyWith(isFavorite: false);
      } else {
        await favoritesController.addFavorite(product.id);
        featuredProducts[index] = product.copyWith(isFavorite: true);
      }
    }
  }

  void changeImage(int index, String image) {
    selectedImageIndex.value = index;
  }

  void previousImage(String image) {
    // No-op: Single image support
  }

  void nextImage(String image) {
    // No-op: Single image support
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
