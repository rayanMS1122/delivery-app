import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final VoidCallback onSignOut;

  const DrawerWidget({Key? key, required this.onSignOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 155),
              _buildDrawerItem("Profile", "assets/user.png"),
              _buildDrawerItem("Orders", "assets/orders.png"),
              _buildDrawerItem(
                  "offer and promo", "assets/ic_outline-local-offer.png"),
              _buildDrawerItem(
                  "Privacy policy", "assets/ic_outline-sticky-note-2.png"),
              _buildDrawerItem("Security", "assets/whh_securityalt.png"),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 45.0, left: 33),
                child: MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        "Sign Out",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SF-Pro-Italic.ttf",
                        ),
                      ),
                      const SizedBox(width: 10),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Image.asset(iconPath, scale: 30, color: Colors.white),
                        const SizedBox(width: 15),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: "San-Francisco-Pro-Fonts-master",
                          ),
                        ),
                      ],
                    ),
                    Container(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(
              thickness: 1,
              endIndent: 43,
              indent: 80,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}
