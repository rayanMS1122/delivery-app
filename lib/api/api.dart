import 'dart:convert';

import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:delivery_app/controllers/order_controller.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/models/product.dart';
import 'package:delivery_app/widgets/build_featured_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // main main main main main main main
  static const baseUrl = "https://delivery-app-wd4t.onrender.com/api/";
  static const baseAuth = "https://delivery-app-wd4t.onrender.com/auth/";

  // static const baseUrl = "http://localhost:3000/api/"; // for local use
  // static const baseAuth = "http://localhost:3000/auth/"; // for local use
  // http://localhost:3000/auth/register

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

  static createUser(String email, String password, String name, page) async {
    var url = Uri.parse("${baseAuth}register");
    final res = await http.post(url, body: {
      "email": email,
      "password": password,
      "name": name,
    });
    if (res.statusCode == 201) {
      print(jsonDecode(res.body));
      Get.to(page);
    } else {
      print("Failed to Create User. status: ${res.statusCode}");
    }
  }

  static Future<void> loginUser(
      String email, String password, Widget page) async {
    var url = Uri.parse(
        "${baseAuth}login"); // Ensure this points to the correct endpoint
    try {
      final res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (res.statusCode == 200) {
        // Parse the response body
        var responseBody = jsonDecode(res.body);

        // Extract the token and user data
        String token = responseBody['token'];
        var userData = responseBody['user'];

        // Print success message
        print("Login successful: $token");

        // Store the token and user data securely (e.g., using shared_preferences)
        await _storeUserData(token, userData);

        // Navigate to the desired page
        Get.off(page);
      } else if (res.statusCode == 401) {
        print("Invalid credentials");
      } else {
        print(
            "Failed to Login. Status: ${res.statusCode}, Response: ${res.body}");
      }
    } catch (e) {
      print("Error logging in: $e");
    }
  }

// Helper function to store token and user data
  static Future<void> _storeUserData(String token, dynamic userData) async {
    // Use shared_preferences or another secure storage mechanism
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(userData));
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> fetchUserProfile() async {
    // Retrieve the token from storage
    String? token = await getToken();

    if (token == null) {
      print("No token found. Please log in.");
      return;
    }

    var url = Uri.parse("${baseAuth}profile"); // Profile endpoint
    try {
      final res = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        print("User profile: $responseBody");
      } else {
        print(
            "Failed to fetch profile. Status: ${res.statusCode}, Response: ${res.body}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }
}
