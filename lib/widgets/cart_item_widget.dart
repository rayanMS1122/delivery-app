import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemWidget extends StatelessWidget {
  final String image;
  final String name;
  final int price;
  final String id; // Unique identifier for the item

  CartItemWidget({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.id,
  }) : super(key: key);

  // Access the CartController
  final CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 40,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(
            image,
            width: 69,
            height: 69,
            scale: 1,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$price',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFA4A0C),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFA4A0C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Minus Button
                          Obx(() {
                            final item = controller.cartItems.firstWhere(
                              (item) => item.id == id,
                            );
                            return Container(
                              width: 30,
                              child: MaterialButton(
                                onPressed: () {
                                  controller.decreaseAmount(id);
                                },
                                child: const Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }),
                          // Amount Display
                          Obx(() {
                            final item = controller.cartItems.firstWhere(
                              (item) => item.id == id,
                            );
                            return Text(
                              '${item.amount}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            );
                          }),
                          // Plus Button
                          Obx(() {
                            final item = controller.cartItems.firstWhere(
                              (item) => item.id == id,
                            );
                            return Container(
                              width: 30,
                              child: MaterialButton(
                                onPressed: () {
                                  controller.increaseAmount(id);
                                },
                                child: const Text(
                                  '+',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
