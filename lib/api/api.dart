import 'dart:convert';

import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/screens/home_screen_with_node_js.dart';
import 'package:delivery_app/widgets/build_featured_products.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://192.168.2.209:2000/api/";

  static addProduct(Map pdata) async {
    var url = Uri.parse("${baseUrl}add_product");
    try {
      final res = await http.post(
        url,
        body: pdata,
      );
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("failed to get response!");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // get method
  static getProduct() async {
    List<BuildFeaturedProductCard> products = [];
    var url = Uri.parse("${baseUrl}get_product");
    try {
      final res = await http.get(
        url,
      );
      if (res.statusCode == 200) {
        final response = await http
            .get(Uri.parse("http://192.168.2.209:2000/api/get_product"));
        final List<dynamic> data = json.decode(response.body);

        products = data
            .map((item) => BuildFeaturedProductCard.fromJson(item))
            .toList();

        print(data);

        return products;
      } else {
        print("no data");
        return [];
      }
    } catch (e) {
      print(e);
    }
  }

  // update method
  static updateProduct(id, body) async {
    var url = Uri.parse("${baseUrl}update/$id");
    final res = await http.put(url, body: body);
    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
    } else {
      print("Falied to update data");
    }
  }

  // delete method
  static deleteProduct(id) async {
    var url = Uri.parse("${baseUrl}delete/$id");
    final res = await http.post(url);
    if (res.statusCode == 204) {
      print(jsonDecode(res.body));
    } else {
      print("Failed to delete");
    }
  }
}
