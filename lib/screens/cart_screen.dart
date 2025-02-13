import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: CartScreen(),
    );
  }
}

class CartScreen extends StatelessWidget {
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(),
                  ],
                ),
                const SizedBox(height: 51),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/iwwa_swipe.png',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'swipe on an item to delete',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'SF Pro Text',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                CartItemWidget(
                  image: 'assets/Mask Group.png',
                  title: 'Veggie tomato mix',
                  price: 1900,
                ),
                const SizedBox(height: 14),
                CartItemWidget(
                  image: 'assets/Mask Group.png',
                  title: 'Fishwith mix orange....',
                  price: 1900,
                ),
                const SizedBox(height: 17),
                SwipeableCartItem(
                  id: 'item1', // Unique identifier
                  image: 'assets/Mask Group.png',
                  title: 'Veggie tomato mix',
                  price: 1900,
                ),
                const SizedBox(height: 270),
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
                      onTap: () {},
                      child: Center(
                        child: Text(
                          "Proceed to payment",
                          style: TextStyle(
                            fontFamily: "SF-Pro-Text",
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

class CartItemWidget extends StatelessWidget {
  final String image;
  final String title;
  final int price;

  const CartItemWidget({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
  }) : super(key: key);

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
          Image.asset(
            image,
            width: 69,
            height: 69,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '#$price',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFA4A0C),
                        fontFamily: 'SF Pro Text',
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
                        children: [
                          const Text(
                            '-',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '1',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '+',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
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

class SwipeableCartItem extends StatelessWidget {
  final String id; // Unique identifier
  final String image;
  final String title;
  final int price;

  const SwipeableCartItem({
    Key? key,
    required this.id,
    required this.image,
    required this.title,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id), // Use a unique key
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Handle item removal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title removed from cart')),
        );
      },
      child: CartItemWidget(
        image: image,
        title: title,
        price: price,
      ),
    );
  }
}

class CartController extends GetxController {
  // Add your cart logic here
  // Example: List<Item> items = <Item>[].obs;
}
