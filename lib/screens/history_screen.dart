import 'package:delivery_app/controllers/history_controller.dart';
import 'package:delivery_app/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  // Initialize the controller
  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  0.05, // 5% of screen width
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  "History",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 40),

                // Illustration and Message
                Obx(() {
                  // Use Obx to make this part reactive
                  return historyController.hasHistory.value
                      ? _buildHistoryList() // Show history if it exists
                      : _buildNoHistoryMessage(); // Show message if no history
                }),

                const SizedBox(height: 40),

                // Start Ordering Button
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFFFA4A0C),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFA4A0C).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        // Add navigation or action here
                        // Example: Navigate to a new screen
                        Get.to(() =>
                            OrderScreen()); // Replace OrderScreen with your screen
                      },
                      child: Center(
                        child: Text(
                          "Start Ordering",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to show when there is no history
  Widget _buildNoHistoryMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.history,
          size: 100, // Adjust size as needed
        ),
        const SizedBox(height: 20),
        Text(
          "No history yet",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Hit the orange button below\nto create an order",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Widget to show when there is history
  Widget _buildHistoryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 5, // Replace with actual history data
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Order #${index + 1}"),
          subtitle: Text("Details of order #${index + 1}"),
        );
      },
    );
  }
}
