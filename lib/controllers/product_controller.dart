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
  final RxInt selectedImageIndex = 0.obs;
  final RxInt quantity = 1.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load products only if token is available
    if (profileController.token.value.isNotEmpty) {
      loadFeaturedProducts();
    } else {
      // Optionally, redirect to login or show a message
      errorMessage.value = 'Please log in to view products';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          "Authentication Required",
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    }
  }

  Future<void> loadFeaturedProducts() async {
    if (profileController.token.value.isEmpty) {
      errorMessage.value = 'No authentication token available';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          "Error",
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://c5bb3b297311.ngrok-free.app/api/foods'),
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
        featuredProducts.addAll(data.map((item) {
          final image = item['image'] ?? '';
          print('Product image URL: $image');
          return FeaturedProduct(
            id: item['_id']?.toString() ?? item['id']?.toString() ?? '',
            name: item['name'] ?? 'Unknown',
            description: item['description'] ?? '',
            category: item['category'] ?? 'Unknown',
            price: (item['price'] is int
                    ? (item['price'] as int).toDouble()
                    : item['price']) ??
                0.0,
            image: _isValidUrl(image) ? image : '',
            preparationTime: item['preparationTime']?.toInt() ?? 0,
            averageRating: (item['averageRating'] is int
                    ? (item['averageRating'] as int).toDouble()
                    : item['averageRating']) ??
                0.0,
            ratingCount: item['ratingCount']?.toInt() ?? 0,
            restaurantId: item['restaurantId']?.toString(),
            city: item['city'] ?? '',
            isFavorite: false,
            images: List<String>.from(item['images'] ?? []),
            deliveryInfo: item['deliveryInfo'],
            returnPolicy: item['returnPolicy'],
            nutritionalInfo: item['nutritionalInfo'],
          );
        }).toList());
      } else {
        errorMessage.value = 'Failed to fetch products: ${response.statusCode}';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            "Error",
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        });
      }
    } catch (e) {
      errorMessage.value = 'Error fetching products: $e';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          "Error",
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    } finally {
      isLoading.value = false;
    }
  }

  bool _isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath == true &&
        (url.startsWith('http://') || url.startsWith('https://'));
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

  void addToCart(FeaturedProduct product) {
    Get.snackbar(
      "Added to Cart",
      "${product.name} has been added to your cart",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void toggleFavorite(FeaturedProduct product) {
    product.isFavorite = !product.isFavorite;
    isFavorite.value = product.isFavorite;
    if (product.isFavorite) {
      if (!favoriteProducts.contains(product)) {
        favoriteProducts.add(product);
      }
    } else {
      favoriteProducts.remove(product);
    }
    update(); // Notify listeners for UI updates
  }
}
