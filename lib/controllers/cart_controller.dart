import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/models/cart_item.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retry/retry.dart';

class CartController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  var cartItems = <CartItem>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var quantity = 1.obs;
  var deliveryFee = 2.99.obs;
  var totalAmount = 0.0.obs;
  var updatingItemIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  void clearError() {
    errorMessage.value = '';
  }

  void resetQuantity() {
    quantity.value = 1;
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
              fetchCart();
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

  Future<void> addToCart(FeaturedProduct product, {int amount = 1}) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    if (amount < 1) {
      errorMessage.value = 'Invalid quantity: $amount';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    if (product.id.isEmpty || product.price <= 0) {
      errorMessage.value = 'Invalid product data';
      _showErrorSnackBar(errorMessage.value);
      print('Invalid product: id=${product.id}, price=${product.price}');
      return;
    }

    final cartItem = CartItem.fromFeaturedProduct(product, amount: amount);
    final existingItem =
        cartItems.firstWhereOrNull((item) => item.foodId == product.id);

    print(
        'Adding to cart: ${cartItem.name}, foodId: ${cartItem.foodId}, amount: $amount');

    if (existingItem != null) {
      existingItem.amount += amount;
      cartItems.refresh();
      await updateCart(existingItem);
    } else {
      cartItems.add(cartItem);
      await _addToCartBackend(cartItem);
    }
    resetQuantity();
    _updateTotalAmount();
  }

  Future<void> _addToCartBackend(CartItem item) async {
    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/cart/add');
    final body = jsonEncode({'foodId': item.foodId, 'quantity': item.amount});

    try {
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => http.post(
          url,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        ),
        onRetry: (e) => print('Retrying addToCart: $e'),
      );

      print('Add to Cart API Request: $url, Body: $body');
      print(
          'Add to Cart API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        await fetchCart();
        Get.snackbar(
          'Added to Cart',
          '${item.name} has been added to your cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'Failed to add ${item.name} to cart';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        _showErrorSnackBar(errorMessage.value);
        cartItems.removeWhere((i) => i.foodId == item.foodId);
        await fetchCart();
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Error: $e');
      cartItems.removeWhere((i) => i.foodId == item.foodId);
      await fetchCart();
    }
  }

  Future<void> fetchCart() async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/getCart');

    try {
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => http.get(
          url,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying fetchCart: $e'),
      );

      print('Fetch Cart API Request: $url');
      print(
          'Fetch Cart API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final cartData = jsonResponse['cart'];
        if (cartData == null) {
          errorMessage.value = 'Cart data is missing in response';
          _showErrorSnackBar(errorMessage.value);
          cartItems.clear();
          totalAmount.value = 0.0;
          return;
        }

        final List<dynamic> items = cartData['items'] ?? [];
        cartItems.assignAll(
          items
              .map((item) {
                try {
                  return CartItem.fromJson(item);
                } catch (e) {
                  print('Error parsing cart item: $item, Error: $e');
                  return null;
                }
              })
              .where((item) => item != null)
              .cast<CartItem>()
              .toList(),
        );
        totalAmount.value = (cartData['totalAmount'] is num
            ? cartData['totalAmount'].toDouble()
            : calculateSubtotal());
        cartItems.refresh();

        if (cartItems.isEmpty && items.isNotEmpty) {
          errorMessage.value =
              'Some cart items could not be loaded due to invalid data';
          _showErrorSnackBar(errorMessage.value);
        }
      } else {
        String errorMsg = 'Failed to fetch cart';
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
        cartItems.clear();
        totalAmount.value = 0.0;
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Network Error: $e');
      cartItems.clear();
      totalAmount.value = 0.0;
    }
  }

  Future<void> updateCart(CartItem item) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    if (item.amount < 0) {
      errorMessage.value = 'Invalid quantity: ${item.amount}';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    final originalItem =
        cartItems.firstWhereOrNull((i) => i.foodId == item.foodId);
    final originalAmount = originalItem?.amount ?? 0;

    updatingItemIds.add(item.foodId);
    updatingItemIds.refresh();
    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/cart/update');
    final body = jsonEncode({'foodId': item.foodId, 'quantity': item.amount});

    try {
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => http.post(
          url,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        ),
        onRetry: (e) => print('Retrying updateCart: $e'),
      );

      print('Update Cart API Request: $url, Body: $body');
      print(
          'Update Cart API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;
      updatingItemIds.remove(item.foodId);
      updatingItemIds.refresh();

      if (response.statusCode == 200) {
        final updatedItem =
            cartItems.firstWhereOrNull((i) => i.foodId == item.foodId);
        if (updatedItem != null) {
          updatedItem.amount = item.amount;
          cartItems.refresh();
          _updateTotalAmount();
          Get.snackbar(
            'Cart Updated',
            '${item.name} quantity updated to ${item.amount}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          await fetchCart();
        }
      } else {
        String errorMsg = 'Failed to update ${item.name} quantity';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        _showErrorSnackBar(errorMessage.value);
        if (originalItem != null) {
          originalItem.amount = originalAmount;
          cartItems.refresh();
        }
        if (response.statusCode != 400) {
          await fetchCart();
        }
      }
    } catch (e) {
      isLoading.value = false;
      updatingItemIds.remove(item.foodId);
      updatingItemIds.refresh();
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Error: $e');
      if (originalItem != null) {
        originalItem.amount = originalAmount;
        cartItems.refresh();
      }
      await fetchCart();
    }
  }

  Future<void> removeItem(String foodId) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    final item = cartItems.firstWhereOrNull((item) => item.foodId == foodId);
    if (item == null) return;

    cartItems.removeWhere((item) => item.foodId == foodId);
    cartItems.refresh();
    _updateTotalAmount();
    isLoading.value = true;
    clearError();
    final url =
        Uri.parse('${AppConstants.baseUrl}/api/foods/cart/remove/$foodId');

    try {
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => http.delete(
          url,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying removeItem: $e'),
      );

      print('Remove Item API Request: $url');
      print(
          'Remove Item API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        Get.snackbar(
          'Removed from Cart',
          'Item removed from your cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'Failed to remove item';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        _showErrorSnackBar(errorMessage.value);
        cartItems.add(item);
        cartItems.refresh();
        await fetchCart();
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Error: $e');
      cartItems.add(item);
      cartItems.refresh();
      await fetchCart();
    }
  }

  Future<void> clearCart() async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    final previousItems = List<CartItem>.from(cartItems);
    cartItems.clear();
    totalAmount.value = 0.0;
    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/cart/clear');

    try {
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => http.delete(
          url,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        onRetry: (e) => print('Retrying clearCart: $e'),
      );

      print('Clear Cart API Request: $url');
      print(
          'Clear Cart API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        Get.snackbar(
          'Cart Cleared',
          'Your cart has been cleared',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        String errorMsg = 'Failed to clear cart';
        try {
          final errorData = jsonDecode(response.body);
          errorMsg = errorData['message'] ??
              'Server error (status: ${response.statusCode})';
        } catch (_) {
          errorMsg = 'Failed to parse server response';
        }
        errorMessage.value = errorMsg;
        _showErrorSnackBar(errorMessage.value);
        cartItems.addAll(previousItems);
        await fetchCart();
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Error: $e');
      cartItems.addAll(previousItems);
      await fetchCart();
    }
  }

  void increaseAmount(String foodId) {
    final item = cartItems.firstWhereOrNull((item) => item.foodId == foodId);
    if (item == null || updatingItemIds.contains(foodId)) return;

    item.amount++;
    cartItems.refresh();
    _updateTotalAmount();
    updateCart(item);
  }

  void decreaseAmount(String foodId) {
    final item = cartItems.firstWhereOrNull((item) => item.foodId == foodId);
    if (item == null || updatingItemIds.contains(foodId)) return;

    if (item.amount > 1) {
      item.amount--;
      cartItems.refresh();
      _updateTotalAmount();
      updateCart(item);
    } else {
      removeItem(item.foodId);
    }
  }

  double calculateSubtotal() {
    return cartItems.fold(0.0, (sum, item) => sum + (item.price * item.amount));
  }

  void _updateTotalAmount() {
    totalAmount.value = calculateSubtotal();
  }

  Future<void> placeOrder(
      Map<String, dynamic> deliveryAddress, String paymentMethod) async {
    if (!_isTokenValid(profileController.token.value)) {
      errorMessage.value = 'Session expired. Please log in again.';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    if (cartItems.isEmpty) {
      errorMessage.value = 'Cart is empty';
      _showErrorSnackBar(errorMessage.value);
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/order');
    final body = jsonEncode({
      'items': cartItems
          .map((item) => {'foodId': item.foodId, 'quantity': item.amount})
          .toList(),
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
    });

    try {
      final response = await RetryOptions(
              maxAttempts: 3, delayFactor: const Duration(seconds: 2))
          .retry(
        () => http.post(
          url,
          headers: {
            'Authorization': 'Bearer ${profileController.token.value}',
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
      isLoading.value = false;

      if (response.statusCode == 200) {
        cartItems.clear();
        totalAmount.value = 0.0;
        Get.snackbar(
          'Order Placed',
          'Your order has been successfully placed!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed('/order-confirmation');
      } else {
        String errorMsg = 'Failed to place order';
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
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      _showErrorSnackBar(errorMessage.value);
      print('Error: $e');
    }
  }
}
