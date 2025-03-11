import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:delivery_app/widgets/delivery_options_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.055,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: const Color(0xFFFA4A0C)),
            onPressed: () {
              // TODO: Navigate to edit profile screen
              Get.snackbar(
                "Edit Profile",
                "Edit profile functionality coming soon",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black54,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.01,
        ),
        child: RefreshIndicator(
          color: const Color(0xFFFA4A0C),
          onRefresh: () async {
            // Simulate profile refresh
            await Future.delayed(Duration(seconds: 1));
            Get.snackbar(
              "Refreshed",
              "Profile updated successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                _buildProfileHeader(context),
                SizedBox(height: screenHeight * 0.03),

                // Sections with custom headers
                _buildSectionHeader(
                    context, "Personal Information", Icons.person),
                _buildInformationCard(context),
                SizedBox(height: screenHeight * 0.03),

                _buildSectionHeader(context, "Payment Methods", Icons.payment),
                _buildPaymentMethodsCard(context),
                SizedBox(height: screenHeight * 0.03),

                _buildSectionHeader(
                    context, "Delivery Options", Icons.delivery_dining),
                _buildDeliveryPreferencesCard(context),
                SizedBox(height: screenHeight * 0.03),

                _buildSectionHeader(
                    context, "Account Settings", Icons.settings),
                _buildSettingsCard(context),
                SizedBox(height: screenHeight * 0.04),

                // Update Button
                _buildUpdateButton(context),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.25,
            height: screenWidth * 0.25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFA4A0C), Color(0xFFFF6B3A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFA4A0C).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(3),
              child: ClipOval(
                child: Image.asset(
                  "assets/Rectangle 6.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            "Marvis lghedosa",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.055,
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 18),
              Text(
                " Premium Member",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFA4A0C), size: screenWidth * 0.05),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return _buildCard(
      context,
      child: Column(
        children: [
          _buildInfoRow(
              context, "Email", "Marvislghedosa@gmail.com", Icons.email),
          Divider(height: screenHeight * 0.03),
          _buildInfoRow(
              context,
              "Address",
              "No 15 uti street off ovie palace road, effurun delta state",
              Icons.location_on),
          Divider(height: screenHeight * 0.03),
          _buildInfoRow(context, "Phone", "+234 9011039271", Icons.phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context, String label, String value, IconData icon) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFA4A0C).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFFFA4A0C), size: screenWidth * 0.05),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: screenWidth * 0.035,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return _buildCard(
      context,
      child: Obx(() {
        return Column(
          children: [
            _buildPaymentMethod(
              context,
              "Credit Card",
              'assets/bi_credit-card-2-front-fill.png',
              Colors.orange,
              controller.isCardSelected.value,
              (value) {
                controller.toggleCardSelection(value);
              },
            ),
            Divider(height: screenHeight * 0.03),
            _buildPaymentMethod(
              context,
              "Bank Account",
              'assets/dashicons_bank.png',
              Colors.pink,
              controller.isBankSelected.value,
              (value) {
                controller.toggleBankSelection(value);
              },
            ),
            Divider(height: screenHeight * 0.03),
            _buildPaymentMethod(
              context,
              "PayPal",
              'assets/cib_paypal.png',
              Colors.blue[900]!,
              controller.isPaypalSelected.value,
              (value) {
                controller.togglePaypalSelection(value);
              },
            ),
            Divider(height: screenHeight * 0.03),
            _buildAddPaymentMethod(context),
          ],
        );
      }),
    );
  }

  Widget _buildAddPaymentMethod(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Get.snackbar(
          "Add Payment Method",
          "This feature is coming soon",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, color: Color(0xFFFA4A0C)),
          SizedBox(width: 10),
          Text(
            "Add Payment Method",
            style: TextStyle(
              color: Color(0xFFFA4A0C),
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryPreferencesCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return _buildCard(
      context,
      child: Column(
        children: [
          _buildPreferenceItem(
            context,
            "Door Delivery",
            "Delivery to your doorstep",
            true,
          ),
          Divider(height: screenHeight * 0.03),
          _buildPreferenceItem(
            context,
            "Pick up",
            "Pick up at a convenient location",
            false,
          ),
          Divider(height: screenHeight * 0.03),
          _buildPreferenceItem(
            context,
            "Fast Delivery",
            "Express delivery service",
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(
      BuildContext context, String title, String description, bool isActive) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.042,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: screenWidth * 0.035,
              ),
            ),
          ],
        ),
        Switch(
          value: isActive,
          onChanged: (value) {},
          activeColor: Colors.white,
          activeTrackColor: Color(0xFFFA4A0C),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return _buildCard(
      context,
      child: Column(
        children: [
          _buildSettingItem(
              context, "Notifications", Icons.notifications, true),
          Divider(height: screenHeight * 0.03),
          _buildSettingItem(context, "Dark Mode", Icons.dark_mode, false),
          Divider(height: screenHeight * 0.03),
          _buildSettingItem(context, "Security", Icons.security, true),
          Divider(height: screenHeight * 0.03),
          _buildSettingItem(context, "Language", Icons.language, false),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
      BuildContext context, String title, IconData icon, bool isActive) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFA4A0C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: Color(0xFFFA4A0C), size: screenWidth * 0.05),
            ),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: screenWidth * 0.04,
              ),
            ),
          ],
        ),
        Switch(
          value: isActive,
          onChanged: (value) {},
          activeColor: Colors.white,
          activeTrackColor: Color(0xFFFA4A0C),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      child: child,
    );
  }

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
        onChanged(!isSelected);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFA4A0C) : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
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
              width: screenWidth * 0.12,
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: screenWidth * 0.07,
                  height: screenWidth * 0.07,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.042,
                    ),
                  ),
                  if (isSelected && title == "Credit Card")
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "•••• •••• •••• 4242",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: const Color(0xFFFA4A0C),
                size: screenWidth * 0.05,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: screenHeight * 0.07,
      child: ElevatedButton(
        onPressed: () {
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [Color(0xFFFA4A0C), Color(0xFFFF6B3A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFA4A0C).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.update,
                  color: Colors.white,
                  size: screenWidth * 0.05,
                ),
                SizedBox(width: 10),
                Text(
                  "Update Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.045,
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
