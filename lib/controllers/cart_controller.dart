import 'dart:convert';
import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/models/cart_item.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

class CartController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  var cartItems = <CartItem>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final quantity = 1.obs; // For ProductDetailScreen quantity management

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Add item to cart (local and backend)
  Future<void> addToCart(FeaturedProduct product, {int amount = 1}) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to add items to cart';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    final cartItem = CartItem.fromFeaturedProduct(product, amount: amount);
    final existingItem =
        cartItems.firstWhereOrNull((item) => item.id == product.id);

    if (existingItem != null) {
      existingItem.amount += amount;
      cartItems.refresh();
      await updateCart(existingItem);
    } else {
      cartItems.add(cartItem);
      await _addToCartBackend(cartItem);
    }

    Get.snackbar(
      'Added to Cart',
      '${product.name} has been added to your cart',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Backend: POST /api/foods/cart/add
  Future<void> _addToCartBackend(CartItem item) async {
    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/cart/add');
    final body = jsonEncode(item.toJson());

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
          'Add to Cart API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        print('Added to cart: ${item.name}');
      } else {
        String errorMsg = 'Failed to add to cart';
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
        cartItems.removeWhere((i) => i.id == item.id); // Revert local change
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value);
      print('Error: $e');
      cartItems.removeWhere((i) => i.id == item.id); // Revert local change
    }
  }

  // Backend: GET /api/foods/getCart
  Future<void> fetchCart() async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to view cart';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/getCart');

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
          'Fetch Cart API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['cart'] ?? [];
        cartItems.value = data.map((item) => CartItem.fromJson(item)).toList();
      } else {
        String errorMsg = 'Failed to fetch cart';
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

  // Backend: POST /api/foods/cart/update
  Future<void> updateCart(CartItem item) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to update cart';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/cart/update');
    final body = jsonEncode(item.toJson());

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
          'Update Cart API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode != 200) {
        String errorMsg = 'Failed to update cart';
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

  // Backend: DELETE /api/foods/cart/remove/<id>
  Future<void> removeItem(String id) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to remove item from cart';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    final item = cartItems.firstWhereOrNull((item) => item.id == id);
    if (item == null) return;

    cartItems.removeWhere((item) => item.id == id);
    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/cart/remove/$id');

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
          'Remove Item API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode != 200) {
        String errorMsg = 'Failed to remove item';
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
        cartItems.add(item); // Revert local change
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value);
      print('Error: $e');
      cartItems.add(item); // Revert local change
    }
  }

  // Backend: DELETE /api/foods/cart/clear
  Future<void> clearCart() async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'Please log in to clear cart';
      Get.snackbar('Error', errorMessage.value);
      return;
    }

    final previousItems = List<CartItem>.from(cartItems);
    cartItems.clear();
    isLoading.value = true;
    clearError();
    final url = Uri.parse('${AppConstants.baseUrl}/api/foods/cart/clear');

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
          'Clear Cart API Response: ${response.statusCode} - ${response.body}');
      isLoading.value = false;

      if (response.statusCode != 200) {
        String errorMsg = 'Failed to clear cart';
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
        cartItems.addAll(previousItems); // Revert local change
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Network error: Unable to connect to server';
      Get.snackbar('Error', errorMessage.value);
      print('Error: $e');
      cartItems.addAll(previousItems); // Revert local change
    }
  }

  // Increase item quantity for ProductDetailScreen
  void increaseQuantity() {
    quantity.value++;
  }

  // Decrease item quantity for ProductDetailScreen
  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  // Increase item quantity in cart
  void increaseAmount(String id) {
    final item = cartItems.firstWhereOrNull((item) => item.id == id);
    if (item != null) {
      item.amount++;
      cartItems.refresh();
      updateCart(item);
    }
  }

  // Decrease item quantity in cart
  void decreaseAmount(String id) {
    final item = cartItems.firstWhereOrNull((item) => item.id == id);
    if (item != null && item.amount > 1) {
      item.amount--;
      cartItems.refresh();
      updateCart(item);
    }
  }

  // Calculate total price
  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + (item.price * item.amount));
  }

  // Calculate subtotal
  double calculateSubtotal() {
    return totalPrice;
  }
}
