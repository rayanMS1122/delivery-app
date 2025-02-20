import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  // List of featured products

  final RxList<FeaturedProduct> featuredProducts = <FeaturedProduct>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Load featured products (you can replace this with API calls or local data)
    loadFeaturedProducts();
  }

  void onProductTap(FeaturedProduct product) {
    // Navigate to a product detail screen or show a dialog
    Get.toNamed('/product-detail', arguments: product);
  }

  void loadFeaturedProducts() {
    // Example data
    featuredProducts.addAll([
      FeaturedProduct(
        title: "Veggie\ntomato mix",
        price: "N1,900",
        image: "assets/Mask Group.png",
      ),
      FeaturedProduct(
        title: "Spicy \nfish sauce",
        price: "N1,1900",
        image: "assets/Mask Group (1).png",
      ),
    ]);
  }
}

class FeaturedProduct {
  final String title;
  final String price;
  final String image;

  FeaturedProduct({
    required this.title,
    required this.price,
    required this.image,
  });
}
