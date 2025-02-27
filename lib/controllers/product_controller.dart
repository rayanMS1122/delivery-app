import 'package:delivery_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  // Observable for selected image index
  var selectedImageIndex = 0.obs;

  // Observable for favorite status
  var isFavorite = false.obs;

  // Method to toggle favorite status
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  // Method to add product to cart
  void addToCart() {
    Get.snackbar(
      'Success',
      'Item added to cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  final RxList<FeaturedProduct> featuredProducts = <FeaturedProduct>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Load featured products (you can replace this with API calls or local data)
    loadFeaturedProducts();
  }

  void onProductTap(FeaturedProduct product) {
    // Navigate to a product detail screen or show a dialog
    Get.to(ProductDetailScreen(), arguments: product);
  }

  void loadFeaturedProducts() {
    // Example data
    featuredProducts.addAll([
      FeaturedProduct(
        name: "Veggie\ntomato mix",
        price: "N1,900",
        image: "assets/Mask Group.png",
      ),
      FeaturedProduct(
        name: "Spicy \nfish sauce",
        price: "N1,1900",
        image: "assets/Mask Group (1).png",
      ),
    ]);
  }
}

class FeaturedProduct {
  final String name;
  final String price;
  final String image;

  FeaturedProduct({
    required this.name,
    required this.price,
    required this.image,
  });
}
