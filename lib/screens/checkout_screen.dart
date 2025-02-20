import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/controllers/checkout_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:delivery_app/widgets/delivery_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatelessWidget {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final CartController cartController =
      Get.find(); // Use the existing CartController

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  0.05, // 5% of screen width
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02), // Adjusted spacing
                // Back Button and Title
                CustomAppBar(
                  title: "Checkout",
                  onBackPressed: () {
                    Get.back();
                  },
                ),
                const SizedBox(height: 32),
                // Delivery Section Title
                const Text(
                  'Delivery',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                // Address Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Address details',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Open a dialog or new screen to update address
                        Get.defaultDialog(
                          title: 'Update Address',
                          content: Column(
                            children: [
                              const SizedBox(height: 32),
                              TextField(
                                decoration: InputDecoration(labelText: 'Name'),
                                onChanged: (value) =>
                                    checkoutController.name.value = value,
                              ),
                              TextField(
                                decoration:
                                    InputDecoration(labelText: 'Address'),
                                onChanged: (value) =>
                                    checkoutController.address.value = value,
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Phone'),
                                onChanged: (value) =>
                                    checkoutController.phone.value = value,
                              ),
                            ],
                          ),
                          confirm: TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Save',
                              style: TextStyle(color: const Color(0xFFFA4A0C)),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'change',
                        style: TextStyle(
                          color: Color(0xFFF47B0A),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Address Card
                Obx(() {
                  return Container(
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
                          checkoutController.name.value,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          checkoutController.address.value,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Text(
                          checkoutController.phone.value,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 32),
                // Delivery Method Section
                const Text(
                  'Delivery method',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
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
                  child: Obx(() {
                    return Column(
                      children: [
                        DeliveryMethodTile(
                          title: 'Door delivery',
                          isSelected:
                              checkoutController.selectedDeliveryMethod.value ==
                                  'Door delivery',
                          onTap: () => checkoutController
                              .updateDeliveryMethod('Door delivery'),
                        ),
                        const Divider(),
                        DeliveryMethodTile(
                          title: 'Pick up',
                          isSelected:
                              checkoutController.selectedDeliveryMethod.value ==
                                  'Pick up',
                          onTap: () => checkoutController
                              .updateDeliveryMethod('Pick up'),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 32),
                // Total Section
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 17),
                      ),
                      Text(
                        '${cartController.totalPrice}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 32),
                // Proceed to Payment Button
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
                        // Handle payment
                        Get.snackbar(
                          'Payment',
                          'Proceeding to payment...',
                          snackPosition: SnackPosition.BOTTOM,
                        );
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
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
