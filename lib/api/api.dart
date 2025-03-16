import 'dart:convert';
import 'dart:io';

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
import 'package:http_parser/http_parser.dart';

class Api {
  // Base URLs
  static const baseUrl = "https://delivery-app-wd4t.onrender.com/api/";
  static const baseAuth = "https://delivery-app-wd4t.onrender.com/auth/";

  // static const baseUrl = "http://localhost:3000/api/"; // for local use
  // static const baseAuth = "http://localhost:3000/auth/"; // for local use
  // http://localhost:3000/auth/register

  // Add Product method
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

  // Get Products method
  static getProduct() async {
    List<Product> products = [];
    var url = Uri.parse("${baseUrl}get_product");
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
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
      return [];
    }
  }

  // Get Cart method
  static Future<List<CartItem>> getCart() async {
    List<CartItem> cartItem = <CartItem>[].obs;
    var url = Uri.parse("${baseUrl}get_carts");
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
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

  // Get Orders method
  static Future<List<Order>> getOrders() async {
    List<Order> cartItem = <Order>[].obs;
    var url = Uri.parse("${baseUrl}get_orders");
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
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

  // Update Product method
  static updateProduct(id, body) async {
    try {
      var url = Uri.parse("${baseUrl}update/$id");
      final res = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
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

  // Delete Product method
  static deleteProduct(id) async {
    var url = Uri.parse("${baseUrl}delete/$id");
    final res = await http.post(url);
    if (res.statusCode == 204) {
      print(jsonDecode(res.body));
    } else {
      print("Failed to delete");
    }
  }

  // Create User method
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

  // Login User method
  static Future<void> loginUser(
      String email, String password, Widget page) async {
    var url = Uri.parse("${baseAuth}login");
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
        var responseBody = jsonDecode(res.body);
        String token = responseBody['token'];
        var userData = responseBody['user'];
        print("Login successful: $token");
        await _storeUserData(token, userData);
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

  // Store User Data method
  static Future<void> _storeUserData(String token, dynamic userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(userData));
  }

  // Get User Data method
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      return jsonDecode(userJson);
    }
    return null;
  }

  // Get Token method
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fetch User Profile method
  static Future<void> fetchUserProfile() async {
    String? token = await getToken();

    if (token == null) {
      print("No token found. Please log in.");
      return;
    }

    var url = Uri.parse("${baseAuth}profile");
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

  // ADDED: Update User Data method
  static Future<bool> updateUserData(Map<String, dynamic> userData) async {
    String? token = await getToken();

    if (token == null) {
      print("No token found. Please log in.");
      return false;
    }

    var url = Uri.parse("${baseAuth}update-profile");
    try {
      final res = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(userData),
      );

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        print("Profile updated successfully: $responseBody");

        // Update stored user data
        await _storeUserData(token, responseBody['user'] ?? userData);
        return true;
      } else {
        print(
            "Failed to update profile. Status: ${res.statusCode}, Response: ${res.body}");
        return false;
      }
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }

  // ADDED: Upload Profile Image method
  static Future<bool> uploadProfileImage(String imagePath) async {
    String? token = await getToken();

    if (token == null) {
      print("No token found. Please log in.");
      return false;
    }

    var url = Uri.parse("${baseAuth}upload-profile-image");

    try {
      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Add the image file
      var file = await http.MultipartFile.fromPath(
        'profile_image',
        imagePath,
        contentType: MediaType('image', _getImageMimeType(imagePath)),
      );
      request.files.add(file);

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        print("Profile image uploaded successfully: $responseBody");

        // Update stored user data if it contains the image URL
        if (responseBody['user'] != null) {
          await _storeUserData(token, responseBody['user']);
        }
        return true;
      } else {
        print(
            "Failed to upload profile image. Status: ${response.statusCode}, Response: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error uploading profile image: $e");
      return false;
    }
  }

  // Helper method to determine image MIME type
  static String _getImageMimeType(String path) {
    if (path.toLowerCase().endsWith('.jpg') ||
        path.toLowerCase().endsWith('.jpeg')) {
      return 'jpeg';
    } else if (path.toLowerCase().endsWith('.png')) {
      return 'png';
    } else if (path.toLowerCase().endsWith('.gif')) {
      return 'gif';
    } else if (path.toLowerCase().endsWith('.webp')) {
      return 'webp';
    } else {
      return 'jpeg'; // Default to JPEG if unknown
    }
  }

  // ADDED: Logout method
  static Future<bool> logout(page) async {
    String? token = await getToken();

    if (token == null) {
      print("No token found. Already logged out.");
      // Clear any remaining preferences to be safe
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.off(page);
      return true;
    }

    var url = Uri.parse("${baseAuth}logout");
    try {
      final res = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      // Regardless of the server response, clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');

      if (res.statusCode == 200) {
        print("Logged out successfully");
        Get.off(page);
        return true;
      } else {
        print(
            "Server logout failed but local session cleared. Status: ${res.statusCode}");
        return true; // Still return true since we've cleared the local session
      }
    } catch (e) {
      print("Error during logout: $e");
      // Still clear local storage even if the API call fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');
      return true;
    }
  }
}
