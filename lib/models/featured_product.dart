class FeaturedProduct {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String image;
  final int preparationTime;
  final double averageRating;
  final int ratingCount;
  final String? restaurantId;
  final String? city;
  bool isFavorite;
  final List<String> images;
  final String? deliveryInfo;
  final String? returnPolicy;
  final Map<String, String>? nutritionalInfo;

  FeaturedProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.image,
    required this.preparationTime,
    required this.averageRating,
    required this.ratingCount,
    this.restaurantId,
    this.city,
    this.isFavorite = false,
    this.images = const [],
    this.deliveryInfo,
    this.returnPolicy,
    this.nutritionalInfo,
  });

  /// 🟩 FROM JSON
  factory FeaturedProduct.fromJson(Map<String, dynamic> json) {
    return FeaturedProduct(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      preparationTime: json['preparationTime'] ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] ?? 0,
      restaurantId: json['restaurantId'],
      city: json['city'],
      isFavorite: json['isFavorite'] ?? false,
      images: List<String>.from(json['images'] ?? []),
      deliveryInfo: json['deliveryInfo'],
      returnPolicy: json['returnPolicy'],
      nutritionalInfo: (json['nutritionalInfo'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      ),
    );
  }

  /// 🟦 TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image': image,
      'preparationTime': preparationTime,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'restaurantId': restaurantId,
      'city': city,
      'isFavorite': isFavorite,
      'images': images,
      'deliveryInfo': deliveryInfo,
      'returnPolicy': returnPolicy,
      'nutritionalInfo': nutritionalInfo,
    };
  }
}
