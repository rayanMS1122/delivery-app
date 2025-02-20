import 'package:delivery_app/controllers/order_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  final OrderController _controller = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05, // Adjusted padding
          screenHeight * 0.05, // Adjusted padding
          screenWidth * 0.05, // Adjusted padding
          screenHeight * 0.05, // Adjusted padding
        ),
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 480, minHeight: screenHeight),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F5F8), Color(0xFFE5E5E8)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Bar with Back Button and Title
            CustomAppBar(
              title: "Orders",
              onBackPressed: () {
                Get.back(); // Use GetX for navigation
              },
            ),
            SizedBox(height: screenHeight * 0.04), // Adjusted spacing

            // Illustration and Message or Orders List
            Expanded(
              child: Obx(() {
                return _controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFA4A0C), // Custom loading color
                        ),
                      ) // Show loading indicator
                    : _controller.orders.isEmpty
                        ? _buildNoOrdersMessage(
                            screenWidth, screenHeight) // Show no orders message
                        : _buildOrdersList(); // Show list of orders
              }),
            ),

            // Start Ordering Button
            Container(
              width: double.infinity,
              height: screenHeight * 0.08, // Adjusted height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [Color(0xFFFA4A0C), Color(0xFFFF6B3A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFA4A0C).withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    // Navigate to the ordering screen
                    // Get.to(() => OrderingScreen()); // Replace with your ordering screen
                  },
                  child: Center(
                    child: Text(
                      "Start Ordering",
                      style: TextStyle(
                        fontFamily: "SF-Pro-Text",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.045, // Adjusted font size
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to show when no orders are available
  Widget _buildNoOrdersMessage(double screenWidth, double screenHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shopping_cart, // Use a shopping cart icon for orders
          size: screenWidth * 0.25, // Adjusted icon size
          color: Colors.grey.withOpacity(0.5),
        ),
        SizedBox(height: screenHeight * 0.02), // Adjusted spacing
        Text(
          "No orders yet",
          style: TextStyle(
            fontFamily: "SF-Pro-Text",
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.07, // Adjusted font size
          ),
        ),
        SizedBox(height: screenHeight * 0.01), // Adjusted spacing
        Text(
          "Hit the orange button below\nto create your first order",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "SF-Pro-Text",
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: screenWidth * 0.04, // Adjusted font size
          ),
        ),
      ],
    );
  }

  // Widget to show list of orders
  Widget _buildOrdersList() {
    final OrderController _controller = Get.find();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _controller.orders.length,
      itemBuilder: (context, index) {
        final order = _controller.orders[index];
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Icon(
              Icons.shopping_bag,
              color: Color(0xFFFA4A0C),
              size: 30,
            ),
            title: Text(
              order.title,
              style: TextStyle(
                fontFamily: "SF-Pro-Text",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              order.description,
              style: TextStyle(
                fontFamily: "SF-Pro-Text",
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: order.status == "Delivered"
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                order.status,
                style: TextStyle(
                  fontFamily: "SF-Pro-Text",
                  color: order.status == "Delivered"
                      ? Colors.green
                      : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
