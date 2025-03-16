import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:delivery_app/controllers/profile_controller.dart';

class EditableProfileScreen extends StatelessWidget {
  const EditableProfileScreen({Key? key}) : super(key: key);

  // Define brand colors
  static const Color primaryColor = Color(0xFFFF460A);
  static const Color scaffoldBackgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final ImagePicker _picker = ImagePicker();

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isEditing.value
                      ? Icons.check_rounded
                      : Icons.edit_rounded,
                  color: Colors.white,
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
            ),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 70,
                    color: primaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Error loading profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controller.fetchUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // Profile Header with Image
            SliverToBoxAdapter(
              child: Container(
                color: primaryColor,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profile Image Section
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: GetBuilder<ProfileController>(
                              builder: (_) => CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                    controller.profileImagePath?.value != null
                                        ? FileImage(File(
                                            controller.profileImagePath!.value))
                                        : null,
                                child:
                                    controller.profileImagePath?.value == null
                                        ? Icon(
                                            Icons.person_rounded,
                                            size: 70,
                                            color: Colors.grey[400],
                                          )
                                        : null,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                if (controller.isEditing.value) {
                                  final XFile? image = await _picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 80,
                                  );
                                  if (image != null) {
                                    controller.uploadProfileImage(image.path);
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.isEditing.value
                                      ? Colors.white
                                      : Colors.grey[200],
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: controller.isEditing.value
                                      ? primaryColor
                                      : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // User Name Display
                    Obx(() => Text(
                          controller.fullName.value.isNotEmpty
                              ? controller.fullName.value
                              : 'User Profile',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                    // User Email Display
                    Obx(() => Text(
                          controller.email.value.isNotEmpty
                              ? controller.email.value
                              : 'No email provided',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        )),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Section
                      sectionHeader(
                        context: context,
                        title: 'Personal Information',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 16),

                      buildTextField(
                        controller: controller.nameController,
                        label: 'Full Name',
                        icon: Icons.person_rounded,
                        readOnly: !controller.isEditing.value,
                      ),

                      buildTextField(
                        controller: controller.emailController,
                        label: 'Email Address',
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: !controller.isEditing.value,
                      ),

                      buildTextField(
                        controller: controller.phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_rounded,
                        keyboardType: TextInputType.phone,
                        readOnly: !controller.isEditing.value,
                      ),

                      const SizedBox(height: 30),

                      // Address Information Section
                      sectionHeader(
                        context: context,
                        title: 'Address Information',
                        icon: Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),

                      buildTextField(
                        controller: controller.homeAddressController,
                        label: 'Home Address',
                        icon: Icons.home_rounded,
                        maxLines: 2,
                        readOnly: !controller.isEditing.value,
                      ),

                      buildTextField(
                        controller: controller.workAddressController,
                        label: 'Work Address',
                        icon: Icons.work_rounded,
                        maxLines: 2,
                        readOnly: !controller.isEditing.value,
                      ),

                      const SizedBox(height: 30),

                      // Payment Methods Section
                      sectionHeader(
                        context: context,
                        title: 'Payment Methods',
                        icon: Icons.payment_outlined,
                      ),
                      const SizedBox(height: 16),

                      buildPaymentMethodTile(
                        context: context,
                        title: 'Credit Card',
                        subtitle: 'Visa, Mastercard, etc.',
                        icon: Icons.credit_card_rounded,
                        isSelected: controller.isCardSelected.value,
                        onChanged: controller.isEditing.value
                            ? (value) {
                                if (value != null) {
                                  controller.toggleBankSelection(value);
                                }
                              }
                            : null,
                      ),

                      buildPaymentMethodTile(
                        context: context,
                        title: 'Bank Transfer',
                        subtitle: 'Direct bank payment',
                        icon: Icons.account_balance_rounded,
                        isSelected: controller.isBankSelected.value,
                        onChanged: controller.isEditing.value
                            ? (value) {
                                if (value != null) {
                                  controller.toggleBankSelection(value);
                                }
                              }
                            : null,
                      ),

                      buildPaymentMethodTile(
                        context: context,
                        title: 'PayPal',
                        subtitle: 'Online payment system',
                        icon: Icons.account_balance_wallet_rounded,
                        isSelected: controller.isPaypalSelected.value,
                        onChanged: controller.isEditing.value
                            ? (value) {
                                if (value != null) {
                                  controller.toggleBankSelection(value);
                                }
                              }
                            : null,
                      ),

                      const SizedBox(height: 30),

                      // Action Buttons
                      if (controller.isEditing.value) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: controller.resetForm,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: primaryColor,
                                  side: const BorderSide(color: primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (controller.validateForm()) {
                                    controller.saveUserData();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 2,
                                ),
                                child: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget sectionHeader({
    required BuildContext context,
    required String title,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          color: readOnly ? Colors.grey[700] : Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(
            icon,
            color: readOnly ? Colors.grey : primaryColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey[50] : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget buildPaymentMethodTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required Function(bool?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? primaryColor : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? primaryColor : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color:
                isSelected ? primaryColor.withOpacity(0.8) : Colors.grey[600],
          ),
        ),
        trailing: onChanged != null
            ? Checkbox(
                value: isSelected,
                onChanged: onChanged,
                activeColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Colors.white,
        onTap: onChanged != null
            ? () {
                onChanged(!isSelected);
              }
            : null,
      ),
    );
  }
}
