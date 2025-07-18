import 'package:delivery_app/controllers/product_controller.dart';
import 'package:delivery_app/models/featured_product.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductController controller = Get.find();
  final FeaturedProduct product;

  ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // controller.isFavorite.value = product.isFavorite;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
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
          _buildBackgroundDecoration(screenWidth, screenHeight),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImageSection(context, screenHeight, screenWidth),
                _buildProductInfoSection(context),
              ],
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return CustomAppBar(
      title: "",
      iconColor: const Color(0xFF333333),
      onBackPressed: () => Get.back(),
      titleStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      iconSize: 24,
    );
  }

  Widget _buildBackgroundDecoration(double screenWidth, double screenHeight) {
    return Stack(
      children: [
        Positioned(
          top: -screenHeight * 0.1,
          right: -screenWidth * 0.1,
          child: Container(
            height: screenHeight * 0.25,
            width: screenWidth * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFA4A0C).withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: screenHeight * 0.15,
          left: -screenWidth * 0.2,
          child: Container(
            height: screenHeight * 0.3,
            width: screenWidth * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF3D5CFF).withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          top: screenHeight * 0.3,
          right: -screenWidth * 0.1,
          child: Container(
            height: screenHeight * 0.15,
            width: screenWidth * 0.3,
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
      height: screenHeight * 0.45,
      width: double.infinity,
      child: Stack(
        children: [
          Obx(() {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Container(
                key: ValueKey<int>(controller.selectedImageIndex.value),
                height: screenHeight * 0.45,
                width: double.infinity,
                child: Hero(
                  tag: 'product-image-${product.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(screenWidth * 0.08),
                      bottomRight: Radius.circular(screenWidth * 0.08),
                    ),
                    child: product.images.isNotEmpty
                        ? PageView.builder(
                            itemCount: product.images.length,
                            onPageChanged: (index) =>
                                controller.changeImage(index, product.images),
                            itemBuilder: (context, index) {
                              final image = product.images[index];
                              return Image(
                                image: image.isNotEmpty &&
                                        Uri.tryParse(image)?.hasAbsolutePath ==
                                            true
                                    ? NetworkImage(image)
                                    : AssetImage('assets/Mask Group.png')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Product image load error: $error');
                                  return Image.asset('assets/Mask Group.png',
                                      fit: BoxFit.cover);
                                },
                              );
                            },
                          )
                        : Image(
                            image: product.image.isNotEmpty &&
                                    Uri.tryParse(product.image)
                                            ?.hasAbsolutePath ==
                                        true
                                ? NetworkImage(product.image)
                                : AssetImage('assets/Mask Group.png')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Product image load error: $error');
                              return Image.asset('assets/Mask Group.png',
                                  fit: BoxFit.cover);
                            },
                          ),
                  ),
                ),
              ),
            );
          }),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(screenWidth * 0.08),
                bottomRight: Radius.circular(screenWidth * 0.08),
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
          Positioned(
            bottom: screenHeight * 0.02,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    product.images.isNotEmpty ? product.images.length : 1,
                    (index) => GestureDetector(
                      onTap: () =>
                          controller.changeImage(index, product.images),
                      child: Obx(() {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          width: controller.selectedImageIndex.value == index
                              ? screenWidth * 0.03
                              : screenWidth * 0.02,
                          height: controller.selectedImageIndex.value == index
                              ? screenWidth * 0.03
                              : screenWidth * 0.02,
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01),
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
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImageNavButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onTap: () => controller.previousImage(product.images),
                      screenWidth: screenWidth,
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildImageNavButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onTap: () => controller.nextImage(product.images),
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.12,
            left: screenWidth * 0.05,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFFA4A0C),
                borderRadius: BorderRadius.circular(screenWidth * 0.06),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                product.category ?? 'Unknown',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.035,
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
        width: screenWidth * 0.08,
        height: screenWidth * 0.08,
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
          size: screenWidth * 0.04,
        ),
      ),
    );
  }

  Widget _buildProductInfoSection(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 28 * textScaleFactor,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: product.averageRating,
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
                        SizedBox(width: 8),
                        Text(
                          product.averageRating.toStringAsFixed(1),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14 * textScaleFactor,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3D3D3D),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(${product.ratingCount} reviews)',
                          overflow: TextOverflow.ellipsis,
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
                width: MediaQuery.sizeOf(context).width * 0.285,
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
                      '\$${product.price.toStringAsFixed(2)}',
                      overflow: TextOverflow.ellipsis,
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
                    product.description.isNotEmpty
                        ? product.description
                        : 'Our ${product.name.toLowerCase()} is made with fresh ingredients and select herbs. Low in calories, high in nutrients, ideal for health-conscious food lovers.',
                    overflow: TextOverflow.fade,
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
                  icon: Icons.local_dining,
                  title: "Ingredients",
                  child: Text(
                    product.ingredients.isNotEmpty
                        ? product.ingredients.join(', ')
                        : 'No ingredients listed.',
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
                          product.deliveryInfo ??
                              'Delivered between Monday and Thursday from 8pm to 9:32 pm',
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
                    product.returnPolicy ??
                        'All our foods are double-checked before leaving our stores. If you find an issue, please contact our hotline immediately.',
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
          _buildNutritionalInfo(context),
          SizedBox(height: 24),
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
              style: GoogleFonts.poppins(
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
    final screenWidth = MediaQuery.of(context).size.width;

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
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3D3D3D),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutritionItem(
                context,
                label: "Calories",
                value: product.nutritionalInfo?.calories.toString() ?? "120",
                unit: "kcal",
              ),
              _buildNutritionItem(
                context,
                label: "Protein",
                value: product.nutritionalInfo?.protein.toString() ?? "3.5",
                unit: "g",
              ),
              _buildNutritionItem(
                context,
                label: "Carbs",
                value:
                    product.nutritionalInfo?.carbohydrates.toString() ?? "12",
                unit: "g",
              ),
              _buildNutritionItem(
                context,
                label: "Fat",
                value: product.nutritionalInfo?.fat.toString() ?? "2",
                unit: "g",
              ),
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Column(
        children: [
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: screenWidth * 0.01),
          RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3D3D3D),
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
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
              onPressed: () {
                Get.toNamed('/home'); // Navigiert zurück zur HomeScreen
              },
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
        Obx(() {
          return controller.featuredProducts.isEmpty
              ? Center(
                  child: Text(
                    "No recommended products available",
                    style: GoogleFonts.poppins(
                      fontSize: 14 * textScaleFactor,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      controller.featuredProducts.length,
                      (index) {
                        final recommendedProduct =
                            controller.featuredProducts[index];
                        return GestureDetector(
                          onTap: () =>
                              controller.onProductTap(recommendedProduct),
                          child: Container(
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
                                  child: Image(
                                    image: recommendedProduct
                                                .image.isNotEmpty &&
                                            Uri.tryParse(recommendedProduct
                                                        .image)
                                                    ?.hasAbsolutePath ==
                                                true
                                        ? NetworkImage(recommendedProduct.image)
                                        : AssetImage('assets/placeholder.png')
                                            as ImageProvider,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print(
                                          'Recommended product image load error: $error');
                                      return Image.asset(
                                          'assets/placeholder.png',
                                          height: 120,
                                          fit: BoxFit.cover);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recommendedProduct.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14 * textScaleFactor,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF3D3D3D),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '\$${recommendedProduct.price.toStringAsFixed(2)}',
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
                        );
                      },
                    ),
                  ),
                );
        }),
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
                  controller.addToCart(product,
                      quantity: controller.quantity.value);
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
    OverlayEntry entry = OverlayEntry(
      builder: (context) {
        return Container();
      },
    );
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
                    entry.remove();
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
      "${product.name} has been added to your cart",
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
