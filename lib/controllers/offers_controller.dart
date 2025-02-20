import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MyOffersController extends GetxController {
  // Observable list of offers
  var offers = <Offer>[].obs;

  // Observable to track loading state
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOffers(); // Fetch offers when the controller is initialized
  }

  // Method to fetch offers (simulated for now)
  void fetchOffers() async {
    isLoading.value = true; // Show loading indicator

    // Simulate fetching offers (replace with actual API call)
    await Future.delayed(Duration(seconds: 2));

    // Simulate offers data (replace with actual data)
    offers.value = [
      Offer(
        title: "Special Discount",
        description: "Get 20% off on your next order",
        discount: "20% OFF",
      ),
      Offer(
        title: "Free Delivery",
        description: "Enjoy free delivery on orders above \$50",
        discount: "FREE",
      ),
    ];

    isLoading.value = false; // Hide loading indicator
  }
}

class Offer {
  final String title;
  final String description;
  final String discount;

  Offer({
    required this.title,
    required this.description,
    required this.discount,
  });
}
