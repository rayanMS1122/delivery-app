import 'package:delivery_app/api/api.dart';
import 'package:delivery_app/controllers/home_controller.dart';
import 'package:delivery_app/controllers/product_controller.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/screens/favorites_screen.dart';
import 'package:delivery_app/screens/password_change.dart';
import 'package:delivery_app/screens/product_detail_screen.dart';
import 'package:delivery_app/screens/profile_screen.dart';
import 'package:delivery_app/screens/search_screen.dart';
import 'package:delivery_app/screens/welcome_screen.dart';
import 'package:delivery_app/widgets/bottom_navigation.dart';
import 'package:delivery_app/widgets/build_featured_products.dart';
import 'package:delivery_app/widgets/category_tabs.dart';
import 'package:delivery_app/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'history_screen.dart';
import 'order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Initialize the HomeController
  final HomeController _controller = Get.put(HomeController());
  final _advancedDrawerController = AdvancedDrawerController();
  final ProductController _productController = Get.put(ProductController());
  List<Product> products = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = true;

  Future<void> fetchData() async {
    setState(() => _isLoading = true);
    try {
      final data = await Api.getProduct();
      setState(() {
        products = data;
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load products: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Get responsive size based on screen size
  double getResponsiveSize(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  // Get responsive height based on screen size
  double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  // Get responsive font size based on screen width
  double getResponsiveFontSize(BuildContext context, double baseSize) {
    // Base this on the smaller dimension to ensure consistent sizing on all devices
    final width = MediaQuery.of(context).size.width;
    final baseFactor = width / 375; // 375 is base width (iPhone X)
    final scaleFactor = baseFactor.clamp(0.8, 1.2); // Limit scaling range
    return baseSize * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isFav = false;
        // Store the constraints to use in the entire UI
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Responsive drawer width
        final drawerWidth = maxWidth * 0.85;

        return AdvancedDrawer(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Obx(() {
              switch (_controller.selectedNavIndex.value) {
                case 0:
                  isFav = false;
                  return _buildHomeScreen(context);

                case 1:
                  isFav = true;
                  return FavoritesScreen();
                case 2:
                  isFav = false;
                  return EditableProfileScreen();
                case 3:
                  isFav = false;
                  return HistoryScreen();
                default:
                  isFav = false;
                  return _buildHomeScreen(context);
              }
            }),
            bottomNavigationBar: BottomNavigation(),
            floatingActionButton: SizedBox(
              height: getResponsiveSize(context, 0.15),
              width: getResponsiveSize(context, 0.15),
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () => Get.to(OrderScreen()),
                  backgroundColor: const Color(0xFFFF460A),
                  child: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white),
                  elevation: 4,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
          drawer: DrawerWidget(onSignOut: () {
            Api.logout(WelcomeScreen());
          }),
          backdrop: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF460A),
                  Color(0xFFFF8C69),
                ],
              ),
            ),
          ),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          disabledGestures: false,
          openScale: 0.65,
          childDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(maxWidth * 0.07),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: maxWidth * 0.05,
                spreadRadius: maxWidth * 0.01,
                offset: Offset(-maxWidth * 0.04, 0),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    // Calculate responsive dimensions
    final size = MediaQuery.of(context).size;
    final appBarHeight = size.height * 0.2;
    final horizontalPadding = size.width * 0.05;
    final verticalSpacing = size.height * 0.02;

    return MediaQuery(
      // This prevents keyboard from pushing the UI up abnormally
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.0, // Force 1.0 text scale factor for all devices
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: appBarHeight,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: size.width * 0.12,
            leading: IconButton(
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: value.visible
                        ? Icon(
                            Icons.clear,
                            key: const ValueKey('icon_clear'),
                            color: const Color(0xFFFF460A),
                            size: size.width * 0.06,
                          )
                        : Image.asset(
                            "assets/menu.png",
                            key: const ValueKey('icon_menu'),
                            width: size.width * 0.06,
                            height: size.width * 0.06,
                            color: const Color(0xFFFF460A),
                          ),
                  );
                },
              ),
              onPressed: () => _advancedDrawerController.showDrawer(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: size.width * 0.06,
                ),
                color: const Color(0xFFFF460A),
                onPressed: () {
                  Get.to(() => AdvancedSearchScreen());
                },
              ),
              SizedBox(width: size.width * 0.02),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFEEAE6),
                      Colors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    size.height * 0.059,
                    horizontalPadding,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: size.height * 0.005),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          "Delicious\nfood for you",
                          style: GoogleFonts.poppins(
                            fontSize: getResponsiveFontSize(context, 34),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalSpacing,
              ),
              child: _buildSearchBar(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: verticalSpacing),
              child: SizedBox(
                height: size.height * 0.06,
                child: CategoryTabs(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalSpacing,
                horizontalPadding,
                verticalSpacing * 0.5,
              ),
              child: _buildSectionHeader(context, "Featured Products"),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: size.height * 0.29,
              child: _buildFeaturedProducts(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                verticalSpacing,
                horizontalPadding,
                verticalSpacing * 0.5,
              ),
              child: _buildSectionHeader(context, "Popular Near You"),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildPopularProducts(context),
            // Add bottom padding to account for floating action button
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: size.height * 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: getResponsiveFontSize(context, 18),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "See all",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: const Color(0xFFFF460A),
              fontWeight: FontWeight.w500,
              fontSize: getResponsiveFontSize(context, 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.width * 0.08),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search for food...",
          hintStyle: GoogleFonts.poppins(
            color: Colors.black54,
            fontSize: getResponsiveFontSize(context, 14),
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: const Color(0xFFFF460A),
            size: size.width * 0.05,
          ),
          suffixIcon: Container(
            margin: EdgeInsets.all(size.width * 0.02),
            decoration: BoxDecoration(
              color: const Color(0xFFFF460A).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.filter_list,
              color: const Color(0xFFFF460A),
              size: size.width * 0.05,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedProducts(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_isLoading) {
      return _buildShimmerProducts(context);
    }

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied,
              size: size.width * 0.12,
              color: Colors.grey,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              "No products available",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: getResponsiveFontSize(context, 16),
              ),
            ),
            TextButton(
              onPressed: fetchData,
              child: Text(
                "Refresh",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFF460A),
                  fontSize: getResponsiveFontSize(context, 14),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(context, products[index], index);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, int index) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.55;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = 0.2 * index;
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              delay.clamp(0.0, 1.0),
              (delay + 0.4).clamp(0.0, 1.0),
              curve: Curves.easeOut,
            ),
          ),
        );

        return Transform.translate(
          offset: Offset(0, 50 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Get.to(() => ProductDetailScreen());
        },
        child: Container(
          margin: EdgeInsets.only(
              right: size.width * 0.05, bottom: size.height * 0.015),
          width: cardWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.width * 0.06),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: products[index].image!,
                        height: size.height * 0.14,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: size.height * 0.14,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: size.height * 0.14,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.error,
                            size: size.width * 0.05,
                          ),
                        ),
                      ),
                      Positioned(
                        top: size.width * 0.02,
                        right: size.width * 0.02,
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.015),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            color: const Color(0xFFFF460A),
                            size: size.width * 0.045,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product details
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      products[index].name!,
                      style: GoogleFonts.poppins(
                        fontSize: getResponsiveFontSize(context, 16),
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      products[index].des!,
                      style: GoogleFonts.poppins(
                        fontSize: getResponsiveFontSize(context, 12),
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          products[index].price!,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: getResponsiveFontSize(context, 18),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF460A),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(size.width * 0.015),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF460A),
                            borderRadius:
                                BorderRadius.circular(size.width * 0.02),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: size.width * 0.045,
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
    );
  }

  Widget _buildShimmerProducts(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.55;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.only(
                right: size.width * 0.05, bottom: size.height * 0.015),
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.06),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width * 0.03),
                  child: Container(
                    height: size.height * 0.14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size.height * 0.02,
                        width: size.width * 0.35,
                        color: Colors.white,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Container(
                        height: size.height * 0.015,
                        width: size.width * 0.3,
                        color: Colors.white,
                      ),
                      SizedBox(height: size.height * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: size.height * 0.02,
                            width: size.width * 0.15,
                            color: Colors.white,
                          ),
                          Container(
                            height: size.width * 0.075,
                            width: size.width * 0.075,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
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
        );
      },
    );
  }

  Widget _buildPopularProducts(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_isLoading) {
      return _buildShimmerPopularProducts(context);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: EdgeInsets.only(bottom: size.height * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.04),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.02),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width * 0.03),
                      child: CachedNetworkImage(
                        imageUrl: "https://picsum.photos/200",
                        height: size.width * 0.2,
                        width: size.width * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Veggie Supreme Pizza",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: getResponsiveFontSize(context, 16),
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Italian Restaurant • 0.8 mi",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: getResponsiveFontSize(context, 12),
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: const Color(0xFFFFD700),
                                size: size.width * 0.04,
                              ),
                              SizedBox(width: size.width * 0.01),
                              Text(
                                "4.8",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: getResponsiveFontSize(context, 12),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Text(
                                "• \$14.${99 + index}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: getResponsiveFontSize(context, 12),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFF460A),
                                ),
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
          );
        },
      ),
    );
  }

  Widget _buildShimmerPopularProducts(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: EdgeInsets.only(bottom: size.height * 0.02),
              height: size.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.width * 0.04),
              ),
            ),
          );
        },
      ),
    );
  }
}
