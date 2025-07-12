import 'package:get/get.dart';

class OrderController extends GetxController {
  // Observable list of orders
  var orders = <Map<String, dynamic>>[].obs;

  // Observable to track loading state
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // Fetch orders when the controller is initialized
  }

  // Method to fetch orders (simulated for now)
  void fetchOrders() async {
    isLoading.value = true; // Show loading indicator

    // Simulate fetching orders
    await Future.delayed(Duration(seconds: 2));

    // Simulate orders data
    orders.value = [
      {
        'id': '1',
        'title': 'Order #001',
        'status': 'Delivered',
        'date': '2025-07-01',
        'total': 29.99,
      },
      {
        'id': '2',
        'title': 'Order #002',
        'status': 'Pending',
        'date': '2025-07-05',
        'total': 45.50,
      },
    ];

    isLoading.value = false; // Hide loading indicator
  }
}
