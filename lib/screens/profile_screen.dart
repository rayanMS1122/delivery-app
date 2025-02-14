import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/widgets/delivery_options_widget.dart'; // Ensure correct import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05, // Adjusted padding
          vertical: screenHeight * 0.03, // Adjusted padding
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar with Back Button and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontFamily: "SF-Pro-Text",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06, // Adjusted font size
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04), // Adjusted spacing
              Text(
                "Information",
                style: TextStyle(
                  fontFamily: "SF-Pro-Text",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.055, // Adjusted font size
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Adjusted spacing
              Container(
                width: double.infinity,
                height: screenHeight * 0.22, // Adjusted height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, // Adjusted padding
                  vertical: screenHeight * 0.02, // Adjusted padding
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/Rectangle 6.png"),
                    SizedBox(width: screenWidth * 0.04), // Adjusted spacing
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Marvis lghedosa",
                          style: TextStyle(
                            fontFamily: "SF-Pro-Text",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.05, // Adjusted font size
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.01), // Adjusted spacing
                        Text(
                          "Marvislghedosa@gmail.com",
                          style: TextStyle(
                            fontFamily: "SF-Pro-Text",
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04, // Adjusted font size
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.02), // Adjusted spacing
                        Text(
                          "No 15 uti street off ovie \npalace road \neffurun delta state",
                          style: TextStyle(
                            fontFamily: "SF-Pro-Text",
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04, // Adjusted font size
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04), // Adjusted spacing
              Text(
                "Payment Method",
                style: TextStyle(
                  fontFamily: "SF-Pro-Text",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.055, // Adjusted font size
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Adjusted spacing
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, // Adjusted padding
                  vertical: screenHeight * 0.02, // Adjusted padding
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            SizedBox(
                                width: screenWidth * 0.02), // Adjusted spacing
                            Container(
                              width: screenWidth * 0.12, // Adjusted size
                              height: screenWidth * 0.12, // Adjusted size
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/bi_credit-card-2-front-fill.png',
                                width: screenWidth * 0.08, // Adjusted size
                                height: screenWidth * 0.08, // Adjusted size
                              ),
                            ),
                            SizedBox(
                                width: screenWidth * 0.03), // Adjusted spacing
                            Text(
                              "Card",
                              style: TextStyle(
                                fontFamily: "SF-Pro-Text",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.045, // Adjusted font size
                              ),
                            ),
                          ],
                        ),
                        Divider(
                            height: screenHeight * 0.03,
                            indent: screenWidth * 0.1), // Adjusted spacing
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            SizedBox(
                                width: screenWidth * 0.02), // Adjusted spacing
                            Container(
                              width: screenWidth * 0.12, // Adjusted size
                              height: screenWidth * 0.12, // Adjusted size
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/dashicons_bank.png',
                                width: screenWidth * 0.08, // Adjusted size
                                height: screenWidth * 0.08, // Adjusted size
                              ),
                            ),
                            SizedBox(
                                width: screenWidth * 0.03), // Adjusted spacing
                            Text(
                              "Bank account",
                              style: TextStyle(
                                fontFamily: "SF-Pro-Text",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.045, // Adjusted font size
                              ),
                            ),
                          ],
                        ),
                        Divider(
                            height: screenHeight * 0.03,
                            indent: screenWidth * 0.1), // Adjusted spacing
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            SizedBox(
                                width: screenWidth * 0.02), // Adjusted spacing
                            Container(
                              width: screenWidth * 0.12, // Adjusted size
                              height: screenWidth * 0.12, // Adjusted size
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/cib_paypal.png',
                                width: screenWidth * 0.08, // Adjusted size
                                height: screenWidth * 0.08, // Adjusted size
                                scale: 44,
                              ),
                            ),
                            SizedBox(
                                width: screenWidth * 0.03), // Adjusted spacing
                            Text(
                              "Paypal",
                              style: TextStyle(
                                fontFamily: "SF-Pro-Text",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    screenWidth * 0.045, // Adjusted font size
                              ),
                            ),
                          ],
                        ),
                        Divider(
                            height: screenHeight * 0.03,
                            indent: screenWidth * 0.1), // Adjusted spacing
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04), // Adjusted spacing

              // Start Update Button
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor:
                                Colors.transparent, // Transparent background
                            insetPadding:
                                const EdgeInsets.all(20), // Add padding
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      300), // Set max width for the dialog
                              child: DeliveryOptionsWidget(),
                            ),
                          );
                        },
                      );
                    },
                    child: Center(
                      child: Text(
                        "Update",
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
      ),
    );
  }
}
