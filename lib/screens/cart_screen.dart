import 'package:delivery_app/api/api.dart';
import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:delivery_app/widgets/swipeable_car_ittem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController controller = Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final items = await Api.getCart();

    controller.cartItems.assignAll(items);
  }

  @override
  Widget build(BuildContext context) {
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
                  onBackPressed: () => Get.back(),
                  titleStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  iconSize: 24,
                ),

                const SizedBox(height: 20),

                // Swipe Hint
                _buildSwipeHint(),

                const SizedBox(height: 20),

                // Cart Items
                Obx(() => _buildCartItems()),

                const SizedBox(height: 20),

                // Order Summary
                _buildOrderSummary(),

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
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    return controller.cartItems.isEmpty
        ? _buildEmptyCart()
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
                    onDismissed: () => controller.removeItem(item.id),
                    isTablet: true,
                  ),
                );
              },
            ).toList(),
          );
  }

  Widget _buildEmptyCart() {
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add items to get started",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Obx(() {
      final subtotal = controller.calculateSubtotal();
      final deliveryFee = 2.99;
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
            _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            _buildSummaryRow(
                "Delivery fee", "\$${deliveryFee.toStringAsFixed(2)}"),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Colors.grey),
            ),
            _buildSummaryRow("Total", "\$${total.toStringAsFixed(2)}",
                isTotal: true),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? const Color(0xFFFA4A0C) : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildProceedToPaymentButton() {
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
            color: const Color(0xFFFA4A0C).withOpacity(0.3),
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
            if (controller.cartItems.isNotEmpty) {
              // Handle payment
              // Get.toNamed('/payment');
            } else {
              Get.snackbar(
                'Empty Cart',
                'Add items to your cart before proceeding to payment.',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(20),
                backgroundColor: Colors.grey[200],
                colorText: Colors.black,
              );
            }
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
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
