import 'dart:convert';

import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/controllers/order_controller.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/widgets/build_featured_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;

class Api {
  // main main main main main main main
  // static const baseUrl = "https://delivery-app-wd4t.onrender.com/api/";

  static const baseUrl = "http://localhost:2000/api/";

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
    List<Product> products = [];
    var url = Uri.parse("${baseUrl}get_product");
    try {
      final res = await http.get(
        url,
      );
      if (res.statusCode == 200) {
        // final response = await http
        //     .get(Uri.parse("http://192.168.2.209:2000/api/get_product"));

        final List<dynamic> data = json.decode(res.body);

        products = data.map((item) => Product.fromJson(item)).toList();

        print(data);

        return products;
      } else {
        print("no data: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<List<CartItem>> getCart() async {
    List<CartItem> cartItem = <CartItem>[].obs;
    var url = Uri.parse("${baseUrl}get_carts");
    try {
      final res = await http.get(url);

      print("APIsssssssss Response: ${res.body}"); // Debugging

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);

        print("Decoded Data: $data"); // Debugging

        cartItem = data.map((item) => CartItem.fromJson(item)).toList();
        return cartItem;
      } else {
        print("No data: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching cart: $e");
      return [];
    }
  }

  static Future<List<Order>> getOrders() async {
    List<Order> cartItem = <Order>[].obs;
    var url = Uri.parse("${baseUrl}get_orders");
    try {
      final res = await http.get(url);

      print("API Response: ${res.body}"); // Debugging

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);

        print("Decoded Data: $data"); // Debugging

        cartItem = data.map((item) => Order.fromJson(item)).toList();
        return cartItem;
      } else {
        print("No data: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching cart: $e");
      return [];
    }
  }

  // update method
  static updateProduct(id, body) async {
    try {
      var url = Uri.parse("${baseUrl}update/$id");
      final res = await http.put(
        headers: {"Content-Type": "application/json"},
        url,
        body: body,
      );
      if (res.statusCode == 200) {
        print("Updated Successfully: ${jsonDecode(res.body)}");
      } else {
        print("Failed to update data. Status Code: ${res.statusCode}");
      }
    } catch (e) {
      print(e);
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
