class FeaturedProduct {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String image;
  final int? preparationTime; // Made optional
  final double averageRating;
  final int ratingCount;
  final String? restaurantId;
  final String? restaurantName; // Added
  final String? city;
  bool isFavorite;
  final List<String> images;
  final String? deliveryInfo;
  final String? returnPolicy;
  final NutritionalInfo? nutritionalInfo;
  final List<String> ingredients;
  final bool isAvailable;

  FeaturedProduct(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.price,
      required this.image,
      this.preparationTime,
      required this.averageRating,
      required this.ratingCount,
      this.restaurantId,
      this.restaurantName,
      this.city,
      this.isFavorite = false,
      this.images = const [],
      this.deliveryInfo,
      this.returnPolicy,
      this.nutritionalInfo,
      this.ingredients = const [],
      required this.isAvailable});

  FeaturedProduct copyWith({bool? isFavorite}) {
    return FeaturedProduct(
      id: id,
      name: name,
      description: description,
      category: category,
      price: price,
      image: image,
      preparationTime: preparationTime,
      isAvailable: isAvailable,
      restaurantId: restaurantId,
      city: city,
      isFavorite: isFavorite ?? this.isFavorite,
      averageRating: averageRating,
      ingredients: ingredients,
      nutritionalInfo: nutritionalInfo,
      ratingCount: 1,
    );
  }

  /// 🟩 FROM JSON
  factory FeaturedProduct.fromJson(Map<String, dynamic> json) {
    return FeaturedProduct(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Unknown',
      price: (json['price'] is num ? json['price'].toDouble() : 0.0),
      image: json['image']?.toString() ?? '',
      preparationTime: (json['preparationTime'] is num
          ? json['preparationTime'].toInt()
          : null),
      averageRating: (json['averageRating'] is num
          ? json['averageRating'].toDouble()
          : 0.0),
      ratingCount:
          (json['ratingCount'] is num ? json['ratingCount'].toInt() : 0),
      restaurantId: json['restaurantId']?.toString(),
      restaurantName: json['restaurantName']?.toString(),
      city: json['city']?.toString(),
      isFavorite: json['isFavorite'] == true,
      isAvailable: json['isAvailable'] == true,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      deliveryInfo: json['deliveryInfo']?.toString(),
      returnPolicy: json['returnPolicy']?.toString(),
      nutritionalInfo: json['nutritionalInfo'] != null
          ? NutritionalInfo.fromJson(
              json['nutritionalInfo'] as Map<String, dynamic>)
          : null,
      ingredients:
          (json['ingredients'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// 🟦 TO JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
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
      'restaurantName': restaurantName,
      'city': city,
      'isFavorite': isFavorite,
      'images': images,
      'deliveryInfo': deliveryInfo,
      'returnPolicy': returnPolicy,
      'nutritionalInfo': nutritionalInfo?.toJson(),
      'ingredients': ingredients,
      "isAvailable": isAvailable
    };
  }
}

class NutritionalInfo {
  final int calories;
  final int protein;
  final int fat;
  final int carbohydrates;

  NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
  });

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      calories: (json['calories'] is num ? json['calories'].toInt() : 0),
      protein: (json['protein'] is num ? json['protein'].toInt() : 0),
      fat: (json['fat'] is num ? json['fat'].toInt() : 0),
      carbohydrates:
          (json['carbohydrates'] is num ? json['carbohydrates'].toInt() : 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbohydrates': carbohydrates,
    };
  }
}
