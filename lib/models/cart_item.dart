import 'package:delivery_app/models/featured_product.dart';

class CartItem {
  final String id; // Maps to _id (cart item ID)
  final String foodId; // Maps to foodId._id
  final String image;
  final String name;
  final double price;
  int amount; // Maps to quantity
  final String? restaurantId;
  final String? restaurantName;

  CartItem({
    required this.id,
    required this.foodId,
    required this.image,
    required this.name,
    required this.price,
    this.amount = 1,
    this.restaurantId,
    this.restaurantName,
  });

  // Convert to JSON for POST /add-to-cart and /update
  Map<String, dynamic> toJson() => {
        'foodId': foodId,
        'quantity': amount,
      };

  // Create from FeaturedProduct
  factory CartItem.fromFeaturedProduct(FeaturedProduct product,
      {int amount = 1}) {
    return CartItem(
      id: '', // ID will be set by backend after adding to cart
      foodId: product.id ?? '',
      image: product.image ?? '',
      name: product.name ?? 'Unknown Item',
      price: product.price is num ? product.price.toDouble() : 0.0,
      amount: amount,
      restaurantId: product.restaurantId,
      restaurantName: product.restaurantName,
    );
  }

  // Create from JSON (for GET /get-cart response)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    final foodIdData = json['foodId'] as Map<String, dynamic>? ?? {};
    return CartItem(
      id: json['_id']?.toString() ?? '',
      foodId: foodIdData['_id']?.toString() ?? '',
      image: foodIdData['image']?.toString() ?? json['image']?.toString() ?? '',
      name: foodIdData['name']?.toString() ??
          json['name']?.toString() ??
          'Unknown Item',
      price: (foodIdData['price'] is num
          ? foodIdData['price'].toDouble()
          : json['price'] is num
              ? json['price'].toDouble()
              : 0.0),
      amount: json['quantity'] is num ? json['quantity'].toInt() : 1,
      restaurantId: foodIdData['restaurantId']?.toString() ??
          json['restaurantId']?.toString(),
      restaurantName: foodIdData['restaurantName']?.toString() ??
          json['restaurantName']?.toString(),
    );
  }
}
