import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOffersScreen extends StatelessWidget {
  const MyOffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFF5F5F8),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 306),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 40),
                Text(
                  'My offers',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.7,
                    fontFamily: 'Poppins',
                  ),
                  semanticsLabel: 'My offers',
                ),
                const Spacer(),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'ohh snap! No offers yet',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.56,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                        semanticsLabel: 'No offers available',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bella doesn\'t have any offers\nyet please check again.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.center,
                        semanticsLabel:
                            'Bella has no offers, please check again',
                      ),
                    ],
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
