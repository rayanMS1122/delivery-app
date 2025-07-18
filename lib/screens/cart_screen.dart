import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:delivery_app/widgets/swipeable_car_ittem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController controller = Get.find<CartController>();
  final Color mainColor = const Color(0xFFFA4A0C);

  @override
  void initState() {
    super.initState();
    // Debug cart items
    print('Cart items: ${controller.cartItems.map((item) => {
          "id": item.id,
          "foodId": item.foodId,
          "name": item.name,
          "amount": item.amount
        }).toList()}');
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Custom AppBar
                CustomAppBar(
                  title: "Cart",
                  iconColor: const Color(0xFF333333),
                  onBackPressed: () => Get.back(),
                  titleStyle: GoogleFonts.poppins(
                    fontSize: 20 * textScaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  iconSize: 24,
                ),

                const SizedBox(height: 20),

                // Loading Indicator
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink()),

                // Error Message
                Obx(() => controller.errorMessage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              controller.errorMessage.value,
                              style: GoogleFonts.poppins(
                                fontSize: 16 * textScaleFactor,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: controller.fetchCart,
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
                                  fontSize: 16 * textScaleFactor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),

                // Swipe Hint
                Obx(() => controller.cartItems.isNotEmpty
                    ? _buildSwipeHint(textScaleFactor)
                    : const SizedBox.shrink()),

                const SizedBox(height: 20),

                // Cart Items
                Obx(() => _buildCartItems(isTablet, textScaleFactor)),

                const SizedBox(height: 20),

                // Order Summary
                Obx(() => controller.cartItems.isNotEmpty
                    ? _buildOrderSummary(textScaleFactor)
                    : const SizedBox.shrink()),

                const SizedBox(height: 20),

                // Proceed to Payment Button
                Obx(() => controller.cartItems.isNotEmpty
                    ? _buildProceedToPaymentButton(textScaleFactor)
                    : const SizedBox.shrink()),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeHint(double textScaleFactor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/iwwa_swipe.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Swipe on an item to delete',
            style: GoogleFonts.poppins(
              fontSize: 13 * textScaleFactor,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(bool isTablet, double textScaleFactor) {
    return controller.cartItems.isEmpty
        ? _buildEmptyCart(textScaleFactor)
        : Column(
            children: controller.cartItems.map(
              (item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SwipeableCartItem(
                    id: item.id,
                    image: item.image,
                    name: item.name,
                    price: item.price,
                    amount: item.amount,
                    restaurantName: item.restaurantName ??
                        item.restaurantId ??
                        'Restaurant',
                    onDismissed: () => controller.removeItem(item.id),
                    onIncrease: controller.updatingItemIds.contains(item.id)
                        ? null
                        : () => controller.increaseAmount(item.id),
                    onDecrease: controller.updatingItemIds.contains(item.id)
                        ? null
                        : () => controller.decreaseAmount(item.id),
                    isTablet: isTablet,
                  ),
                );
              },
            ).toList(),
          );
  }

  Widget _buildEmptyCart(double textScaleFactor) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 50,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "Your cart is empty",
            style: GoogleFonts.poppins(
              fontSize: 16 * textScaleFactor,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add items to get started",
            style: GoogleFonts.poppins(
              fontSize: 14 * textScaleFactor,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
              shadowColor: mainColor.withOpacity(0.5),
            ),
            child: Text(
              "Browse Menu",
              style: GoogleFonts.poppins(
                fontSize: 16 * textScaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(double textScaleFactor) {
    const deliveryFee = 2.99;
    final subtotal = controller.calculateSubtotal();
    final total = subtotal + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            "Subtotal",
            "\$${subtotal.toStringAsFixed(2)}",
            textScaleFactor,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            "Delivery fee",
            "\$${deliveryFee.toStringAsFixed(2)}",
            textScaleFactor,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.grey),
          ),
          _buildSummaryRow(
            "Total",
            "\$${total.toStringAsFixed(2)}",
            textScaleFactor,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, double textScaleFactor,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: (isTotal ? 16 : 14) * textScaleFactor,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: (isTotal ? 16 : 14) * textScaleFactor,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? mainColor : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedToPaymentButton(double textScaleFactor) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFFFA4A0C), Color(0xFFFF7844)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFA4A0C).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () {
            if (controller.cartItems.isEmpty) {
              Get.snackbar(
                'Empty Cart',
                'Add items to your cart before proceeding to payment.',
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[200],
                colorText: Colors.black,
              );
              return;
            }
            // Validate restaurant consistency
            final restaurantIds =
                controller.cartItems.map((item) => item.restaurantId).toSet();
            if (restaurantIds.length > 1) {
              Get.snackbar(
                'Invalid Cart',
                'All items must be from the same restaurant.',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }
            Get.toNamed('/payment', arguments: {
              'subtotal': controller.calculateSubtotal(),
              'deliveryFee': 2.99,
            });
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.payment_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  "Proceed to payment",
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
    );
  }
}
