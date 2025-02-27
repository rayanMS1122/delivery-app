import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/widgets/delivery_options_widget.dart'; // Ensure correct import

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

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
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.06, // Adjusted font size
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.04), // Adjusted spacing

              // Information Section
              Text(
                "Information",
                style: TextStyle(
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

              // Payment Method Section
              Text(
                "Payment Method",
                style: TextStyle(
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
                child: Obx(() {
                  return Column(
                    children: [
                      _buildPaymentMethod(
                        context,
                        "Card",
                        'assets/bi_credit-card-2-front-fill.png',
                        Colors.orange,
                        controller.isCardSelected.value,
                        (value) {
                          controller.toggleCardSelection(value);
                        },
                      ),
                      Divider(
                          height: screenHeight * 0.03,
                          indent: screenWidth * 0.1),
                      _buildPaymentMethod(
                        context,
                        "Bank account",
                        'assets/dashicons_bank.png',
                        Colors.pink,
                        controller.isBankSelected.value,
                        (value) {
                          controller.toggleBankSelection(value);
                        },
                      ),
                      Divider(
                          height: screenHeight * 0.03,
                          indent: screenWidth * 0.1),
                      _buildPaymentMethod(
                        context,
                        "Paypal",
                        'assets/cib_paypal.png',
                        Colors.blue[900]!,
                        controller.isPaypalSelected.value,
                        (value) {
                          controller.togglePaypalSelection(value);
                        },
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.04), // Adjusted spacing

              // Start Update Button
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
                      // Show delivery options dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: const EdgeInsets.all(20),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 300),
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

  // Helper method to build payment method row with custom InkWell design
  Widget _buildPaymentMethod(
    BuildContext context,
    String title,
    String iconPath,
    Color iconColor,
    bool isSelected,
    Function(bool) onChanged,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        onChanged(!isSelected); // Toggle selection
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.5),
        child: Row(
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFA4A0C) : Colors.grey,
                  width: 1,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFA4A0C),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Container(
              width: screenWidth * 0.12, // Adjusted size
              height: screenWidth * 0.12, // Adjusted size
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                iconPath,
                width: screenWidth * 0.08, // Adjusted size
                height: screenWidth * 0.08, // Adjusted size
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045, // Adjusted font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
