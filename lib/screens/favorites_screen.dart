import 'package:delivery_app/controllers/favorites_controller.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  final FavoritesController favoritesController =
      Get.put<FavoritesController>(FavoritesController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final RxBool isFilterVisible = false.obs;
  final RxString selectedCategory = 'All'.obs;
  final Rx<RangeValues> priceRange = const RangeValues(0, 50).obs;
  final RxString sortBy = 'rating'.obs;
  final RxString sortOrder = 'desc'.obs;
  final List<String> categories = [
    'All',
    'Fast Food',
    'Italian',
    'Healthy',
    'Dessert',
  ];
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void toggleFilter() {
    isFilterVisible.value = !isFilterVisible.value;
    if (isFilterVisible.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void resetFilters() {
    selectedCategory.value = 'All';
    priceRange.value = const RangeValues(0, 50);
    sortBy.value = 'rating';
    sortOrder.value = 'desc';
    searchController.clear();
    isSearching.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const Color mainColor = Color(0xFFFA4A0C);
    final backgroundColor = Colors.grey.shade50;
    final horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: screenWidth,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFA4A0C), Color(0xFFFF6E40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Text(
                            "My Favorites",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: Obx(() => Icon(
                                  isFilterVisible.value
                                      ? Icons.close
                                      : Icons.filter_list,
                                  color: Colors.white,
                                )),
                            onPressed: toggleFilter,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          isSearching.value = value.isNotEmpty;
                          favoritesController.fetchFavorites(
                            searchQuery: value,
                            category: selectedCategory.value == 'All'
                                ? null
                                : selectedCategory.value,
                            minPrice: priceRange.value.start,
                            maxPrice: priceRange.value.end,
                            sortBy: sortBy.value,
                            order: sortOrder.value,
                          );
                        },
                        style: GoogleFonts.poppins(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Search your favorites...",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(
                              Icons.search,
                              color: mainColor,
                              size: 26,
                            ),
                          ),
                          suffixIcon: Obx(() => isSearching.value
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: mainColor,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      searchController.clear();
                                      isSearching.value = false;
                                      favoritesController.fetchFavorites();
                                    },
                                  ),
                                )
                              : const SizedBox.shrink()),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: horizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                          "${favoritesController.favoriteItems.length} items saved",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        )),
                    Row(
                      children: [
                        Icon(
                          Icons.sort,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 5),
                        Obx(() => Text(
                              "Sort by ${sortBy.value.capitalizeFirst}",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (favoritesController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (favoritesController.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            favoritesController.errorMessage.value,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: favoritesController.fetchFavorites,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              "Retry",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final filteredItems =
                      favoritesController.favoriteItems.where((item) {
                    bool matchesSearch = searchQuery.isEmpty ||
                        item.name
                            .toLowerCase()
                            .contains(searchQuery.value.toLowerCase());
                    bool matchesCategory = selectedCategory.value == 'All' ||
                        item.category == selectedCategory.value;
                    bool matchesPrice = item.price >= priceRange.value.start &&
                        item.price <= priceRange.value.end;
                    return matchesSearch && matchesCategory && matchesPrice;
                  }).toList();

                  if (filteredItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            "No favorites found",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: screenWidth * 0.7,
                            alignment: Alignment.center,
                            child: Text(
                              searchQuery.isNotEmpty
                                  ? "We couldn't find any matches for '${searchQuery.value}'"
                                  : "Items you mark as favorite will appear here",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              shadowColor: mainColor.withOpacity(0.5),
                            ),
                            child: Text(
                              "Browse Menu",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding, vertical: 15),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return GestureDetector(
                              onTap: () {
                                selectedCategory.value = category;
                                favoritesController.fetchFavorites(
                                  category: category == 'All' ? null : category,
                                  minPrice: priceRange.value.start,
                                  maxPrice: priceRange.value.end,
                                  sortBy: sortBy.value,
                                  order: sortOrder.value,
                                );
                              },
                              child: Obx(() {
                                final isSelected =
                                    selectedCategory.value == category;
                                return Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected ? mainColor : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? mainColor.withOpacity(0.3)
                                            : Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    category,
                                    style: GoogleFonts.poppins(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding, vertical: 10),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return RedesignedFavoriteItemCard(
                              item: item,
                              onRemove: () =>
                                  favoritesController.removeFavorite(item.id),
                              onAdd: () =>
                                  favoritesController.addFavoriteToCart(item),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 0,
            child: SizeTransition(
              sizeFactor: _animation,
              axis: Axis.horizontal,
              axisAlignment: 1,
              child: Container(
                width: screenWidth * 0.75,
                height: screenHeight * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(-5, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Filter Options",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(15),
                        children: [
                          Text(
                            "Sort By",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildFilterOption(
                            "Price: Low to High",
                            Icons.arrow_upward,
                            () {
                              sortBy.value = 'price';
                              sortOrder.value = 'asc';
                              favoritesController.fetchFavorites(
                                category: selectedCategory.value == 'All'
                                    ? null
                                    : selectedCategory.value,
                                minPrice: priceRange.value.start,
                                maxPrice: priceRange.value.end,
                                sortBy: sortBy.value,
                                order: sortOrder.value,
                              );
                            },
                          ),
                          _buildFilterOption(
                            "Price: High to Low",
                            Icons.arrow_downward,
                            () {
                              sortBy.value = 'price';
                              sortOrder.value = 'desc';
                              favoritesController.fetchFavorites(
                                category: selectedCategory.value == 'All'
                                    ? null
                                    : selectedCategory.value,
                                minPrice: priceRange.value.start,
                                maxPrice: priceRange.value.end,
                                sortBy: sortBy.value,
                                order: sortOrder.value,
                              );
                            },
                          ),
                          _buildFilterOption(
                            "Rating",
                            Icons.star_border,
                            () {
                              sortBy.value = 'averageRating';
                              sortOrder.value = 'desc';
                              favoritesController.fetchFavorites(
                                category: selectedCategory.value == 'All'
                                    ? null
                                    : selectedCategory.value,
                                minPrice: priceRange.value.start,
                                maxPrice: priceRange.value.end,
                                sortBy: sortBy.value,
                                order: sortOrder.value,
                              );
                            },
                          ),
                          _buildFilterOption(
                            "Name",
                            Icons.sort_by_alpha,
                            () {
                              sortBy.value = 'name';
                              sortOrder.value = 'asc';
                              favoritesController.fetchFavorites(
                                category: selectedCategory.value == 'All'
                                    ? null
                                    : selectedCategory.value,
                                minPrice: priceRange.value.start,
                                maxPrice: priceRange.value.end,
                                sortBy: sortBy.value,
                                order: sortOrder.value,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Price Range",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Obx(() => Column(
                                children: [
                                  SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: mainColor,
                                      inactiveTrackColor: Colors.grey.shade200,
                                      thumbColor: mainColor,
                                      overlayColor: mainColor.withOpacity(0.2),
                                      valueIndicatorColor: mainColor,
                                      valueIndicatorTextStyle:
                                          GoogleFonts.poppins(
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: RangeSlider(
                                      values: priceRange.value,
                                      min: 0,
                                      max: 50,
                                      divisions: 50,
                                      labels: RangeLabels(
                                        '\$${priceRange.value.start.toStringAsFixed(0)}',
                                        '\$${priceRange.value.end.toStringAsFixed(0)}',
                                      ),
                                      onChanged: (values) {
                                        priceRange.value = values;
                                      },
                                      onChangeEnd: (values) {
                                        favoritesController.fetchFavorites(
                                          category:
                                              selectedCategory.value == 'All'
                                                  ? null
                                                  : selectedCategory.value,
                                          minPrice: values.start,
                                          maxPrice: values.end,
                                          sortBy: sortBy.value,
                                          order: sortOrder.value,
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${priceRange.value.start.toStringAsFixed(0)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          '\$${priceRange.value.end.toStringAsFixed(0)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                resetFilters();
                                favoritesController.fetchFavorites();
                                toggleFilter();
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                side: BorderSide(color: mainColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                "Reset",
                                style: GoogleFonts.poppins(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                favoritesController.fetchFavorites(
                                  category: selectedCategory.value == 'All'
                                      ? null
                                      : selectedCategory.value,
                                  minPrice: priceRange.value.start,
                                  maxPrice: priceRange.value.end,
                                  sortBy: sortBy.value,
                                  order: sortOrder.value,
                                );
                                toggleFilter();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                "Apply",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RedesignedFavoriteItemCard extends StatelessWidget {
  final FeaturedProduct item;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  const RedesignedFavoriteItemCard({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFFFA4A0C);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Get.toNamed('/product-detail', arguments: item);
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 140,
                      color: Colors.grey.shade100,
                      child: item.image.isNotEmpty &&
                              Uri.tryParse(item.image)?.hasAbsolutePath == true
                          ? Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                        : null,
                                    color: mainColor,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.restaurant,
                                size: 60,
                                color: mainColor.withOpacity(0.3),
                              ),
                            )
                          : Icon(
                              Icons.restaurant,
                              size: 60,
                              color: mainColor.withOpacity(0.3),
                            ),
                    ),
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.category ?? 'Unknown',
                          style: GoogleFonts.poppins(
                            fontSize: 12 * textScaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: mainColor,
                            size: 22,
                          ),
                          onPressed: onRemove,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18 * textScaleFactor,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.averageRating.toStringAsFixed(1),
                                  style: GoogleFonts.poppins(
                                    fontSize: 13 * textScaleFactor,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16 * textScaleFactor,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.restaurantName ??
                                item.restaurantId ??
                                'Unknown',
                            style: GoogleFonts.poppins(
                              fontSize: 14 * textScaleFactor,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${item.price.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontSize: 18 * textScaleFactor,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: onAdd,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            icon: const Icon(Icons.add_shopping_cart, size: 18),
                            label: Text(
                              "Add",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
