import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class AdvancedSearchScreen extends StatelessWidget {
  final SearchController _controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive measurements
        final double safeAreaTop = MediaQuery.of(context).padding.top;
        final double horizontalPadding = constraints.maxWidth * 0.05;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF0F0F5),
                  Color(0xFFF8F8FC),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Main Content
                CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverToBoxAdapter(
                      child: _buildAppBar(
                          context, constraints, safeAreaTop, horizontalPadding),
                    ),

                    // Search Bar
                    SliverToBoxAdapter(
                      child: _buildSearchBar(
                          context, constraints, horizontalPadding),
                    ),

                    // Content Area - Adjust spacing dynamically based on content
                    SliverToBoxAdapter(
                      child: SizedBox(height: constraints.maxHeight * 0.05),
                    ),

                    // Dynamic Content (Results or No Results)
                    SliverToBoxAdapter(
                      child: Obx(() {
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: _controller.isSearching.value
                              ? _buildSearchResults(
                                  context, constraints, horizontalPadding)
                              : _buildNoResults(context, constraints),
                        );
                      }),
                    ),

                    // Bottom Spacing
                    SliverToBoxAdapter(
                      child: SizedBox(height: constraints.maxHeight * 0.1),
                    ),
                  ],
                ),

                // Floating Filter Button
                Positioned(
                  bottom: constraints.maxHeight * 0.03,
                  right: constraints.maxWidth * 0.05,
                  child: _buildFloatingActionButton(constraints),
                ),

                // Shimmer Loading Effect (visible during search)
                Obx(() {
                  return _controller.isLoading.value
                      ? _buildLoadingShimmer(constraints, horizontalPadding)
                      : SizedBox.shrink();
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // Modern App Bar with elevated design
  Widget _buildAppBar(BuildContext context, BoxConstraints constraints,
      double safeAreaTop, double horizontalPadding) {
    final double appBarHeight = constraints.maxHeight * 0.08;
    final double minHeight = 60.0;
    final double finalHeight =
        appBarHeight > minHeight ? appBarHeight : minHeight;

    return Container(
      padding: EdgeInsets.only(
        top: safeAreaTop + 8,
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button with Hero Animation
          Hero(
            tag: 'back_button',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(finalHeight * 0.4),
                onTap: () => Get.back(),
                child: Container(
                  height: finalHeight * 0.8,
                  width: finalHeight * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: finalHeight * 0.3,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          // Title with Animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 500),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(20 * (1 - value), 0),
                  child: child,
                ),
              );
            },
            child: Text(
              "Search",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: constraints.maxWidth * 0.055,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Menu Button
          Container(
            height: finalHeight * 0.8,
            width: finalHeight * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(finalHeight * 0.4),
              child: InkWell(
                borderRadius: BorderRadius.circular(finalHeight * 0.4),
                onTap: () {
                  _controller.toggleFilterMenu();
                },
                child: Icon(
                  Icons.tune_rounded,
                  size: finalHeight * 0.3,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced search bar with animation and voice search
  Widget _buildSearchBar(BuildContext context, BoxConstraints constraints,
      double horizontalPadding) {
    final double searchBarHeight = constraints.maxHeight * 0.065;
    final double minHeight = 50.0;
    final double maxHeight = 60.0;
    final double finalHeight = searchBarHeight.clamp(minHeight, maxHeight);

    return Padding(
      padding: EdgeInsets.only(
        top: constraints.maxHeight * 0.01,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      child: Container(
        height: finalHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(finalHeight / 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Icon(
              Icons.search_rounded,
              color: Colors.grey.shade600,
              size: finalHeight * 0.45,
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller.searchTextController,
                focusNode: _controller.searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: constraints.maxWidth * 0.038,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
                style: TextStyle(
                  fontSize: constraints.maxWidth * 0.038,
                  color: Colors.black87,
                ),
                onChanged: (query) {
                  _controller.search(query);
                },
              ),
            ),
            // Clear button
            Obx(() {
              return _controller.searchQuery.isNotEmpty
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(finalHeight * 0.45),
                        onTap: () {
                          _controller.clearSearch();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.grey.shade500,
                            size: finalHeight * 0.35,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink();
            }),
            // Voice search button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(finalHeight * 0.5),
                onTap: () {
                  // Voice search implementation would go here
                  Get.snackbar(
                    'Voice Search',
                    'Voice search activated',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(16),
                    backgroundColor: const Color(0xFFFF460A), // Orange color,
                    colorText: Colors.white,
                  );
                },
                child: Container(
                  width: finalHeight * 0.9,
                  height: finalHeight * 0.9,
                  padding: EdgeInsets.all(finalHeight * 0.2),
                  child: Icon(
                    Icons.mic_rounded,
                    color: const Color(0xFFFF460A), // Orange color,
                    size: finalHeight * 0.45,
                  ),
                ),
              ),
            ),
            SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  // Enhanced no results screen with advanced UI
  Widget _buildNoResults(BuildContext context, BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.08),
      height: constraints.maxHeight * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated container for the icon
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: Duration(milliseconds: 1500),
            curve: Curves.elasticOut,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: constraints.maxWidth * 0.35,
              height: constraints.maxWidth * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.search_off_rounded,
                  size: constraints.maxWidth * 0.18,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.04),

          // Title with animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Text(
              'No items found',
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.06,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: constraints.maxHeight * 0.015),

          // Subtitle with animation
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 800),
            // delay: Duration(milliseconds: 200),
            curve: Curves.easeOut,
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
              child: Text(
                'Try searching with different keywords or browse our suggested categories below',
                style: TextStyle(
                  fontSize: constraints.maxWidth * 0.038,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: constraints.maxHeight * 0.04),

          // Suggested categories
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 800),
            // delay: Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              height: constraints.maxHeight * 0.12,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip(
                      constraints, 'Electronics', Icons.smartphone_rounded),
                  _buildCategoryChip(
                      constraints, 'Clothing', Icons.checkroom_rounded),
                  _buildCategoryChip(
                    constraints,
                    'Home',
                    Icons.chair_rounded,
                  ),
                  _buildCategoryChip(
                      constraints, 'Sports', Icons.sports_basketball_rounded),
                  _buildCategoryChip(constraints, 'Beauty', Icons.spa_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Category chip for suggested items
  Widget _buildCategoryChip(
      BoxConstraints constraints, String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Search for this category
            _controller.searchTextController.text = title;
            // _controller.search(title);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.04,
              vertical: constraints.maxHeight * 0.015,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFFFF460A), // Orange color,
                  size: constraints.maxWidth * 0.05,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Advanced search results with cards, images and categories
  Widget _buildSearchResults(BuildContext context, BoxConstraints constraints,
      double horizontalPadding) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results count header
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: constraints.maxHeight * 0.015,
              horizontal: constraints.maxWidth * 0.02,
            ),
            child: Obx(() {
              final int resultsCount = _controller.searchResults.length;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Found $resultsCount ${resultsCount == 1 ? 'result' : 'results'}',
                    style: TextStyle(
                      fontSize: constraints.maxWidth * 0.038,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Sort by: ',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.034,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        'Relevance',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.034,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF460A), // Orange color,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: const Color(0xFFFF460A), // Orange color,
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),

          // Grid view of items
          Obx(() {
            return Container(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _controller.searchResults.length,
                itemBuilder: (context, index) {
                  final item = _controller.searchResults[index];
                  // Generate a unique color for each item based on index
                  final Color itemColor = Color.fromARGB(
                    255,
                    (220 + index * 10) % 255,
                    (180 + index * 20) % 255,
                    (200 + index * 15) % 255,
                  ).withOpacity(0.2);

                  return _buildItemCard(constraints, item, index, itemColor);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // Modern product card
  Widget _buildItemCard(
      BoxConstraints constraints, String item, int index, Color itemColor) {
    final double cardHeight = constraints.maxWidth * 0.6;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _controller.selectItem(item);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: itemColor,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.inventory_2_rounded,
                          size: constraints.maxWidth * 0.1,
                          color: itemColor.withOpacity(1),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            size: constraints.maxWidth * 0.04,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title and category
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: constraints.maxWidth * 0.035,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Category',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.03,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                      // Price and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${(index + 1) * 19}.99',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: constraints.maxWidth * 0.035,
                              color: const Color(0xFFFF460A), // Orange color,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: constraints.maxWidth * 0.035,
                                color: const Color(0xFFFF460A), // Orange color,
                              ),
                              SizedBox(width: 2),
                              Text(
                                '${4 + (index % 10) / 10}',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Floating action button for filters
  Widget _buildFloatingActionButton(BoxConstraints constraints) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Obx(() {
        final bool hasResults = _controller.isSearching.value &&
            _controller.searchResults.isNotEmpty;

        if (!hasResults) return SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () {
            _controller.toggleFilterMenu();
          },
          backgroundColor: const Color(0xFFFF460A), // Orange color,
          elevation: 4,
          label: Row(
            children: [
              Icon(Icons.filter_list_rounded),
              SizedBox(width: 8),
              Text('Filter'),
            ],
          ),
        );
      }),
    );
  }

  // Shimmer loading effect
  Widget _buildLoadingShimmer(
      BoxConstraints constraints, double horizontalPadding) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: Column(
        children: [
          SizedBox(height: constraints.maxHeight * 0.2),
          Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header shimmer
                _buildShimmerItem(constraints,
                    height: constraints.maxHeight * 0.025,
                    width: constraints.maxWidth * 0.4),
                SizedBox(height: constraints.maxHeight * 0.02),

                // Grid items shimmer
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return _buildShimmerCard(constraints);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer card for loading state
  Widget _buildShimmerCard(BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF460A), // Orange color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image shimmer
          _buildShimmerItem(
            constraints,
            height: constraints.maxWidth * 0.3,
            width: double.infinity,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),

          SizedBox(height: 12),

          // Title shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: _buildShimmerItem(
              constraints,
              height: constraints.maxHeight * 0.015,
              width: constraints.maxWidth * 0.25,
            ),
          ),

          SizedBox(height: 8),

          // Category shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: _buildShimmerItem(
              constraints,
              height: constraints.maxHeight * 0.01,
              width: constraints.maxWidth * 0.15,
            ),
          ),

          SizedBox(height: 16),

          // Price shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: _buildShimmerItem(
              constraints,
              height: constraints.maxHeight * 0.015,
              width: constraints.maxWidth * 0.2,
            ),
          ),

          SizedBox(height: 12),
        ],
      ),
    );
  }

  // Individual shimmer item
  Widget _buildShimmerItem(
    BoxConstraints constraints, {
    required double height,
    required double width,
    BorderRadius? borderRadius,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
      child: ShimmerEffect(),
    );
  }
}

class SearchController extends GetxController {
  final RxList<String> searchResults = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final RxString searchQuery = ''.obs;

  void search(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isLoading.value = true;
    isSearching.value = true;

    // Simulate a network call or search operation
    Future.delayed(Duration(seconds: 2), () {
      searchResults
          .assignAll(List.generate(10, (index) => 'Result ${index + 1}'));
      isLoading.value = false;
    });
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  void toggleFilterMenu() {
    Get.snackbar(
      'Filter Menu',
      'Filter menu toggled',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void selectItem(String item) {
    Get.snackbar(
      'Item Selected',
      'You selected: $item',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// Shimmer effect widget
class ShimmerEffect extends StatefulWidget {
  @override
  _ShimmerEffectState createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade100,
                Colors.grey.shade200,
              ],
            ),
          ),
        );
      },
    );
  }
}
