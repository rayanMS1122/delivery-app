import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:delivery_app/widgets/swipeable_car_ittem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.find<CartController>();
  final TextEditingController nameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController addressController =
      TextEditingController(text: '123 Main St, City');
  final TextEditingController phoneController =
      TextEditingController(text: '+1234567890');
  String selectedDeliveryMethod = 'Door delivery';
  String selectedPaymentMethod = 'Credit Card';
  final List<String> paymentMethods = [
    'Credit Card',
    'PayPal',
    'Cash on Delivery'
  ];

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                CustomAppBar(
                  iconColor: const Color(0xFF333333),
                  title: "Checkout",
                  onBackPressed: () => Get.back(),
                  titleStyle: GoogleFonts.poppins(
                    fontSize: 20 * textScaleFactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  iconSize: 24,
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  'Cart Items',
                  style: GoogleFonts.poppins(
                    fontSize: 24 * textScaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Obx(() => cartController.cartItems.isEmpty
                    ? _buildEmptyCart(textScaleFactor)
                    : Column(
                        children: cartController.cartItems.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SwipeableCartItem(
                              id: item.id,
                              image: item.image,
                              name: item.name,
                              price: item.price,
                              amount: item.amount,
                              restaurantName:
                                  item.restaurantName ?? item.restaurantId!,
                              onDismissed: () =>
                                  cartController.removeItem(item.id),
                              onIncrease: cartController.updatingItemIds
                                      .contains(item.id)
                                  ? null
                                  : () =>
                                      cartController.increaseAmount(item.id),
                              onDecrease: cartController.updatingItemIds
                                      .contains(item.id)
                                  ? null
                                  : () =>
                                      cartController.decreaseAmount(item.id),
                              isTablet: isTablet,
                            ),
                          );
                        }).toList(),
                      )),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  'Delivery',
                  style: GoogleFonts.poppins(
                    fontSize: 24 * textScaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Address details',
                      style: GoogleFonts.poppins(
                        fontSize: 17 * textScaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Update Address',
                          titleStyle: GoogleFonts.poppins(
                              fontSize: 20 * textScaleFactor),
                          content: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                              ),
                              TextField(
                                controller: addressController,
                                decoration:
                                    const InputDecoration(labelText: 'Address'),
                              ),
                              TextField(
                                controller: phoneController,
                                decoration:
                                    const InputDecoration(labelText: 'Phone'),
                              ),
                            ],
                          ),
                          confirm: TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Save',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFFA4A0C),
                                fontSize: 16 * textScaleFactor,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'change',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFF47B0A),
                          fontSize: 15 * textScaleFactor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nameController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 17 * textScaleFactor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        addressController.text,
                        style:
                            GoogleFonts.poppins(fontSize: 15 * textScaleFactor),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        phoneController.text,
                        style:
                            GoogleFonts.poppins(fontSize: 15 * textScaleFactor),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  'Delivery method',
                  style: GoogleFonts.poppins(
                    fontSize: 17 * textScaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDeliveryMethodTile(
                        'Door delivery',
                        selectedDeliveryMethod == 'Door delivery',
                        () => setState(
                            () => selectedDeliveryMethod = 'Door delivery'),
                        textScaleFactor,
                      ),
                      const Divider(),
                      _buildDeliveryMethodTile(
                        'Pick up',
                        selectedDeliveryMethod == 'Pick up',
                        () =>
                            setState(() => selectedDeliveryMethod = 'Pick up'),
                        textScaleFactor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  'Payment method',
                  style: GoogleFonts.poppins(
                    fontSize: 17 * textScaleFactor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 40,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    value: selectedPaymentMethod,
                    isExpanded: true,
                    items: paymentMethods.map((method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(
                          method,
                          style: GoogleFonts.poppins(
                              fontSize: 15 * textScaleFactor),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedPaymentMethod = value);
                      }
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: GoogleFonts.poppins(
                            fontSize: 17 * textScaleFactor,
                          ),
                        ),
                        Text(
                          '\$${(cartController.totalAmount.value + cartController.deliveryFee.value).toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 22 * textScaleFactor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: screenHeight * 0.04),
                Container(
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
                        if (cartController.cartItems.isEmpty) {
                          Get.snackbar(
                            'Empty Cart',
                            'Add items to your cart before proceeding to payment.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        if (nameController.text.isEmpty ||
                            addressController.text.isEmpty ||
                            phoneController.text.isEmpty) {
                          Get.snackbar(
                            'Incomplete Address',
                            'Please provide complete address details.',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        // Mock deliveryAddressId (replace with actual ID from your backend)
                        const deliveryAddressId = 'mock_address_id';
                        cartController.placeOrder(
                            deliveryAddressId, selectedPaymentMethod);
                      },
                      child: Center(
                        child: Text(
                          "Proceed to payment",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18 * textScaleFactor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
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
            onPressed: () => Get.toNamed('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFA4A0C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
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

  Widget _buildDeliveryMethodTile(String title, bool isSelected,
      VoidCallback onTap, double textScaleFactor) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Radio<String>(
            value: title,
            groupValue: selectedDeliveryMethod,
            onChanged: (value) {
              if (value != null) {
                onTap();
              }
            },
            activeColor: const Color(0xFFFA4A0C),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15 * textScaleFactor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
