import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final VoidCallback onSignOut;

  const DrawerWidget({Key? key, required this.onSignOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        width: screenWidth * 0.8, // Adjust drawer width based on screen size
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: screenHeight * 0.2), // Adjust spacing dynamically
              _buildDrawerItem("Profile", "assets/user.png"),
              _buildDrawerItem("Orders", "assets/orders.png"),
              _buildDrawerItem(
                  "Offer and Promo", "assets/ic_outline-local-offer.png"),
              _buildDrawerItem(
                  "Privacy Policy", "assets/ic_outline-sticky-note-2.png"),
              _buildDrawerItem("Security", "assets/whh_securityalt.png"),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight * 0.05, // Adjust padding dynamically
                  left: screenWidth * 0.1, // Adjust padding dynamically
                ),
                child: MaterialButton(
                  onPressed: onSignOut,
                  child: Row(
                    children: [
                      Text(
                        "Sign Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth *
                              0.05, // Adjust font size dynamically
                          fontWeight: FontWeight.w600,
                          fontFamily: "SF-Pro-Italic.ttf",
                        ),
                      ),
                      SizedBox(
                          width:
                              screenWidth * 0.02), // Adjust spacing dynamically
                      Image.asset("assets/Arrow_Right_MD.png", scale: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, String iconPath) {
    return MaterialButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(iconPath, scale: 30, color: Colors.white),
                SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: "San-Francisco-Pro-Fonts-master",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1,
              endIndent: 43,
              indent: 0,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}
