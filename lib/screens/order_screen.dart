import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F8),
        ),
        constraints: BoxConstraints(maxWidth: 480, minHeight: screenHeight),
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05, // Adjusted padding
          screenHeight * 0.05, // Adjusted padding
          screenWidth * 0.05, // Adjusted padding
          screenHeight * 0.05, // Adjusted padding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Bar with Back Button and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Image.asset(
                    "assets/chevron-left.png",
                    scale: 30,
                  ),
                  onPressed: () {
                    // Add navigation back action here
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "Orders",
                  style: TextStyle(
                    fontFamily: "SF-Pro-Text",
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06, // Adjusted font size
                  ),
                ),
                const SizedBox(width: 48), // Placeholder for alignment
              ],
            ),
            SizedBox(height: screenHeight * 0.04), // Adjusted spacing

            // Illustration and Message
            Expanded(
              child: Column(
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
              ),
            ),

            // Start Ordering Button
            Container(
              width: double.infinity,
              height: screenHeight * 0.08, // Adjusted height
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
}
