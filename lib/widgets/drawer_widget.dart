import 'package:delivery_app/controllers/home_controller.dart';
import 'package:delivery_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  final VoidCallback onSignOut;

  const DrawerWidget({Key? key, required this.onSignOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Container(
            width:
                screenWidth * 0.8, // Adjust drawer width based on screen size

            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.27), // Top spacing
                  _buildDrawerItem("Profile", "assets/user.png", () {
                    HomeController().selectedNavIndex = 1.obs;
                  }, context),
                  _buildDrawerItem("Orders", "assets/orders.png", () {
                    HomeController().selectedNavIndex = 2.obs;
                  }, context),
                  _buildDrawerItem("Offer and Promo",
                      "assets/ic_outline-local-offer.png", () {}, context),
                  _buildDrawerItem("Privacy Policy",
                      "assets/ic_outline-sticky-note-2.png", () {}, context),
                  _buildDrawerItem(
                      "Security", "assets/whh_securityalt.png", () {}, context),
                  const Spacer(), // Pushes the sign-out button to the bottom
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenHeight * 0.04, // Bottom padding
                      left: screenWidth * 0.05, // Left padding
                    ),
                    child: MaterialButton(
                      onPressed: onSignOut,
                      child: Row(
                        children: [
                          Text(
                            "Sign Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.045, // Font size
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02), // Spacing
                          Icon(
                            Icons.keyboard_arrow_right_sharp,
                            size: screenWidth * 0.08, // Icon size
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(String title, String iconPath, VoidCallback onpressed,
      BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialButton(
      onPressed: () {
        onpressed();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.02, // Vertical padding
          horizontal: screenWidth * 0.05, // Horizontal padding
        ),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  scale: 30, // Adjust icon scale
                  color: Colors.white,
                ),
                SizedBox(width: screenWidth * 0.04), // Spacing
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1, // Limits the text to a single line
                    overflow:
                        TextOverflow.ellipsis, // Adds "..." when text overflows
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.045, // Font size
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.03), // Spacing
            const Divider(
              thickness: 1,
              endIndent: 20,
              indent: 0,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}
