import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  // Mock data for favorite items
  final List<Map<String, dynamic>> favoritesData = [
    {
      'name': 'Spicy Chicken Burger',
      'restaurant': 'Burger Express',
      'price': 12.99,
      'rating': 4.8,
      'image': 'assets/images/burger.png',
      'category': 'Fast Food',
    },
    {
      'name': 'Margherita Pizza',
      'restaurant': 'Pizza Heaven',
      'price': 14.50,
      'rating': 4.5,
      'image': 'assets/images/pizza.png',
      'category': 'Italian',
    },
    {
      'name': 'Fresh Veggie Salad',
      'restaurant': 'Green Basket',
      'price': 9.99,
      'rating': 4.6,
      'image': 'assets/images/salad.png',
      'category': 'Healthy',
    },
    {
      'name': 'Chocolate Milkshake',
      'restaurant': 'Sweet Treats',
      'price': 7.50,
      'rating': 4.7,
      'image': 'assets/images/milkshake.png',
      'category': 'Dessert',
    },
  ];

  // Categories for filtering
  final List<String> categories = [
    'All',
    'Fast Food',
    'Italian',
    'Healthy',
    'Dessert'
  ];
  String selectedCategory = 'All';

  // Controller for search functionality
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final RxBool isFilterVisible = false.obs;

  // Animation controller for filter panel
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });

    // Initialize animation controller
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

  // Toggle filter visibility
  void toggleFilter() {
    isFilterVisible.value = !isFilterVisible.value;
    if (isFilterVisible.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Main brand color
    const Color mainColor = Color(0xFFFA4A0C);

    // Background color
    final backgroundColor = Colors.grey.shade50;

    // Responsive paddings
    final horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Top curved section with brand color
              Container(
                width: screenWidth,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  color: mainColor,
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
                    // App bar with back button, title and filter icon
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // IconButton(
                          //   icon: const Icon(
                          //     Icons.arrow_back_ios,
                          //     color: Colors.white,
                          //   ),
                          //   onPressed: () => Get.back(),
                          // ),
                          Container(),
                          const Text(
                            "My Favorites",
                            style: TextStyle(
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

                    // Search bar with shadow effect
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
                        onChanged: (value) =>
                            isSearching.value = value.isNotEmpty,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search your favorites...",
                          hintStyle: TextStyle(
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

              // Stats bar
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
                    Text(
                      "${favoritesData.length} items saved",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.sort,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Sort by rating",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Obx(() {
                  final filteredItems = favoritesData.where((item) {
                    bool matchesSearch = searchQuery.isEmpty ||
                        item['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchQuery.value.toLowerCase());
                    bool matchesCategory = selectedCategory == 'All' ||
                        item['category'] == selectedCategory;
                    return matchesSearch && matchesCategory;
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
                            style: TextStyle(
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
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to menu
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
                            child: const Text(
                              "Browse Menu",
                              style: TextStyle(
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
                      // Category chips if there are results
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding, vertical: 15),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = selectedCategory == category;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? mainColor : Colors.white,
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
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Food items
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: 10,
                          ),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return RedesignedFavoriteItemCard(
                              item: item,
                              onRemove: () {
                                setState(() {
                                  favoritesData.removeWhere((element) =>
                                      element['name'] == item['name']);
                                });
                              },
                              onAdd: () {
                                // Add to cart functionality
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("${item['name']} added to cart"),
                                    backgroundColor: mainColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom: 70,
                                      left: 15,
                                      right: 15,
                                    ),
                                  ),
                                );
                              },
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

          // Filter drawer - animated
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 0,
            child: SizeTransition(
              sizeFactor: _animation,
              axis: Axis.horizontal,
              axisAlignment: 1,
              child: Container(
                width: screenWidth * 0.75,
                height: screenHeight * 0.35,
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
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Filter Options",
                        style: TextStyle(
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
                          const Text(
                            "Sort By",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildFilterOption(
                              "Price: Low to High", Icons.arrow_upward),
                          _buildFilterOption(
                              "Price: High to Low", Icons.arrow_downward),
                          _buildFilterOption("Rating", Icons.star_border),
                          _buildFilterOption("Name", Icons.sort_by_alpha),
                          const SizedBox(height: 20),
                          const Text(
                            "Price Range",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: mainColor,
                              inactiveTrackColor: Colors.grey.shade200,
                              thumbColor: mainColor,
                              overlayColor: mainColor.withOpacity(0.2),
                            ),
                            child: RangeSlider(
                              values: const RangeValues(5, 20),
                              min: 0,
                              max: 30,
                              labels: const RangeLabels('', ''),
                              onChanged: (values) {
                                // Update price range
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: toggleFilter,
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
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: toggleFilter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Apply",
                                style: TextStyle(
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

      // Custom bottom navigation cart button
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      // floatingActionButton: Container(
      //   height: 55,
      //   margin: const EdgeInsets.symmetric(horizontal: 20),
      //   child: ElevatedButton.icon(
      //     onPressed: () {
      //       // Navigate to cart
      //     },
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: mainColor,
      //       foregroundColor: Colors.white,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(30),
      //       ),
      //       elevation: 5,
      //       shadowColor: mainColor.withOpacity(0.5),
      //       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      //     ),
      //     icon: const Icon(Icons.shopping_bag_outlined),
      //     label: const Text(
      //       "View Cart",
      //       style: TextStyle(
      //         fontWeight: FontWeight.bold,
      //         fontSize: 16,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Radio(
            value: title,
            groupValue: "",
            onChanged: (value) {},
            activeColor: const Color(0xFFFA4A0C),
          ),
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class RedesignedFavoriteItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
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
    // Main brand color
    const Color mainColor = Color(0xFFFA4A0C);

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
              // Navigate to item details
            },
            child: Column(
              children: [
                // Food Image Section
                Stack(
                  children: [
                    // Food image placeholder
                    Container(
                      width: double.infinity,
                      height: 140,
                      color: Colors.grey.shade100,
                      child: Icon(
                        Icons.restaurant,
                        size: 60,
                        color: mainColor.withOpacity(0.3),
                      ),
                    ),

                    // Category badge
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
                          item['category'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),

                    // Favorite button
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

                // Food details
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
                              item['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Rating
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
                                  item['rating'].toString(),
                                  style: TextStyle(
                                    fontSize: 13,
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

                      // Restaurant name
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['restaurant'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Price and add to cart button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price
                          Text(
                            "\$${item['price'].toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),

                          // Add to cart button
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
                            label: const Text(
                              "Add",
                              style: TextStyle(
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
