import 'package:delivery_app/controllers/signup_controller.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsiveValues = ResponsiveValues(size);

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF460A), Color(0xFFFF6B3A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  // _buildAppBar(context, responsiveValues),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomAppBar(
                      title: "",
                      iconColor: Colors.white,
                      onBackPressed: () => Get.back(),
                      titleStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      iconSize: 24,
                    ),
                  ),
                  _buildTopSection(context, responsiveValues),
                  _buildFormSection(context, responsiveValues),
                  _buildBottomSection(responsiveValues),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ResponsiveValues rv) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: rv.horizontalPadding,
        vertical: rv.smallPadding,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(rv.smallPadding),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(rv.borderRadius),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: rv.iconSize * 0.7,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, ResponsiveValues rv) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: rv.horizontalPadding,
        vertical: rv.verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'logo',
            child: Container(
              width: rv.logoSize,
              height: rv.logoSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(-4, -4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.person_add_alt_1,
                  color: const Color(0xFFFF460A),
                  size: rv.logoSize * 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: rv.spacing),
          Text(
            "Create Account",
            style: TextStyle(
              fontSize: rv.titleFontSize,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: rv.smallSpacing),
          Text(
            "Sign up to get started with delivery",
            style: TextStyle(
              fontSize: rv.subtitleFontSize,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context, ResponsiveValues rv) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: rv.horizontalPadding,
        vertical: rv.smallPadding,
      ),
      padding: EdgeInsets.all(rv.padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rv.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error Message Display
          Obx(() => controller.errorMessage.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(bottom: rv.spacing),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: rv.normalFontSize,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          Text(
            "Personal Information",
            style: TextStyle(
              fontSize: rv.sectionTitleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: rv.spacing),
          CustomTextField(
            controller: controller.nameController,
            label: "Full Name",
            icon: Icons.person,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.fieldSpacing),
          CustomTextField(
            controller: controller.emailController,
            label: "Email Address",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.fieldSpacing),
          CustomTextField(
            controller: controller.phoneController,
            label: "Phone Number",
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.largeSpacing),
          Text(
            "Address Information",
            style: TextStyle(
              fontSize: rv.sectionTitleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: rv.spacing),
          AddressTextField(
            controller: controller.streetController,
            label: "Street Address",
            icon: Icons.location_on,
            responsiveValues: rv,
            addressFieldType: AddressFieldType.street,
          ),
          SizedBox(height: rv.fieldSpacing),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AddressTextField(
                  controller: controller.cityController,
                  label: "City",
                  icon: Icons.location_city,
                  responsiveValues: rv,
                  addressFieldType: AddressFieldType.city,
                ),
              ),
              SizedBox(width: rv.fieldSpacing),
              Expanded(
                flex: 1,
                child: AddressTextField(
                  controller: controller.stateController,
                  label: "State",
                  icon: Icons.map,
                  responsiveValues: rv,
                  addressFieldType: AddressFieldType.state,
                ),
              ),
            ],
          ),
          SizedBox(height: rv.fieldSpacing),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: AddressTextField(
                  controller: controller.postalCodeController,
                  label: "Postal Code",
                  icon: Icons.local_post_office,
                  responsiveValues: rv,
                  addressFieldType: AddressFieldType.postalCode,
                ),
              ),
              SizedBox(width: rv.fieldSpacing),
              Expanded(
                flex: 2,
                child: AddressTextField(
                  controller: controller.countryController,
                  label: "Country",
                  icon: Icons.flag,
                  responsiveValues: rv,
                  addressFieldType: AddressFieldType.country,
                ),
              ),
            ],
          ),
          SizedBox(height: rv.fieldSpacing),
          Row(
            children: [
              Expanded(
                child: AddressTextField(
                  controller: controller.latitudeController,
                  label: "Latitude",
                  icon: Icons.gps_fixed,
                  responsiveValues: rv,
                  addressFieldType: AddressFieldType.latitude,
                ),
              ),
              SizedBox(width: rv.fieldSpacing),
              Expanded(
                child: AddressTextField(
                  controller: controller.longitudeController,
                  label: "Longitude",
                  icon: Icons.gps_not_fixed,
                  responsiveValues: rv,
                  addressFieldType: AddressFieldType.longitude,
                ),
              ),
            ],
          ),
          SizedBox(height: rv.largeSpacing),
          Text(
            "Security Information",
            style: TextStyle(
              fontSize: rv.sectionTitleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: rv.spacing),
          CustomTextField(
            controller: controller.passwordController,
            label: "Password",
            icon: Icons.lock,
            obscureText: true,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.fieldSpacing),
          CustomTextField(
            controller: controller.confirmPasswordController,
            label: "Confirm Password",
            icon: Icons.lock_outline,
            obscureText: true,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.largeSpacing),
          _buildSignUpButton(controller, rv),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(SignupController controller, ResponsiveValues rv) {
    return Obx(() => Container(
          width: double.infinity,
          height: rv.buttonHeight,
          child: ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    controller
                        .signUp(); // Updated to match new controller method
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF460A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(rv.buttonBorderRadius),
              ),
              elevation: 5,
              shadowColor: const Color(0xFFFF460A).withOpacity(0.3),
              padding: EdgeInsets.symmetric(vertical: rv.smallPadding),
            ),
            child: controller.isLoading.value
                ? SizedBox(
                    height: rv.buttonHeight * 0.5,
                    width: rv.buttonHeight * 0.5,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: rv.buttonFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ));
  }

  Widget _buildBottomSection(ResponsiveValues rv) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: rv.verticalPadding,
        horizontal: rv.horizontalPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.white.withOpacity(0.5),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: rv.smallPadding),
                child: Text(
                  "or",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: rv.normalFontSize,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.white.withOpacity(0.5),
                  thickness: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: rv.spacing),
          // Social Login Buttons (Disabled as placeholder)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.g_mobiledata_rounded, rv,
                  disabled: true),
              SizedBox(width: rv.spacing),
              _buildSocialButton(Icons.facebook, rv, disabled: true),
              SizedBox(width: rv.spacing),
              _buildSocialButton(Icons.apple, rv, disabled: true),
            ],
          ),
          SizedBox(height: rv.spacing),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: rv.normalFontSize,
                  ),
                ),
                TextSpan(
                  text: 'Login',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() => LoginScreen()),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: rv.normalFontSize,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, ResponsiveValues rv,
      {bool disabled = false}) {
    return Opacity(
      opacity: disabled ? 0.5 : 1.0,
      child: Container(
        padding: EdgeInsets.all(rv.smallPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(rv.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            icon,
            color: const Color(0xFFFF460A),
            size: rv.iconSize,
          ),
          onPressed: disabled
              ? null
              : () {
                  // TODO: Implement social login functionality
                  print('Social login: ${icon.toString()}');
                },
        ),
      ),
    );
  }
}

// Enum for different address field types
enum AddressFieldType {
  street,
  city,
  state,
  postalCode,
  country,
  latitude,
  longitude
}

// Specialized Address TextField Widget
class AddressTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final ResponsiveValues responsiveValues;
  final AddressFieldType addressFieldType;
  final Function(String)? onChanged;

  const AddressTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.responsiveValues,
    required this.addressFieldType,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AddressTextField> createState() => _AddressTextFieldState();
}

class _AddressTextFieldState extends State<AddressTextField> {
  bool _isFocused = false;

  TextInputType _getKeyboardType() {
    switch (widget.addressFieldType) {
      case AddressFieldType.postalCode:
        return TextInputType.number;
      case AddressFieldType.latitude:
      case AddressFieldType.longitude:
        return const TextInputType.numberWithOptions(
            decimal: true, signed: true);
      default:
        return TextInputType.streetAddress;
    }
  }

  TextCapitalization _getTextCapitalization() {
    switch (widget.addressFieldType) {
      case AddressFieldType.street:
      case AddressFieldType.city:
      case AddressFieldType.state:
      case AddressFieldType.country:
        return TextCapitalization.words;
      default:
        return TextCapitalization.none;
    }
  }

  String? _getHintText() {
    switch (widget.addressFieldType) {
      case AddressFieldType.street:
        return "123 Main Street";
      case AddressFieldType.city:
        return "New York";
      case AddressFieldType.state:
        return "NY";
      case AddressFieldType.postalCode:
        return "10001";
      case AddressFieldType.country:
        return "United States";
      case AddressFieldType.latitude:
        return "40.7128";
      case AddressFieldType.longitude:
        return "-74.0060";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rv = widget.responsiveValues;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Container(
        height: rv.inputHeight,
        decoration: BoxDecoration(
          color: _isFocused ? Colors.white : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(rv.borderRadius),
          border: Border.all(
            color: _isFocused
                ? const Color(0xFFFF460A).withOpacity(0.3)
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF460A).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          keyboardType: _getKeyboardType(),
          textCapitalization: _getTextCapitalization(),
          style: TextStyle(
            color: Colors.black87,
            fontSize: rv.normalFontSize,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: _getHintText(),
            labelStyle: TextStyle(
              color: _isFocused ? const Color(0xFFFF460A) : Colors.black54,
              fontSize: rv.normalFontSize,
            ),
            hintStyle: TextStyle(
              color: Colors.black38,
              fontSize: rv.normalFontSize * 0.9,
            ),
            prefixIcon: Icon(
              widget.icon,
              color: _isFocused ? const Color(0xFFFF460A) : Colors.black54,
              size: rv.iconSize,
            ),
            suffixIcon: widget.addressFieldType == AddressFieldType.street
                ? IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: Colors.black54,
                      size: rv.iconSize * 0.8,
                    ),
                    onPressed: null, // Disabled until implemented
                    tooltip: 'Location detection not available',
                  )
                : null,
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: rv.smallPadding,
              horizontal: rv.padding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

// Responsive values class to ensure consistent sizing across all devices
class ResponsiveValues {
  double screenWidth = 0;
  double screenHeight = 0;

  late final double horizontalPadding;
  late final double verticalPadding;
  late final double padding;
  late final double smallPadding;

  late final double spacing;
  late final double smallSpacing;
  late final double fieldSpacing;
  late final double largeSpacing;

  late final double logoSize;
  late final double iconSize;

  late final double borderRadius;
  late final double cardBorderRadius;
  late final double buttonBorderRadius;

  late final double titleFontSize;
  late final double subtitleFontSize;
  late final double sectionTitleFontSize;
  late final double normalFontSize;
  late final double buttonFontSize;

  late final double buttonHeight;
  late final double inputHeight;

  ResponsiveValues(Size size) {
    screenWidth = size.width;
    screenHeight = size.height;

    // Base all values on a reference width of 375px (iPhone X)
    final double scaleFactor = screenWidth / 375;

    // Apply minimum and maximum constraints to prevent extreme scaling
    double constrainedScale(double value) {
      return (value * scaleFactor).clamp(value * 0.8, value * 1.3);
    }

    horizontalPadding = constrainedScale(24);
    verticalPadding = constrainedScale(20);
    padding = constrainedScale(20);
    smallPadding = constrainedScale(12);

    spacing = constrainedScale(20);
    smallSpacing = constrainedScale(8);
    fieldSpacing = constrainedScale(16);
    largeSpacing = constrainedScale(30);

    logoSize = constrainedScale(80);
    iconSize = constrainedScale(24);

    borderRadius = constrainedScale(12);
    cardBorderRadius = constrainedScale(20);
    buttonBorderRadius = constrainedScale(30);

    titleFontSize = constrainedScale(28);
    subtitleFontSize = constrainedScale(16);
    sectionTitleFontSize = constrainedScale(18);
    normalFontSize = constrainedScale(14);
    buttonFontSize = constrainedScale(16);

    buttonHeight = constrainedScale(56);
    inputHeight = constrainedScale(56);
  }
}

// Reusable Custom TextField Widget
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final ResponsiveValues responsiveValues;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.responsiveValues,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final rv = widget.responsiveValues;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Container(
        height: rv.inputHeight,
        decoration: BoxDecoration(
          color: _isFocused ? Colors.white : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(rv.borderRadius),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF460A).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obscureText && _isObscured,
          keyboardType: widget.keyboardType,
          style: TextStyle(
            color: Colors.black87,
            fontSize: rv.normalFontSize,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: _isFocused ? const Color(0xFFFF460A) : Colors.black54,
              fontSize: rv.normalFontSize,
            ),
            prefixIcon: Icon(
              widget.icon,
              color: _isFocused ? const Color(0xFFFF460A) : Colors.black54,
              size: rv.iconSize,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black54,
                      size: rv.iconSize * 0.8,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: rv.smallPadding,
              horizontal: rv.padding,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
