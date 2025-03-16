import 'package:delivery_app/api/api.dart';
import 'package:delivery_app/controllers/order_controller.dart';
import 'package:delivery_app/models/order.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderController _controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() async {
    final data = await Api.getOrders();
    _controller.orders.assignAll(data);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8F9FF), Color(0xFFEDF1F9)],
            stops: [0.2, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background patterns
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFA4A0C).withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: -50,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3D5CFF).withOpacity(0.05),
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05,
                  screenHeight * 0.02,
                  screenWidth * 0.05,
                  screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom App Bar with elevated design
                    Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Get.back(),
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Color(0xFF3D3D3D),
                                size: 18,
                              ),
                            ),
                          ),
                          Text(
                            "My Orders",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: Color(0xFF3D3D3D),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.filter_list_rounded,
                              color: Color(0xFF3D3D3D),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Orders counter and search bar
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Obx(() => Row(
                            children: [
                              Text(
                                "${_controller.orders.length} ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFFA4A0C),
                                ),
                              ),
                              Text(
                                "Orders",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF3D3D3D),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: screenWidth * 0.55,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    hintText: "Search orders...",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),

                    // Order tabs
                    Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildTab("All", true),
                          _buildTab("In Progress", false),
                          _buildTab("Delivered", false),
                          _buildTab("Cancelled", false),
                        ],
                      ),
                    ),

                    // Orders list or empty state
                    Expanded(
                      child: Obx(() {
                        return _controller.isLoading.value
                            ? Center(
                                child: Lottie.asset(
                                  'assets/delivery-loading.json',
                                  width: screenWidth * 0.5,
                                  height: screenWidth * 0.5,
                                ),
                              )
                            : _controller.orders.isEmpty
                                ? _buildNoOrdersMessage(
                                    screenWidth, screenHeight)
                                : _buildOrdersList(screenWidth);
                      }),
                    ),

                    // Start Ordering Button with interactive effects
                    Container(
                      width: double.infinity,
                      height: screenHeight * 0.075,
                      margin: EdgeInsets.only(top: screenHeight * 0.01),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the ordering screen
                          // Get.to(() => OrderingScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              colors: [Color(0xFFFA4A0C), Color(0xFFFF6E40)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFA4A0C).withOpacity(0.4),
                                blurRadius: 15,
                                offset: Offset(0, 8),
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: Container(
                            width: double.infinity,
                            height: screenHeight * 0.075,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Start Ordering",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isActive) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFFA4A0C) : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? Color(0xFFFA4A0C).withOpacity(0.3)
                : Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Color(0xFF7C7C7C),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Widget to show when no orders are available - enhanced with animation
  Widget _buildNoOrdersMessage(double screenWidth, double screenHeight) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.6,
            height: screenWidth * 0.6,
            margin: EdgeInsets.only(bottom: 20),
            child: Lottie.asset(
              'assets/empty-box.json',
              repeat: true,
              reverse: true,
            ),
          ),
          Text(
            "No Orders Yet",
            style: TextStyle(
              color: Color(0xFF3D3D3D),
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: screenWidth * 0.7,
            child: Text(
              "Hit the orange button below to browse our menu and place your first order",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 25),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFFFA4A0C),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show list of orders with advanced card design
  Widget _buildOrdersList(double screenWidth) {
    print(_controller.orders);
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _controller.orders.length,
      itemBuilder: (context, index) {
        final order = _controller.orders[index];
        final bool isDelivered = order.status == "Delivered";
        final bool isInProgress = order.status == "In Progress";
        final bool isCancelled = order.status == "Cancelled";

        // Added these variables for the example
        final DateTime orderDate =
            DateTime.now().subtract(Duration(days: index));
        final String formattedDate =
            DateFormat("MMM dd, yyyy").format(orderDate);
        final int itemCount = 3 + index % 3; // Example item count
        final double orderTotal = 15.99 + (index * 4.5); // Example order total

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Navigate to order details
                },
                splashColor: Color(0xFFFA4A0C).withOpacity(0.1),
                highlightColor: Color(0xFFFA4A0C).withOpacity(0.05),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order header with status badge
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Color(0xFFFA4A0C).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isDelivered
                                  ? Icons.check_circle_outline
                                  : isInProgress
                                      ? Icons.delivery_dining
                                      : isCancelled
                                          ? Icons.cancel_outlined
                                          : Icons.shopping_bag_outlined,
                              color: Color(0xFFFA4A0C),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order #${10000 + index}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xFF3D3D3D),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDelivered
                                  ? Colors.green.withOpacity(0.1)
                                  : isInProgress
                                      ? Colors.orange.withOpacity(0.1)
                                      : isCancelled
                                          ? Colors.red.withOpacity(0.1)
                                          : Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              order.status!,
                              style: TextStyle(
                                color: isDelivered
                                    ? Colors.green
                                    : isInProgress
                                        ? Colors.orange
                                        : isCancelled
                                            ? Colors.red
                                            : Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Divider
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                            height: 1, color: Colors.grey.withOpacity(0.2)),
                      ),

                      // Order details
                      Row(
                        children: [
                          _buildOrderDetail("Items", "$itemCount items"),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.grey.withOpacity(0.2),
                            margin: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          _buildOrderDetail(
                              "Total", "\$${orderTotal.toStringAsFixed(2)}"),
                        ],
                      ),

                      // Action button
                      if (!isCancelled)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 16),
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDelivered
                                  ? Colors.green
                                  : Color(0xFFFA4A0C),
                              width: 1.5,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Action based on order status
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Center(
                                child: Text(
                                  isDelivered ? "Reorder" : "Track Order",
                                  style: TextStyle(
                                    color: isDelivered
                                        ? Colors.green
                                        : Color(0xFFFA4A0C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
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
          ),
        );
      },
    );
  }

  Widget _buildOrderDetail(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF3D3D3D),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
