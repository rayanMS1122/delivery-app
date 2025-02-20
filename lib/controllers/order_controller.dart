import 'package:get/get.dart';

class OrderController extends GetxController {
  // Observable list of orders
  var orders = <Order>[].obs;

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

    // Simulate fetching orders (replace with actual API call)
    await Future.delayed(Duration(seconds: 2));

    // Simulate orders data (replace with actual data)
    orders.value = [
      Order(
        title: "Order #123",
        description: "Veggie tomato mix, Spicy fish sauce",
        status: "Delivered",
      ),
      Order(
        title: "Order #124",
        description: "Fish with mix orange, Sauce",
        status: "Pending",
      ),
    ];

    isLoading.value = false; // Hide loading indicator
  }
}

class Order {
  final String title;
  final String description;
  final String status;

  Order({
    required this.title,
    required this.description,
    required this.status,
  });
}
