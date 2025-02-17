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
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                      tooltip: 'Add to favorites',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06), // Adjusted padding
                child: Column(
                  children: [
                    Container(
                      height: screenHeight * 0.35, // Adjusted height
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/Mask Group.png',
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text('Image not available'));
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => index == 0
                            ? Container(
                                width: screenWidth * 0.02, // Adjusted size
                                height: screenWidth * 0.02, // Adjusted size
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        screenWidth * 0.01), // Adjusted margin
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFA4A0C),
                                ),
                              )
                            : Container(
                                width: screenWidth * 0.02, // Adjusted size
                                height: screenWidth * 0.02, // Adjusted size
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        screenWidth * 0.01), // Adjusted margin
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[400],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                    Text(
                      'Veggie tomato mix',
                      style: TextStyle(
                        fontSize: screenWidth * 0.07, // Adjusted font size
                        fontWeight: FontWeight.w600,
                        fontFamily: ' Rounded',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                    Text(
                      'N1,900',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // Adjusted font size
                        fontWeight: FontWeight.w700,
                        fontFamily: ' Rounded',
                        color: const Color(0xFFFA4A0C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.04), // Adjusted spacing
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery info',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Adjusted font size
                          fontWeight: FontWeight.w600,
                          fontFamily: ' Rounded',
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), // Adjusted spacing
                    Text(
                      'Delivered between monday aug and thursday 20 from 8pm to 91:32 pm',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Adjusted font size
                        fontWeight: FontWeight.w400,
                        fontFamily: ' Text',
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // Adjusted spacing
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Return policy',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045, // Adjusted font size
                          fontWeight: FontWeight.w600,
                          fontFamily: ' Rounded',
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01), // Adjusted spacing
                    Text(
                      'All our foods are double checked before leaving our stores so by any case you found a broken food please contact our hotline immediately.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Adjusted font size
                        fontWeight: FontWeight.w400,
                        fontFamily: ' Text',
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
                        color: const Color(0xFFFA4A0C),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFA4A0C).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
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
                                fontFamily: "SF-Pro-Text",
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

class ProductController extends GetxController {
  void addToCart() {
    // Implement add to cart functionality
    Get.snackbar('Success', 'Item added to cart');
  }
}
