import 'package:delivery_app/models/order.dart';
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

    isLoading.value = false; // Hide loading indicator
  }
}
