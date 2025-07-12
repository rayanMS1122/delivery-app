import 'package:delivery_app/controllers/history_controller.dart';
import 'package:delivery_app/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  // Initialize the controller
  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    // Get the responsive values for consistent sizing
    final size = MediaQuery.of(context).size;
    final responsiveValues = ResponsiveValues(size);

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F8),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveValues.horizontalPadding,
                  vertical: responsiveValues.verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Custom App Bar with Title
                    _buildAppBar(responsiveValues),

                    SizedBox(height: responsiveValues.largeSpacing),

                    // Illustration and Message or History list
                    Obx(() {
                      // Use Obx to make this part reactive
                      return historyController.hasHistory.value
                          ? _buildHistoryList(responsiveValues)
                          : _buildNoHistoryMessage(responsiveValues);
                    }),

                    SizedBox(height: responsiveValues.largeSpacing),

                    // Start Ordering Button
                    _buildStartOrderingButton(responsiveValues),

                    SizedBox(height: responsiveValues.spacing),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom App Bar
  Widget _buildAppBar(ResponsiveValues rv) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Title with Search and Filter Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button (if needed)
              Container(),

              // Title
              Text(
                "Order History",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: rv.titleFontSize,
                  letterSpacing: 0.5,
                ),
              ),

              // Filter Icon
              Container(
                padding: EdgeInsets.all(rv.smallPadding / 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(rv.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.filter_list,
                  size: rv.iconSize * 0.8,
                  color: const Color(0xFFFA4A0C),
                ),
              ),
            ],
          ),

          SizedBox(height: rv.spacing),

          // Search Bar
          Container(
            height: rv.inputHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(rv.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              style: TextStyle(
                fontSize: rv.normalFontSize,
              ),
              decoration: InputDecoration(
                hintText: "Search for orders...",
                hintStyle: TextStyle(
                  color: Colors.black38,
                  fontSize: rv.normalFontSize,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black38,
                  size: rv.iconSize,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: rv.smallPadding,
                  horizontal: rv.padding,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show when there is no history
  Widget _buildNoHistoryMessage(ResponsiveValues rv) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: rv.verticalPadding * 2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: rv.logoSize * 2,
            height: rv.logoSize * 2,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.receipt_long,
              size: rv.logoSize,
              color: const Color(0xFFFA4A0C).withOpacity(0.7),
            ),
          ),

          SizedBox(height: rv.spacing),

          // Title
          Text(
            "No Order History",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: rv.sectionTitleFontSize,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: rv.smallSpacing),

          // Description
          Text(
            "You haven't placed any orders yet.\nTap the button below to get started!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: rv.normalFontSize,
              height: 1.5,
            ),
          ),

          SizedBox(height: rv.largeSpacing),

          // Animation Effect (Bouncing Arrow)
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(0, 10, 0),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: rv.iconSize * 1.5,
              color: const Color(0xFFFA4A0C),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to show when there is history
  Widget _buildHistoryList(ResponsiveValues rv) {
    // Sample order data
    final List<Map<String, dynamic>> orders = [
      {
        'id': '8A765',
        'date': '10 Mar, 2025',
        'items': 3,
        'total': '\$32.50',
        'status': 'Completed',
        'statusColor': Colors.green,
      },
      {
        'id': '6B291',
        'date': '5 Mar, 2025',
        'items': 2,
        'total': '\$18.00',
        'status': 'Delivered',
        'statusColor': Colors.green,
      },
      {
        'id': '3C842',
        'date': '28 Feb, 2025',
        'items': 4,
        'total': '\$45.80',
        'status': 'Processing',
        'statusColor': Colors.orange,
      },
      {
        'id': '1D475',
        'date': '15 Feb, 2025',
        'items': 1,
        'total': '\$12.99',
        'status': 'Cancelled',
        'statusColor': Colors.red,
      },
    ];

    return Column(
      children: [
        // Filter Tabs
        Container(
          height: rv.buttonHeight * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(rv.buttonBorderRadius),
          ),
          child: Row(
            children: [
              _buildFilterTab('All', true, rv),
              _buildFilterTab('Completed', false, rv),
              _buildFilterTab('Processing', false, rv),
              _buildFilterTab('Cancelled', false, rv),
            ],
          ),
        ),

        SizedBox(height: rv.spacing),

        // Orders List
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: rv.fieldSpacing),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(rv.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(rv.borderRadius),
                  onTap: () {
                    // Navigate to order details
                  },
                  child: Padding(
                    padding: EdgeInsets.all(rv.padding),
                    child: Column(
                      children: [
                        // Order header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.receipt,
                                  size: rv.iconSize,
                                  color: const Color(0xFFFA4A0C),
                                ),
                                SizedBox(width: rv.smallSpacing),
                                Text(
                                  "Order #${orders[index]['id']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: rv.normalFontSize,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: rv.smallPadding,
                                vertical: rv.smallPadding / 2,
                              ),
                              decoration: BoxDecoration(
                                color: orders[index]['statusColor']
                                    .withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(rv.borderRadius / 2),
                              ),
                              child: Text(
                                orders[index]['status'],
                                style: TextStyle(
                                  color: orders[index]['statusColor'],
                                  fontSize: rv.normalFontSize * 0.8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: rv.smallSpacing),

                        // Divider
                        Divider(color: Colors.black.withOpacity(0.1)),

                        SizedBox(height: rv.smallSpacing),

                        // Order details
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildOrderDetail(
                                'Date', orders[index]['date'], rv),
                            _buildOrderDetail(
                                'Items', orders[index]['items'].toString(), rv),
                            _buildOrderDetail(
                                'Total', orders[index]['total'], rv),
                          ],
                        ),

                        SizedBox(height: rv.spacing),

                        // Track Order Button
                        Container(
                          width: double.infinity,
                          height: rv.buttonHeight * 0.7,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: const Color(0xFFFA4A0C),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    rv.buttonBorderRadius / 2),
                              ),
                            ),
                            child: Text(
                              "Track Order",
                              style: TextStyle(
                                color: const Color(0xFFFA4A0C),
                                fontWeight: FontWeight.w600,
                                fontSize: rv.normalFontSize,
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
          },
        ),
      ],
    );
  }

  // Helper widget for order list filter tabs
  Widget _buildFilterTab(String text, bool isActive, ResponsiveValues rv) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFA4A0C) : Colors.transparent,
          borderRadius: BorderRadius.circular(rv.buttonBorderRadius),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black54,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              fontSize: rv.normalFontSize * 0.85,
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for order details
  Widget _buildOrderDetail(String label, String value, ResponsiveValues rv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black54,
            fontSize: rv.normalFontSize * 0.8,
          ),
        ),
        SizedBox(height: rv.smallSpacing / 2),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: rv.normalFontSize,
          ),
        ),
      ],
    );
  }

  // Widget for Start Ordering Button
  Widget _buildStartOrderingButton(ResponsiveValues rv) {
    return Container(
      width: double.infinity,
      height: rv.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rv.buttonBorderRadius),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFA4A0C),
            Color(0xFFFF7643),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
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
          borderRadius: BorderRadius.circular(rv.buttonBorderRadius),
          onTap: () {
            Get.to(() => OrderScreen());
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: rv.iconSize,
                ),
                SizedBox(width: rv.smallSpacing),
                Text(
                  "Start Ordering",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: rv.buttonFontSize,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ResponsiveValues class to ensure consistent sizing across all devices
class ResponsiveValues {
  double screenWidth = 0;
  double screenHeight = 0;

  late final double horizontalPadding;
  late final double verticalPadding;
  late final double padding;
  late final double smallPadding;

  late final double spacing;
  late final double smallSpacing;
  late final double fieldSpacing;
  late final double largeSpacing;

  late final double logoSize;
  late final double iconSize;

  late final double borderRadius;
  late final double cardBorderRadius;
  late final double buttonBorderRadius;

  late final double titleFontSize;
  late final double subtitleFontSize;
  late final double sectionTitleFontSize;
  late final double normalFontSize;
  late final double buttonFontSize;

  late final double buttonHeight;
  late final double inputHeight;

  ResponsiveValues(Size size) {
    screenWidth = size.width;
    screenHeight = size.height;

    // Base all values on a reference width of 375px (iPhone X)
    final double scaleFactor = screenWidth / 375;

    // Apply minimum and maximum constraints to prevent extreme scaling
    double constrainedScale(double value) {
      return value.clamp(0.8, 1.3) * scaleFactor;
    }

    // Set all responsive values
    horizontalPadding = 20 * constrainedScale(1.0);
    verticalPadding = 20 * constrainedScale(1.0);
    padding = 16 * constrainedScale(1.0);
    smallPadding = 10 * constrainedScale(1.0);

    spacing = 20 * constrainedScale(1.0);
    smallSpacing = 8 * constrainedScale(1.0);
    fieldSpacing = 16 * constrainedScale(1.0);
    largeSpacing = 30 * constrainedScale(1.0);

    logoSize = 70 * constrainedScale(1.0);
    iconSize = 24 * constrainedScale(1.0);

    borderRadius = 12 * constrainedScale(1.0);
    cardBorderRadius = 20 * constrainedScale(1.0);
    buttonBorderRadius = 30 * constrainedScale(1.0);

    titleFontSize = 24 * constrainedScale(1.0);
    subtitleFontSize = 16 * constrainedScale(1.0);
    sectionTitleFontSize = 20 * constrainedScale(1.0);
    normalFontSize = 14 * constrainedScale(1.0);
    buttonFontSize = 16 * constrainedScale(1.0);

    buttonHeight = 56 * constrainedScale(1.0);
    inputHeight = 50 * constrainedScale(1.0);
  }
}
