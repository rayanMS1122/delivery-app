import 'package:delivery_app/controllers/product_controller.dart';
import 'package:flutter/material.dart';

class BuildFeaturedProduct {
  final String? name;
  final String? price;
  final String? des;
  final String image;

  const BuildFeaturedProduct(
      {this.name, this.price, this.des, required this.image});

  factory BuildFeaturedProduct.fromJson(Map<String, dynamic> parsedJson) {
    return BuildFeaturedProduct(
        price: parsedJson['pprice'].toString(),
        name: parsedJson['pname'].toString(),
        des: parsedJson['pdes'].toString(),
        image: parsedJson['pimage'].toString());
  }
}
