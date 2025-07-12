// ProductController
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProductController extends GetxController {
  // Observable for selected image index
  var selectedImageIndex = 0.obs;

  // Observable for favorite status
  var isFavorite = false.obs;

  // Observable for selected navigation index
  var selectedNavIndex = 0.obs;

  // Observable list for featured products
  final RxList<FeaturedProduct> featuredProducts = <FeaturedProduct>[
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
  ].obs;

  // Observable for product quantity
  var quantity = 5.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with static data
    loadFeaturedProducts();
  }

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

  // Navigate to product detail screen
  void onProductTap(FeaturedProduct product) {
    Get.to(ProductDetailScreen(), arguments: product);
  }

  // Load featured products with static data
  void loadFeaturedProducts() {
    featuredProducts.clear(); // Prevent duplicates
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

  // Decrease product quantity
  void decreaseQuantity() {
    if (quantity > 1) quantity--;
  }

  // Increase product quantity
  void increaseQuantity() {
    quantity++;
  }

  // Change selected image index
  void changeImage(int index) {
    selectedImageIndex.value = index;
  }

  // Navigate to next image
  void nextImage() {
    selectedImageIndex.value++;
    if (selectedImageIndex.value > 2) selectedImageIndex.value = 0;
  }

  // Navigate to previous image
  void previousImage() {
    selectedImageIndex.value--;
    if (selectedImageIndex.value < 0) selectedImageIndex.value = 2;
  }
}
