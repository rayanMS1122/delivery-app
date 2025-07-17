import 'package:delivery_app/models/featured_product.dart';

class CartItem {
  final String id; // Maps to foodId
  final String image;
  final String name;
  final double price;
  int amount; // Maps to quantity

  CartItem({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    this.amount = 1,
  });

  // Convert to JSON for POST /add-to-cart
  Map<String, dynamic> toJson() => {
        'foodId': id,
        'quantity': amount,
      };

  // Create from FeaturedProduct
  factory CartItem.fromFeaturedProduct(FeaturedProduct product,
      {int amount = 1}) {
    return CartItem(
      id: product.id,
      image: product.image,
      name: product.name,
      price: product.price,
      amount: amount,
    );
  }

  // Create from JSON (for GET /get-cart response)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['foodId']?.toString() ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? 'Unknown',
      price: (json['price'] is int
              ? (json['price'] as int).toDouble()
              : json['price']) ??
          0.0,
      amount: json['quantity']?.toInt() ?? 1,
    );
  }
}
