import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:delivery_app/widgets/swipeable_car_ittem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                // Back Button and Title
                CustomAppBar(
                  title: "Cart",
                  onBackPressed: () {
                    Get.back();
                  },
                ),
                const SizedBox(height: 20),
                // Swipe Hint
                _buildSwipeHint(),
                const SizedBox(height: 20),
                // Cart Items
                _buildCartItems(),
                const SizedBox(height: 20),
                // Proceed to Payment Button
                _buildProceedToPaymentButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/iwwa_swipe.png',
          width: 20,
          height: 20,
        ),
        const SizedBox(width: 5),
        const Text(
          'Swipe on an item to delete',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildCartItems() {
    return Obx(() {
      return Column(
        children: controller.cartItems.map((item) {
          return SwipeableCartItem(
            id: item.id,
            image: item.image,
            title: item.title,
            price: item.price,
            amount: item.amount,
            onDismissed: () {
              controller.removeItem(item.id);
            },
          );
        }).toList(),
      );
    });
  }

  Widget _buildProceedToPaymentButton() {
    return Container(
      width: double.infinity,
      height: 60,
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
            // Handle payment
          },
          child: Center(
            child: Text(
              "Proceed to payment",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
