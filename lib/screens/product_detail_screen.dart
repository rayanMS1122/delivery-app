import 'package:delivery_app/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF8F9FF), Color(0xFFEDF1F9)],
                stops: [0.3, 1.0],
              ),
            ),
          ),

          // Background decorative elements
          _buildBackgroundDecoration(screenWidth, screenHeight),

          // Main content
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image & Gallery Section
                _buildProductImageSection(context, screenHeight, screenWidth),

                // Product Info Section
                _buildProductInfoSection(context),
              ],
            ),
          ),

          // Bottom Add to Cart Bar
          _buildBottomBar(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding:
            EdgeInsets.only(left: screenWidth * 0.04), // 4% of screen width
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                size: screenWidth * 0.05), // 5% of screen width
            color: Color(0xFF3D3D3D),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding:
              EdgeInsets.only(right: screenWidth * 0.04), // 4% of screen width
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.share_rounded,
                      size: screenWidth * 0.05), // 5% of screen width
                  color: Color(0xFF3D3D3D),
                  onPressed: () {
                    Get.snackbar(
                      "Share",
                      "Sharing product with friends",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
              SizedBox(width: screenWidth * 0.03), // 3% of screen width
              Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                        controller.isFavorite.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: screenWidth * 0.05), // 5% of screen width
                    color: controller.isFavorite.value
                        ? Colors.red
                        : Color(0xFF3D3D3D),
                    onPressed: () {
                      controller.toggleFavorite();
                      if (controller.isFavorite.value) {
                        _showFavoriteAnimation(context);
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundDecoration(double screenWidth, double screenHeight) {
    return Stack(
      children: [
        Positioned(
          top: -screenHeight * 0.1, // 10% of screen height
          right: -screenWidth * 0.1, // 10% of screen width
          child: Container(
            height: screenHeight * 0.25, // 25% of screen height
            width: screenWidth * 0.5, // 50% of screen width
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFA4A0C).withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: screenHeight * 0.15, // 15% of screen height
          left: -screenWidth * 0.2, // 20% of screen width
          child: Container(
            height: screenHeight * 0.3, // 30% of screen height
            width: screenWidth * 0.6, // 60% of screen width
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3D5CFF).withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          top: screenHeight * 0.3, // 30% of screen height
          right: -screenWidth * 0.1, // 10% of screen width
          child: Container(
            height: screenHeight * 0.15, // 15% of screen height
            width: screenWidth * 0.3, // 30% of screen width
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3D5CFF).withOpacity(0.07),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductImageSection(
      BuildContext context, double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.45, // 45% of screen height
      width: double.infinity,
      child: Stack(
        children: [
          // Product image with parallax effect
          Obx(() {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Container(
                key: ValueKey<int>(controller.selectedImageIndex.value),
                height: screenHeight * 0.45, // 45% of screen height
                width: double.infinity,
                child: Hero(
                  tag: 'product-image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          screenWidth * 0.08), // 8% of screen width
                      bottomRight: Radius.circular(
                          screenWidth * 0.08), // 8% of screen width
                    ),
                    child: Image.asset(
                      'assets/Mask Group.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: screenWidth * 0.15, // 15% of screen width
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft:
                    Radius.circular(screenWidth * 0.08), // 8% of screen width
                bottomRight:
                    Radius.circular(screenWidth * 0.08), // 8% of screen width
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
                stops: [0.7, 1.0],
              ),
            ),
          ),

          // Image gallery indicator
          Positioned(
            bottom: screenHeight * 0.02, // 2% of screen height
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => GestureDetector(
                      onTap: () => controller.changeImage(index),
                      child: Obx(() {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          width: controller.selectedImageIndex.value == index
                              ? screenWidth * 0.03 // 3% of screen width
                              : screenWidth * 0.02, // 2% of screen width
                          height: controller.selectedImageIndex.value == index
                              ? screenWidth * 0.03 // 3% of screen width
                              : screenWidth * 0.02, // 2% of screen width
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  screenWidth * 0.01), // 1% of screen width
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.selectedImageIndex.value == index
                                ? Color(0xFFFA4A0C)
                                : Colors.white.withOpacity(0.7),
                            boxShadow: controller.selectedImageIndex.value ==
                                    index
                                ? [
                                    BoxShadow(
                                      color: Color(0xFFFA4A0C).withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // 1% of screen height
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImageNavButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onTap: () => controller.previousImage(),
                      screenWidth: screenWidth,
                    ),
                    SizedBox(width: screenWidth * 0.05), // 5% of screen width
                    _buildImageNavButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onTap: () => controller.nextImage(),
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category tag
          Positioned(
            top: screenHeight * 0.12, // 12% of screen height
            left: screenWidth * 0.05, // 5% of screen width
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, // 4% of screen width
                vertical: screenHeight * 0.01, // 1% of screen height
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFA4A0C),
                borderRadius: BorderRadius.circular(
                    screenWidth * 0.06), // 6% of screen width
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                'Vegetarian',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.035, // 3.5% of screen width
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageNavButton({
    required IconData icon,
    required Function() onTap,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.08, // 8% of screen width
        height: screenWidth * 0.08, // 8% of screen width
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Color(0xFF3D3D3D),
          size: screenWidth * 0.04, // 4% of screen width
        ),
      ),
    );
  }

  Widget _buildProductInfoSection(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).size.height * .0012;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product title and price row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Veggie tomato mix',
                      overflow: TextOverflow.ellipsis, // Adds "..." at the end
                      style: GoogleFonts.poppins(
                        fontSize: 28 * textScaleFactor,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                    SizedBox(height: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: 4.5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 16 * textScaleFactor,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                        Text(
                          '4.5',
                          overflow:
                              TextOverflow.ellipsis, // Adds "..." at the end
                          style: GoogleFonts.poppins(
                            fontSize: 14 * textScaleFactor,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3D3D3D),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(204 reviews)',
                          overflow:
                              TextOverflow.ellipsis, // Adds "..." at the end
                          style: GoogleFonts.poppins(
                            fontSize: 12 * textScaleFactor,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * .285,
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFFA4A0C),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFA4A0C).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'N1,900',
                      overflow: TextOverflow.ellipsis, // Adds "..." at the end
                      style: GoogleFonts.poppins(
                        fontSize: 22 * textScaleFactor,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '/per unit',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12 * textScaleFactor,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Product details
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(
                  context,
                  icon: Icons.info_outline,
                  title: "Product Details",
                  child: Text(
                    'Our veggie tomato mix is the perfect blend of fresh tomatoes, bell peppers, onions, and select herbs. Low in calories, high in nutrients, this is ideal for health-conscious food lovers.',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14 * textScaleFactor,
                      height: 1.5,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Divider(height: 32),
                _buildDetailItem(
                  context,
                  icon: Icons.delivery_dining,
                  title: "Delivery Info",
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Delivered between Monday Aug and Thursday 20 from 8pm to 9:32 pm',
                          style: GoogleFonts.poppins(
                            fontSize: 14 * textScaleFactor,
                            height: 1.5,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.access_time,
                          color: Color(0xFFFA4A0C),
                          size: 24 * textScaleFactor,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 32),
                _buildDetailItem(
                  context,
                  icon: Icons.refresh,
                  title: "Return Policy",
                  child: Text(
                    'All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.',
                    style: GoogleFonts.poppins(
                      fontSize: 14 * textScaleFactor,
                      height: 1.5,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Nutritional information
          _buildNutritionalInfo(context),
          SizedBox(height: 24),

          // Recommended products
          _buildRecommendedSection(context),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFA4A0C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Color(0xFFFA4A0C),
                size: 18 * textScaleFactor,
              ),
            ),
            SizedBox(width: 12),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16 * textScaleFactor,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3D3D3D),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildNutritionalInfo(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFFA4A0C).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.spa,
                  color: Color(0xFFFA4A0C),
                  size: 18 * textScaleFactor,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Nutritional Information",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width *
                      0.045, // 4.5% of screen width
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3D3D3D),
                ),
              )
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutritionItem(context,
                  label: "Calories", value: "120", unit: "kcal"),
              _buildNutritionItem(context,
                  label: "Protein", value: "3.5", unit: "g"),
              _buildNutritionItem(context,
                  label: "Carbs", value: "12", unit: "g"),
              _buildNutritionItem(context, label: "Fat", value: "2", unit: "g"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
  }) {
    // Get the screen width to make the widget responsive
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // Use percentage-based padding
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02, // 2% of screen width
        vertical: screenWidth * 0.03, // 3% of screen width
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius:
            BorderRadius.circular(screenWidth * 0.03), // 3% of screen width
      ),
      child: Column(
        children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035, // 3.5% of screen width
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: screenWidth * 0.01), // 1% of screen width
          RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045, // 4.5% of screen width
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03, // 3% of screen width
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "You might also like",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 18 * textScaleFactor,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3D3D3D),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "View all",
                style: GoogleFonts.poppins(
                  fontSize: 14 * textScaleFactor,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFA4A0C),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              3,
              (index) => Container(
                width: screenWidth * 0.4,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/Mask Group.png',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0
                                ? "Veggie pasta"
                                : index == 1
                                    ? "Garden salad"
                                    : "Fruit mix",
                            style: GoogleFonts.poppins(
                              fontSize: 14 * textScaleFactor,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3D3D3D),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "N${1200 + (index * 300)}",
                            style: GoogleFonts.poppins(
                              fontSize: 14 * textScaleFactor,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFA4A0C),
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
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: screenHeight * 0.1,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (controller.quantity.value > 1) {
                        controller.decreaseQuantity();
                      }
                    },
                    color: Color(0xFF3D3D3D),
                  ),
                  Obx(() {
                    return Text(
                      controller.quantity.value.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 18 * textScaleFactor,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3D3D3D),
                      ),
                    );
                  }),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => controller.increaseQuantity(),
                    color: Color(0xFF3D3D3D),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  controller.addToCart();
                  _showAddToCartAnimation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Color(0xFFFA4A0C), Color(0xFFFF6E40)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFA4A0C).withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 20 * textScaleFactor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Add to Cart",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16 * textScaleFactor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFavoriteAnimation(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // Declare as late
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: size.width,
            height: size.height,
            child: Center(
              child: Lottie.asset(
                'assets/favorite-animation.json',
                width: 150,
                height: 150,
                repeat: false,
                onLoaded: (composition) {
                  Future.delayed(composition.duration, () {
                    entry.remove(); // Safe to use now
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
  }

  void _showAddToCartAnimation(BuildContext context) {
    Get.snackbar(
      "Added to Cart",
      "Veggie tomato mix has been added to your cart",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: EdgeInsets.all(16),
      borderRadius: 16,
      duration: Duration(seconds: 2),
      icon: Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    );
  }
}
