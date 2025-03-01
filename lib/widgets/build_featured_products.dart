import 'package:delivery_app/controllers/product_controller.dart';
import 'package:flutter/material.dart';

class BuildFeaturedProductCard extends StatelessWidget {
  final String? name;
  final String? price;
  final String? des;
  final String? image;

  const BuildFeaturedProductCard(
      {super.key, this.name, this.price, this.des, this.image});

  factory BuildFeaturedProductCard.fromJson(Map<String, dynamic> parsedJson) {
    return BuildFeaturedProductCard(
        price: parsedJson['pprice'].toString(),
        name: parsedJson['pname'].toString(),
        des: parsedJson['pdes'].toString(),
        image: parsedJson['pimage'].toString());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    ProductController _productController = ProductController();
    return GestureDetector(
      onTap: () {
        final product = FeaturedProduct(
            name: name!, price: price!, image: "assets/Mask Group (1).png");
        _productController.onProductTap(product);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
        child: Column(
          children: [
            Container(
              width: screenWidth * 0.7,
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
              child: Column(
                children: [
                  Image.network(
                    image!,
                    width: 160,
                    height: 160,
                  ),
                  Text(
                    name!,
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    price!,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFFFF4A3A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
