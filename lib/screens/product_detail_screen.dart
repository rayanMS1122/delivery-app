import 'package:delivery_app/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Custom AppBar
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05), // Adjusted padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Get.back(),
                      tooltip: 'Go back',
                    ),
                    Obx(() {
                      return IconButton(
                        icon: Icon(
                          controller.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: controller.isFavorite.value
                              ? Colors.red
                              : Colors.black,
                        ),
                        onPressed: () {
                          controller.toggleFavorite();
                        },
                        tooltip: 'Add to favorites',
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06), // Adjusted padding
                child: Column(
                  children: [
                    // Product Image
                    Container(
                      height: screenHeight * 0.35, // Adjusted height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/Mask Group.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Image not available',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                    // Image Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Obx(() {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: screenWidth * 0.02, // Adjusted size
                            height: screenWidth * 0.02, // Adjusted size
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    screenWidth * 0.01), // Adjusted margin
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  controller.selectedImageIndex.value == index
                                      ? const Color(0xFFFA4A0C)
                                      : Colors.grey[400],
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                    // Product Name
                    Text(
                      'Veggie tomato mix',
                      style: TextStyle(
                        fontSize: screenWidth * 0.07, // Adjusted font size
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                    // Product Price
                    Text(
                      'N1,900',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Adjusted font size
                        fontWeight: FontWeight.w700,

                        color: const Color(0xFFFA4A0C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.04), // Adjusted spacing
                    // Delivery Info
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery info',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Adjusted font size
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), // Adjusted spacing
                    Text(
                      'Delivered between Monday Aug and Thursday 20 from 8pm to 9:32 pm',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Adjusted font size
                        fontWeight: FontWeight.w400,

                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Adjusted spacing
                    // Return Policy
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Return policy',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Adjusted font size
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), // Adjusted spacing
                    Text(
                      'All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Adjusted font size
                        fontWeight: FontWeight.w400,

                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04), // Adjusted spacing
                    // Start Ordering Button
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.08, // Adjusted height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [Color(0xFFFA4A0C), Color(0xFFFF6B3A)],
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
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            controller.addToCart();
                          },
                          child: Center(
                            child: Text(
                              "Start Ordering",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize:
                                    screenWidth * 0.045, // Adjusted font size
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
