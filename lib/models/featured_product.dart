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
  bool isFavorite; // Client-side state, not from API
  final List<String>
      images; // Optional, not in API but kept for UI compatibility
  final String? deliveryInfo; // Optional, not in API
  final String? returnPolicy; // Optional, not in API
  final Map<String, String>? nutritionalInfo; // Optional, not in API

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
}
