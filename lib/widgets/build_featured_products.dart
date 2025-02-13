import 'package:flutter/material.dart';

class BuildFeaturedProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  const BuildFeaturedProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 220,
            height: 215,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.9)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(57, 57, 57, 0.1),
                  blurRadius: 60,
                  offset: Offset(0, 30),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  top: 95,
                  right: 0,
                  left: 50,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: "San-Francisco-Pro-Fonts-master",
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 180,
                  right: 0,
                  left: 80,
                  child: Text(
                    price,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFFF4A3A),
                      fontFamily: "San-Francisco-Pro-Fonts-master",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -20,
            left: 29,
            child: Image.asset(image, width: 160, height: 160),
          ),
        ],
      ),
    );
    ;
  }
}
