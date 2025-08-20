import 'package:delivery_app/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class OrderController extends GetxController {
  // Observable list of orders
  var orders = <Map<String, dynamic>>[].obs;
  // Observable for filtered orders based on tab
  var filteredOrders = <Map<String, dynamic>>[].obs;
  // Observable to track loading state
  var isLoading = true.obs;
  // Observable for current tab
  var currentTab = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // Fetch orders when the controller is initialized
  }

  // Method to fetch orders from API
  void fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/users/orders'),
        headers: {
          'Authorization': 'Bearer <user-token>', // Replace with actual token
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        orders.value = data
            .map((order) => {
                  'id': order['id'].toString(),
                  'status': order[
                      'status'], // e.g., "delivered", "pending", "cancelled"
                  'date': _formatDate(order['createdAt']),
                  'itemCount': order['items']?.length ?? 0,
                  'total': order['total']?.toDouble() ?? 0.0,
                })
            .toList();
        filterOrders(currentTab.value);
      } else {
        Get.snackbar('Error', 'Failed to fetch orders');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to format date
  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('MMM dd, yyyy').format(parsedDate);
  }

  // Method to filter orders based on tab
  void filterOrders(String tab) {
    currentTab.value = tab;
    if (tab == 'All') {
      filteredOrders.value = orders;
    } else {
      filteredOrders.value = orders.where((order) {
        final status = order['status'].toString().toLowerCase();
        if (tab == 'In Progress') {
          return status == 'pending' || status == 'shipped';
        } else if (tab == 'Delivered') {
          return status == 'delivered';
        } else if (tab == 'Cancelled') {
          return status == 'cancelled';
        }
        return true;
      }).toList();
    }
  }
}
