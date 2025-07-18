import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  final ProfileController controller = Get.find<ProfileController>();
  static const Color primaryColor = Color(0xFFFF460A);
  static const Color secondaryColor = Color(0xFFFF8A65);
  static const Color darkColor = Color(0xFF1A1A1A);
  static const Color lightColor = Color(0xFFF8F9FF);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  double _scaleFactor(BuildContext context) =>
      MediaQuery.of(context).size.width / 360;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _showAddAddressDialog(BuildContext context, double scale) async {
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final postalCodeController = TextEditingController();
    final countryController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add New Address',
          style: GoogleFonts.poppins(
              fontSize: 18 * scale, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: streetController,
                label: 'Street',
                icon: Icons.location_city_rounded,
                scale: scale,
              ),
              _buildTextField(
                controller: cityController,
                label: 'City',
                icon: Icons.location_city_rounded,
                scale: scale,
              ),
              _buildTextField(
                controller: stateController,
                label: 'State',
                icon: Icons.map_rounded,
                scale: scale,
              ),
              _buildTextField(
                controller: postalCodeController,
                label: 'Postal Code',
                icon: Icons.local_post_office_rounded,
                scale: scale,
              ),
              _buildTextField(
                controller: countryController,
                label: 'Country',
                icon: Icons.flag_rounded,
                scale: scale,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                  color: Colors.grey[600], fontSize: 14 * scale),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.addNewAddress(
                street: streetController.text,
                city: cityController.text,
                state: stateController.text,
                postalCode: postalCodeController.text,
                country: countryController.text,
              );
              if (success) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * scale),
              ),
            ),
            child: Text(
              'Add',
              style: GoogleFonts.poppins(
                  fontSize: 14 * scale, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    // Dispose controllers to prevent memory leaks
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _scaleFactor(context);
    final ImagePicker _picker = ImagePicker();

    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 20 * scale),
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isEditing.value
                      ? Icons.check_rounded
                      : Icons.edit_rounded,
                  color: Colors.white,
                  size: 24 * scale,
                ),
                onPressed: controller.toggleEditMode,
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeWidth: 3 * scale,
            ),
          );
        }

        if (controller.hasError.value) {
          return _buildErrorWidget(context, scale);
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, scale, _picker)),
            SliverToBoxAdapter(
                child: _buildPersonalInfoSection(context, scale)),
            SliverToBoxAdapter(child: _buildAddressesSection(context, scale)),
            SliverToBoxAdapter(child: _buildOrdersSection(context, scale)),
            SliverToBoxAdapter(child: _buildPreferencesSection(context, scale)),
            SliverToBoxAdapter(child: SizedBox(height: 40 * scale)),
          ],
        );
      }),
    );
  }

  Widget _buildErrorWidget(BuildContext context, double scale) => Center(
        child: Container(
          padding: EdgeInsets.all(24 * scale),
          margin: EdgeInsets.all(24 * scale),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20 * scale,
                spreadRadius: 5 * scale,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 70 * scale,
                color: primaryColor.withOpacity(0.7),
              ),
              SizedBox(height: 16 * scale),
              Text(
                'Error loading profile',
                style: GoogleFonts.poppins(
                  fontSize: 18 * scale,
                  fontWeight: FontWeight.bold,
                  color: darkColor,
                ),
              ),
              SizedBox(height: 8 * scale),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14 * scale,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 24 * scale),
              _buildGradientButton(
                onPressed: controller.fetchUserProfile,
                text: 'Retry',
                icon: Icons.refresh_rounded,
                scale: scale,
              ),
            ],
          ),
        ),
      );

  Widget _buildHeader(BuildContext context, double scale, ImagePicker picker) =>
      FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 32 * scale, horizontal: 20 * scale),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(4 * scale),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Obx(() => CircleAvatar(
                          radius: 60 * scale,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: controller
                                  .profileImagePath.value.isNotEmpty
                              ? NetworkImage(controller.profileImagePath.value)
                              : null,
                          child: controller.profileImagePath.value.isEmpty
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 70 * scale,
                                  color: Colors.grey[400],
                                )
                              : null,
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: controller.isEditing.value
                          ? () async {
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                              );
                              if (image != null) {
                                controller.uploadProfileImage(image.path);
                              }
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.isEditing.value
                              ? Colors.white
                              : Colors.grey[200],
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 2 * scale),
                        ),
                        padding: EdgeInsets.all(8 * scale),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: controller.isEditing.value
                              ? primaryColor
                              : Colors.grey,
                          size: 20 * scale,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16 * scale),
              Obx(() => Text(
                    controller.fullName.value.isNotEmpty
                        ? controller.fullName.value
                        : 'User Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
              Obx(() => Text(
                    controller.email.value.isNotEmpty
                        ? controller.email.value
                        : 'No email provided',
                    style: GoogleFonts.poppins(
                      fontSize: 14 * scale,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  )),
              SizedBox(height: 16 * scale),
              Obx(() => Text(
                    'Loyalty Points: ${controller.loyaltyPoints.value}',
                    style: GoogleFonts.poppins(
                      fontSize: 14 * scale,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  )),
            ],
          ),
        ),
      );

  Widget _buildPersonalInfoSection(BuildContext context, double scale) =>
      FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 20 * scale, vertical: 16 * scale),
            padding: EdgeInsets.all(20 * scale),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20 * scale,
                  spreadRadius: 5 * scale,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Personal Information',
                    Icons.person_outline_rounded, scale),
                SizedBox(height: 16 * scale),
                _buildTextField(
                  controller: controller.nameController,
                  label: 'Full Name',
                  icon: Icons.person_rounded,
                  readOnly: !controller.isEditing.value,
                  scale: scale,
                ),
                _buildTextField(
                  controller: controller.emailController,
                  label: 'Email Address',
                  icon: Icons.email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: !controller.isEditing.value,
                  scale: scale,
                ),
                _buildTextField(
                  controller: controller.phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_rounded,
                  keyboardType: TextInputType.phone,
                  readOnly: !controller.isEditing.value,
                  scale: scale,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildAddressesSection(BuildContext context, double scale) =>
      FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 20 * scale, vertical: 16 * scale),
            padding: EdgeInsets.all(20 * scale),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20 * scale,
                  spreadRadius: 5 * scale,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                    'Addresses', Icons.location_on_outlined, scale),
                SizedBox(height: 16 * scale),
                Obx(() => Column(
                      children: controller.addresses.map((address) {
                        final index = controller.addresses.indexOf(address);
                        return _buildAddressCard(
                          address: address,
                          index: index,
                          scale: scale,
                        );
                      }).toList(),
                    )),
                if (controller.isEditing.value)
                  Padding(
                    padding: EdgeInsets.only(top: 16 * scale),
                    child: _buildGradientButton(
                      onPressed: () => _showAddAddressDialog(context, scale),
                      text: 'Add New Address',
                      icon: Icons.add_location_rounded,
                      scale: scale,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Widget _buildAddressCard({
    required Map<String, dynamic> address,
    required int index,
    required double scale,
  }) =>
      Container(
        margin: EdgeInsets.only(bottom: 12 * scale),
        padding: EdgeInsets.all(12 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(
            color: address['isDefault'] ? primaryColor : Colors.grey[200]!,
            width: address['isDefault'] ? 2 * scale : 1 * scale,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  address['isDefault']
                      ? 'Default Address'
                      : 'Address ${index + 1}',
                  style: GoogleFonts.poppins(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w600,
                    color: darkColor,
                  ),
                ),
                if (controller.isEditing.value && !address['isDefault'])
                  IconButton(
                    icon:
                        Icon(Icons.delete, color: Colors.red, size: 20 * scale),
                    onPressed: () => controller.removeAddress(index),
                  ),
              ],
            ),
            SizedBox(height: 8 * scale),
            _buildTextField(
              controller: controller.addressControllers[index]['street']!,
              label: 'Street',
              icon: Icons.location_city_rounded,
              readOnly: !controller.isEditing.value,
              scale: scale,
            ),
            _buildTextField(
              controller: controller.addressControllers[index]['city']!,
              label: 'City',
              icon: Icons.location_city_rounded,
              readOnly: !controller.isEditing.value,
              scale: scale,
            ),
            _buildTextField(
              controller: controller.addressControllers[index]['state']!,
              label: 'State',
              icon: Icons.map_rounded,
              readOnly: !controller.isEditing.value,
              scale: scale,
            ),
            _buildTextField(
              controller: controller.addressControllers[index]['postalCode']!,
              label: 'Postal Code',
              icon: Icons.local_post_office_rounded,
              readOnly: !controller.isEditing.value,
              scale: scale,
            ),
            _buildTextField(
              controller: controller.addressControllers[index]['country']!,
              label: 'Country',
              icon: Icons.flag_rounded,
              readOnly: !controller.isEditing.value,
              scale: scale,
            ),
            if (controller.isEditing.value)
              CheckboxListTile(
                title: Text(
                  'Set as Default',
                  style: GoogleFonts.poppins(fontSize: 14 * scale),
                ),
                value: address['isDefault'],
                onChanged: (value) => controller.setDefaultAddress(index),
                activeColor: primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
          ],
        ),
      );

  Widget _buildOrdersSection(BuildContext context, double scale) =>
      FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 20 * scale, vertical: 16 * scale),
            padding: EdgeInsets.all(20 * scale),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20 * scale,
                  spreadRadius: 5 * scale,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                    'Order History', Icons.shopping_cart_rounded, scale),
                SizedBox(height: 16 * scale),
                Obx(() => Column(
                      children: controller.orders.map((order) {
                        return _buildOrderCard(order: order, scale: scale);
                      }).toList(),
                    )),
              ],
            ),
          ),
        ),
      );

  Widget _buildOrderCard(
          {required Map<String, dynamic> order, required double scale}) =>
      Container(
        margin: EdgeInsets.only(bottom: 12 * scale),
        padding: EdgeInsets.all(12 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12 * scale),
          border: Border.all(color: Colors.grey[200]!, width: 1 * scale),
        ),
        child: ExpansionTile(
          title: Text(
            'Order ${order['orderId']}',
            style: GoogleFonts.poppins(
              fontSize: 16 * scale,
              fontWeight: FontWeight.w600,
              color: darkColor,
            ),
          ),
          subtitle: Text(
            'Total: \$${order['totalAmount'].toStringAsFixed(2)} - ${order['status'].capitalizeFirst}',
            style: GoogleFonts.poppins(
              fontSize: 14 * scale,
              color: Colors.grey[600],
            ),
          ),
          children: [
            ListTile(
              title: Text(
                'Items',
                style: GoogleFonts.poppins(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  color: darkColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (order['items'] as List<dynamic>).map((item) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4 * scale),
                    child: Text(
                      '${item['quantity']} x ${item['productId']['name']} (\$${item['price'].toStringAsFixed(2)})',
                      style: GoogleFonts.poppins(fontSize: 14 * scale),
                    ),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(
                'Shipping',
                style: GoogleFonts.poppins(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  color: darkColor,
                ),
              ),
              subtitle: Text(
                '${order['shipping']['street']}, ${order['shipping']['city']}, ${order['shipping']['state']} ${order['shipping']['postalCode']}, ${order['shipping']['country']}',
                style: GoogleFonts.poppins(fontSize: 14 * scale),
              ),
            ),
            ListTile(
              title: Text(
                'Created',
                style: GoogleFonts.poppins(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  color: darkColor,
                ),
              ),
              subtitle: Text(
                order['createdAt'].toString().substring(0, 10),
                style: GoogleFonts.poppins(fontSize: 14 * scale),
              ),
            ),
          ],
        ),
      );

  Widget _buildPreferencesSection(BuildContext context, double scale) =>
      FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: 20 * scale, vertical: 16 * scale),
            padding: EdgeInsets.all(20 * scale),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20 * scale,
                  spreadRadius: 5 * scale,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Notification Preferences',
                    Icons.notifications_outlined, scale),
                SizedBox(height: 16 * scale),
                Obx(() => CheckboxListTile(
                      title: Text(
                        'Email Notifications',
                        style: GoogleFonts.poppins(fontSize: 14 * scale),
                      ),
                      value:
                          controller.notificationPreferences['email'] ?? false,
                      onChanged: controller.isEditing.value
                          ? (value) => controller.updateNotificationPreference(
                              'email', value ?? false)
                          : null,
                      activeColor: primaryColor,
                    )),
                Obx(() => CheckboxListTile(
                      title: Text(
                        'SMS Notifications',
                        style: GoogleFonts.poppins(fontSize: 14 * scale),
                      ),
                      value: controller.notificationPreferences['sms'] ?? false,
                      onChanged: controller.isEditing.value
                          ? (value) => controller.updateNotificationPreference(
                              'sms', value ?? false)
                          : null,
                      activeColor: primaryColor,
                    )),
                Obx(() => CheckboxListTile(
                      title: Text(
                        'Push Notifications',
                        style: GoogleFonts.poppins(fontSize: 14 * scale),
                      ),
                      value:
                          controller.notificationPreferences['push'] ?? false,
                      onChanged: controller.isEditing.value
                          ? (value) => controller.updateNotificationPreference(
                              'push', value ?? false)
                          : null,
                      activeColor: primaryColor,
                    )),
                if (controller.isEditing.value)
                  Padding(
                    padding: EdgeInsets.only(top: 16 * scale),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildGradientButton(
                            onPressed: controller.resetForm,
                            text: 'Cancel',
                            icon: Icons.cancel_rounded,
                            scale: scale,
                          ),
                        ),
                        SizedBox(width: 16 * scale),
                        Expanded(
                          child: _buildGradientButton(
                            onPressed: controller.saveUserData,
                            text: 'Save Changes',
                            icon: Icons.save_rounded,
                            scale: scale,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSectionHeader(String title, IconData icon, double scale) => Row(
        children: [
          Icon(icon, color: primaryColor, size: 24 * scale),
          SizedBox(width: 8 * scale),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18 * scale,
              fontWeight: FontWeight.bold,
              color: darkColor,
            ),
          ),
        ],
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    required double scale,
    int maxLines = 1,
  }) =>
      Container(
        margin: EdgeInsets.only(bottom: 16 * scale),
        decoration: BoxDecoration(
          color: readOnly ? Colors.grey[50] : Colors.white,
          borderRadius: BorderRadius.circular(12 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10 * scale,
              spreadRadius: 2 * scale,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.poppins(
            color: readOnly ? Colors.grey[700] : darkColor,
            fontSize: 14 * scale,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 12 * scale,
            ),
            prefixIcon: Icon(
              icon,
              color: readOnly ? Colors.grey : primaryColor,
              size: 20 * scale,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12 * scale),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12 * scale),
              borderSide:
                  BorderSide(color: Colors.grey[200]!, width: 1 * scale),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12 * scale),
              borderSide: BorderSide(color: primaryColor, width: 1.5 * scale),
            ),
            filled: true,
            fillColor: readOnly ? Colors.grey[50] : Colors.white,
            contentPadding: EdgeInsets.all(16 * scale),
          ),
        ),
      );

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    required double scale,
  }) =>
      Container(
        height: 48 * scale,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12 * scale),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 15 * scale,
              offset: Offset(0, 5 * scale),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12 * scale),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20 * scale),
              SizedBox(width: 8 * scale),
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
}
