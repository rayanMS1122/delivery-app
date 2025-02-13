import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/widgets/delivery_options_widget.dart'; // Ensure correct import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Get.width > 640 ? 50 : 25,
          vertical: Get.width > 991 ? 52 : (Get.width > 640 ? 40 : 30),
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
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 58),
              Text(
                "Information",
                style: TextStyle(
                  fontFamily: "SF-Pro-Text",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 19),
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 40,
                        offset: const Offset(0, 10)),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width > 640 ? 63 : 20,
                  vertical: Get.width > 991 ? 26 : (Get.width > 640 ? 20 : 15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/Rectangle 6.png"),
                    const SizedBox(width: 25),
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
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Marvislghedosa@gmail.com",
                          style: TextStyle(
                            fontFamily: "SF-Pro-Text",
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "No 15 uti street off ovie \npalace road \neffurun delta state",
                          style: TextStyle(
                            fontFamily: "SF-Pro-Text",
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 52),
              Text(
                "Payment Method",
                style: TextStyle(
                  fontFamily: "SF-Pro-Text",
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 25),
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
                  horizontal: Get.width > 640 ? 61 : 20,
                  vertical: Get.width > 991 ? 99 : (Get.width > 640 ? 20 : 15),
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
                            const SizedBox(width: 10),
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/bi_credit-card-2-front-fill.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Card",
                              style: TextStyle(
                                fontFamily: "SF-Pro-Text",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 45, indent: 40),
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
                            const SizedBox(width: 10),
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/dashicons_bank.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Bank account",
                              style: TextStyle(
                                fontFamily: "SF-Pro-Text",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 45, indent: 40),
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
                            const SizedBox(width: 10),
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/cib_paypal.png',
                                width: 40,
                                height: 40,
                                scale: 44,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Paypal",
                              style: TextStyle(
                                fontFamily: "SF-Pro-Text",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 45, indent: 40),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.width > 991 ? 162 : (Get.width > 640 ? 100 : 80),
              ),

              // Start Update Button
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
                      // Add navigation or action here#
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
    );
  }
}
