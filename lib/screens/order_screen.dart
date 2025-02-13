import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _advancedDrawerController = AdvancedDrawerController();

    return AdvancedDrawer(
      drawer: Drawer(),
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 0.0,
        //   ),
        // ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),

      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F8),
          ),
          constraints: const BoxConstraints(maxWidth: 480),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(25, 47, 25, 47),
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
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder for alignment
                ],
              ),
              const SizedBox(height: 40),

              // Illustration and Message
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons
                          .shopping_cart, // Use a shopping cart icon for orders
                      size: 100,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No orders yet",
                      style: TextStyle(
                        fontFamily: "SF-Pro-Text",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Hit the orange button below\nto create your first order",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "SF-Pro-Text",
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

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
                    },
                    child: Center(
                      child: Text(
                        "Start Ordering",
                        style: TextStyle(
                          fontFamily: "SF-Pro-Text",
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
        drawer: Drawer(),
      ),
    );
  }
}
