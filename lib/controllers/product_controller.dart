import 'package:delivery_app/constants.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:delivery_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final RxList<FeaturedProduct> featuredProducts = <FeaturedProduct>[].obs;
  final RxList<FeaturedProduct> favoriteProducts = <FeaturedProduct>[].obs;
  final RxList<dynamic> cartItems = <dynamic>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxInt quantity = 1.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFavorite = false.obs;

  // Basis-URL für die API
  final String baseUrl = '${AppConstants.baseUrl}/api';

  @override
  void onInit() {
    super.onInit();
    if (profileController.token.value.isNotEmpty) {
      loadFeaturedProducts();
      loadFavorites();
      loadCart();
    } else {
      errorMessage.value = 'Please log in to view products';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Helferfunktion für Fehleranzeige mit Login-Option
  void _showErrorSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => Get.offAllNamed('/login'),
          child: Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
    });
  }

  // Lade Speisen mit optionalen Filtern
  Future<void> loadFeaturedProducts({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'No authentication token available';
      _showErrorSnackBar(errorMessage.value);
      return;
    }
    isLoading.value = true;
    try {
      final queryParams = {
        if (category != null) 'category': category,
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
        if (sortBy != null) 'sortBy': sortBy,
        if (order != null) 'order': order,
      };
      final uri =
          Uri.parse('$baseUrl/foods').replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
        },
      );
      print('Products API Response: ${response.body}');
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['foods'] ?? [];
        featuredProducts.clear();
        featuredProducts.addAll(
            data.map((item) => FeaturedProduct.fromJson(item)).toList());
      } else {
        errorMessage.value = 'Failed to fetch products: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error fetching products: $e';
      _showErrorSnackBar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Produkt-Detailseite öffnen
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

  // Speise zum Warenkorb hinzufügen
  Future<void> addToCart(FeaturedProduct product, {int quantity = 1}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/foods/cart/add'),
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'foodId': product.id, 'quantity': quantity}),
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Added to Cart',
          '${product.name} has been added to your cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadCart(); // Warenkorb aktualisieren
      } else {
        errorMessage.value = 'Failed to add to cart: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error adding to cart: $e';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Warenkorb laden
  Future<void> loadCart() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/foods/getCart'),
        headers: {'Authorization': 'Bearer ${profileController.token.value}'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        cartItems.assignAll(jsonResponse['cart'] ?? []);
      } else {
        errorMessage.value = 'Failed to load cart: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error loading cart: $e';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Warenkorb aktualisieren
  Future<void> updateCart(String foodId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/foods/cart/update'),
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'foodId': foodId, 'quantity': quantity}),
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Cart Updated',
          'Cart has been updated',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadCart();
      } else {
        errorMessage.value = 'Failed to update cart: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error updating cart: $e';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Artikel aus Warenkorb entfernen
  Future<void> removeFromCart(String foodId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/foods/cart/remove/$foodId'),
        headers: {'Authorization': 'Bearer ${profileController.token.value}'},
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Removed from Cart',
          'Item has been removed from your cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadCart();
      } else {
        errorMessage.value =
            'Failed to remove from cart: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error removing from cart: $e';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Warenkorb leeren
  Future<void> clearCart() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/foods/cart/clear'),
        headers: {'Authorization': 'Bearer ${profileController.token.value}'},
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Cart Cleared',
          'Your cart has been cleared',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadCart();
      } else {
        errorMessage.value = 'Failed to clear cart: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error clearing cart: $e';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Favoriten laden
  Future<void> loadFavorites() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/foods/favorites'),
        headers: {'Authorization': 'Bearer ${profileController.token.value}'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['favorites'] ?? [];
        favoriteProducts.clear();
        favoriteProducts.addAll(
            data.map((item) => FeaturedProduct.fromJson(item)).toList());
      } else {
        errorMessage.value = 'Failed to load favorites: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error loading favorites: $e';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Favorit togglen
  Future<void> toggleFavorite(FeaturedProduct product) async {
    try {
      final uri = product.isFavorite
          ? Uri.parse('$baseUrl/foods/favorites/remove/${product.id}')
          : Uri.parse('$baseUrl/foods/favorites/add');
      final response = await (product.isFavorite ? http.delete : http.post)(
        uri,
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
        },
        body: product.isFavorite ? null : jsonEncode({'foodId': product.id}),
      );
      if (response.statusCode == 200) {
        product.isFavorite = !product.isFavorite;
        if (product.isFavorite) {
          if (!favoriteProducts.contains(product))
            favoriteProducts.add(product);
        } else {
          favoriteProducts.removeWhere((p) => p.id == product.id);
        }
        update();
      } else {
        errorMessage.value =
            'Failed to update favorite: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error updating favorite: $e';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Bestellung platzieren
  Future<void> placeOrder({
    required String deliveryAddressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/foods/order'),
        headers: {
          'Authorization': 'Bearer ${profileController.token.value}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'items': items,
          'deliveryAddress': {'_id': deliveryAddressId},
          'paymentMethod': paymentMethod,
        }),
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Order Placed',
          'Your order has been successfully placed',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        loadCart(); // Warenkorb nach Bestellung aktualisieren
      } else {
        errorMessage.value = 'Failed to place order: ${response.statusCode}';
        _showErrorSnackBar(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error placing order: $e';
      _showErrorSnackBar(errorMessage.value);
    }
  }

  // Bildnavigation
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

  bool _isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath == true &&
        (url.startsWith('http://') || url.startsWith('https://'));
  }
}
