import 'package:get/get.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull

class CartController extends GetxController {
  // List of cart items
  var cartItems = <CartItem>[
    CartItem(
      id: "1",
      image: "assets/Mask Group.png",
      title: "Veggie tomato mix",
      price: 222,
      amount: 5,
    )
  ].obs;

  // Add item to cart
  void addItem(CartItem item) {
    cartItems.add(item);
  }

  // Remove item from cart
  void removeItem(String id) {
    cartItems.removeWhere((item) => item.id == id);
  }

  // Get the amount of a specific item
  int getItemAmount(String id) {
    final item = cartItems.firstWhereOrNull((item) => item.id == id);
    return item?.amount ?? 1; // Default amount is 1 if item is not found
  }

  // Increase the amount of an item
  void increaseAmount(String id) {
    final item = cartItems.firstWhereOrNull((item) => item.id == id);
    if (item != null) {
      item.amount++;
      cartItems.refresh(); // Notify listeners
    }
  }

  // Decrease the amount of an item
  void decreaseAmount(String id) {
    final item = cartItems.firstWhereOrNull((item) => item.id == id);
    if (item != null && item.amount > 1) {
      item.amount--;
      cartItems.refresh(); // Notify listeners
    }
  }

  // Get the total price of all items in the cart
  int get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.amount));
  }
}

class CartItem {
  final String id;
  final String image;
  final String title;
  final int price;
  int amount; // Make amount mutable

  CartItem({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.amount,
  });
}
