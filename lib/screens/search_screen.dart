import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class AdvancedSearchScreen extends StatelessWidget {
  final SearchController _controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double safeAreaTop = MediaQuery.of(context).padding.top;
        final double horizontalPadding = constraints.maxWidth * 0.05;

        return Scaffold(
          // backgroundColor: Colors.transparent,
          body: Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: BoxDecoration(),
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomAppBar(
                          title: "Find Food",
                          iconColor: const Color(0xFF1A1A1A),
                          onBackPressed: () => Get.back(),
                          titleStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: constraints.maxWidth * 0.06,
                          ),
                          iconSize: 24,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildSearchBar(
                          context, constraints, horizontalPadding),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: constraints.maxHeight * 0.05),
                    ),
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
                          child: _controller.searchResults.isNotEmpty
                              ? _buildSearchResults(
                                  context, constraints, horizontalPadding)
                              : _buildNoResults(context, constraints),
                        );
                      }),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: constraints.maxHeight * 0.1),
                    ),
                  ],
                ),
                Positioned(
                  bottom: constraints.maxHeight * 0.03,
                  right: constraints.maxWidth * 0.05,
                  child: _buildFloatingActionButton(constraints),
                ),
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
                  hintText: 'Search food or restaurants...',
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
                  _controller.updateSearchResults(query);
                },
              ),
            ),
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
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(finalHeight * 0.5),
                onTap: () {
                  Get.snackbar(
                    'Voice Search',
                    'Voice search activated',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(16),
                    backgroundColor: const Color(0xFFFF6D00), // Vibrant orange
                    colorText: Colors.white,
                  );
                },
                child: Container(
                  width: finalHeight * 0.9,
                  height: finalHeight * 0.9,
                  padding: EdgeInsets.all(finalHeight * 0.2),
                  child: Icon(
                    Icons.mic_rounded,
                    color: const Color(0xFFFF6D00),
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

  Widget _buildNoResults(BuildContext context, BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.08),
      height: constraints.maxHeight * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                  Icons.restaurant_menu_rounded,
                  size: constraints.maxWidth * 0.18,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.04),
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
              'No food found',
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
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
              child: Text(
                'Try searching with different keywords or browse our food categories below',
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
            child: Container(
              height: constraints.maxHeight * 0.12,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip(
                      constraints, 'Pizza', Icons.local_pizza_rounded),
                  _buildCategoryChip(
                      constraints, 'Burgers', Icons.fastfood_rounded),
                  _buildCategoryChip(
                      constraints, 'Sushi', Icons.rice_bowl_rounded),
                  _buildCategoryChip(
                      constraints, 'Pasta', Icons.restaurant_rounded),
                  _buildCategoryChip(
                      constraints, 'Drinks', Icons.local_drink_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      BoxConstraints constraints, String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _controller.searchTextController.text = title;
            _controller.updateSearchResults(title);
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
                  color: const Color(0xFFFF6D00),
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

  Widget _buildSearchResults(BuildContext context, BoxConstraints constraints,
      double horizontalPadding) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    'Found $resultsCount ${resultsCount == 1 ? 'dish' : 'dishes'}',
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
                          color: const Color(0xFFFF6D00),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: const Color(0xFFFF6D00),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          Obx(() {
            return Container(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _controller.searchResults.length,
                itemBuilder: (context, index) {
                  final item = _controller.searchResults[index];
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

  Widget _buildItemCard(BoxConstraints constraints, Map<String, String> item,
      int index, Color itemColor) {
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
            _controller.selectItem(item['title']!);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: itemColor,
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.restaurant_rounded,
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
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: constraints.maxWidth * 0.035,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            item['category']!,
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.03,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Restaurant ${index + 1}',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.03,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${(index + 1) * 7}.99',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: constraints.maxWidth * 0.035,
                              color: const Color(0xFFFF6D00),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: constraints.maxWidth * 0.035,
                                color: const Color(0xFFFF6D00),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '${4 + (index % 10) / 10}',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${15 + index * 5} min',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.03,
                                  color: Colors.grey.shade600,
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
        final bool hasResults = _controller.searchResults.isNotEmpty;

        if (!hasResults) return SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () {
            _controller.toggleFilterMenu();
          },
          backgroundColor: const Color(0xFFFF6D00),
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
                _buildShimmerItem(constraints,
                    height: constraints.maxHeight * 0.025,
                    width: constraints.maxWidth * 0.4),
                SizedBox(height: constraints.maxHeight * 0.02),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
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

  Widget _buildShimmerCard(BoxConstraints constraints) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: _buildShimmerItem(
              constraints,
              height: constraints.maxHeight * 0.015,
              width: constraints.maxWidth * 0.25,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: _buildShimmerItem(
              constraints,
              height: constraints.maxHeight * 0.01,
              width: constraints.maxWidth * 0.15,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: _buildShimmerItem(
              constraints,
              height: constraints.maxHeight * 0.01,
              width: constraints.maxWidth * 0.15,
            ),
          ),
          SizedBox(height: 16),
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
  final RxList<Map<String, String>> searchResults = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  void updateSearchResults(String query) {
    searchQuery.value = query;
    isLoading.value = true;

    Future.delayed(Duration(seconds: 2), () {
      if (query.isNotEmpty) {
        searchResults.value = [
          {'title': 'Pizza', 'category': 'Food'},
          {'title': 'Burger', 'category': 'Food'},
          {'title': 'Sushi', 'category': 'Food'},
          {'title': 'Pasta', 'category': 'Food'},
          {'title': 'Salad', 'category': 'Food'},
          {'title': 'Smoothie', 'category': 'Drink'},
        ]
            .where((item) =>
                item['title']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        searchResults.value = [];
      }
      isLoading.value = false;
    });
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    searchResults.clear();
  }

  void toggleFilterMenu() {
    Get.snackbar(
      'Filter Menu',
      'Filter menu toggled',
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      backgroundColor: const Color(0xFFFF6D00),
      colorText: Colors.white,
    );
  }

  void selectItem(String item) {
    Get.snackbar(
      'Item Selected',
      'You selected: $item',
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      backgroundColor: const Color(0xFFFF6D00),
      colorText: Colors.white,
    );
  }
}

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
