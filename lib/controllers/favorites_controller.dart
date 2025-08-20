import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';

class FavoritesController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final CartController cartController = Get.find<CartController>();
  final RxList<FeaturedProduct> favoriteProducts = <FeaturedProduct>[].obs;
  final RxBool isLoading = false.obs;
  final RxList<String> favoriteIds = <String>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (_isTokenValid(profileController.token.value)) {
      fetchFavorites(searchQuery: '');
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

  List<String> getFavoriteIds() {
    return favoriteIds.toList();
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
              fetchFavorites(searchQuery: '');
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

  Future<void> fetchFavorites({
    String? category,
    required String searchQuery,
  }) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final queryParameters = <String, String>{};
    if (category != null) queryParameters['category'] = category;
    if (searchQuery.isNotEmpty) queryParameters['searchQuery'] = searchQuery;

    final uri =
        Uri.parse('${AppConstants.baseUrl}/api/foods/favorites').replace(
      queryParameters: queryParameters,
    );

    try {
      print('Token used: ${profileController.token.value}');
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
        onRetry: (e) => print('Retrying fetchFavorites: $e'),
      );

      print('Fetch Favorites API Request: $uri');
      print(
          'Fetch Favorites API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['favorites'] ?? [];
        favoriteProducts.assignAll(
          data
              .map((item) {
                try {
                  return FeaturedProduct.fromJson(item);
                } catch (e) {
                  print('Error parsing favorite product: $item, Error: $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<FeaturedProduct>()
              .toList(),
        );
        if (favoriteProducts.isEmpty && data.isNotEmpty) {
          errorMessage.value =
              'Some favorites could not be loaded due to invalid data';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.snackbar(
              'Warning',
              errorMessage.value,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          });
        }
      } else {
        String errorMsg = 'Failed to load favorites';
        if (response.statusCode == 400 &&
            response.body.contains('Invalid food ID')) {
          errorMsg =
              'Invalid favorite items detected. Please refresh your favorites.';
          favoriteProducts.clear();
        } else if (response.statusCode == 401) {
          errorMsg = 'Session expired. Please log in again.';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/login');
          });
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

  Future<void> addFavorite(String foodId) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final uri = Uri.parse('${AppConstants.baseUrl}/api/foods/favorites/add');
    final body = jsonEncode({'foodId': foodId});
    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.post(
          uri,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        ),
        onRetry: (e) => print('Retrying addFavorite: $e'),
      );

      print('Add Favorite API Request: $uri, Body: $body');
      print(
          'Add Favorite API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final product = FeaturedProduct.fromJson(data['food'] ?? {});
        if (!favoriteProducts.any((p) => p.id == product.id)) {
          favoriteProducts.add(product);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Success',
            'Added to favorites',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        });
      } else {
        String errorMsg = 'Failed to add favorite';
        if (response.statusCode == 400 &&
            response.body.contains('Invalid food ID')) {
          errorMsg = 'Invalid food item selected';
        } else if (response.statusCode == 401) {
          errorMsg = 'Session expired. Please log in again.';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/login');
          });
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

  Future<void> removeFavorite(String foodId) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final uri =
        Uri.parse('${AppConstants.baseUrl}/api/foods/favorites/remove/$foodId');
    try {
      final response = await RetryOptions(
        maxAttempts: 3,
        delayFactor: const Duration(seconds: 2),
      ).retry(
        () => http.delete(
          uri,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying removeFavorite: $e'),
      );

      print('Remove Favorite API Request: $uri');
      print(
          'Remove Favorite API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        favoriteProducts.removeWhere((p) => p.id == foodId);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Success',
            'Removed from favorites',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        });
      } else {
        String errorMsg = 'Failed to remove favorite';
        if (response.statusCode == 400 &&
            response.body.contains('Invalid food ID')) {
          errorMsg = 'Invalid food item selected';
          favoriteProducts.removeWhere((p) => p.id == foodId);
        } else if (response.statusCode == 401) {
          errorMsg = 'Session expired. Please log in again.';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/login');
          });
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

  Future<void> addFavoriteToCart(FeaturedProduct item) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('Adding to cart from favorites: ${item.name}, ID: ${item.id}');
      await cartController.addToCart(item, amount: 1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Success',
          'Added ${item.name} to cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
    } catch (e) {
      errorMessage.value = 'Failed to add ${item.name} to cart';
      _showErrorSnackBar(errorMessage.value);
      print('Error adding to cart from favorites: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
