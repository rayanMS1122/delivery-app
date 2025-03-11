import 'package:delivery_app/controllers/signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    final size = MediaQuery.of(context).size;

    // Create responsive values based on device size
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
                  // App Bar with Back Button
                  _buildAppBar(context, responsiveValues),

                  // Top Section with Logo and Title
                  _buildTopSection(context, responsiveValues),

                  // Form Section
                  _buildFormSection(context, responsiveValues),

                  // Bottom Section with Login Link
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
            onTap: () => Navigator.pop(context),
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
          // Logo with Neumorphic Effect
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

          // Title Text with Animation
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

          // Subtitle Text
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
          Text(
            "Personal Information",
            style: TextStyle(
              fontSize: rv.sectionTitleFontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: rv.spacing),

          // Full Name Field
          CustomTextField(
            controller: controller.nameController,
            label: "Full Name",
            icon: Icons.person,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.fieldSpacing),

          // Email Field
          CustomTextField(
            controller: controller.emailController,
            label: "Email Address",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.fieldSpacing),

          // Password Field
          CustomTextField(
            controller: controller.passwordController,
            label: "Password",
            icon: Icons.lock,
            obscureText: true,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.fieldSpacing),

          // Confirm Password Field
          CustomTextField(
            controller: controller.confirmPasswordController,
            label: "Confirm Password",
            icon: Icons.lock_outline,
            obscureText: true,
            responsiveValues: rv,
          ),
          SizedBox(height: rv.largeSpacing),

          // Sign Up Button
          _buildSignUpButton(controller, rv),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(SignupController controller, ResponsiveValues rv) {
    return Container(
      width: double.infinity,
      height: rv.buttonHeight,
      child: ElevatedButton(
        onPressed: controller.signUp,
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
        child: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: rv.buttonFontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
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

          // Social Login Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.g_mobiledata_rounded, rv),
              SizedBox(width: rv.spacing),
              _buildSocialButton(Icons.facebook, rv),
              SizedBox(width: rv.spacing),
              _buildSocialButton(Icons.apple, rv),
            ],
          ),
          SizedBox(height: rv.spacing),

          // Login Text
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
                    ..onTap = () => Get.offAll(() => LoginScreen()),
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

  Widget _buildSocialButton(IconData icon, ResponsiveValues rv) {
    return Container(
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
      child: Icon(
        icon,
        color: const Color(0xFFFF460A),
        size: rv.iconSize,
      ),
    );
  }
}

// Responsive values class to ensure consistent sizing across all devices
class ResponsiveValues {
  double screenWidth = 0;
  double screenHeight = 0;

  // Fixed sizes to maintain consistency across devices
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
      return value.clamp(0.8, 1.3) * scaleFactor;
    }

    // Set all responsive values
    horizontalPadding = 24 * constrainedScale(1.0);
    verticalPadding = 20 * constrainedScale(1.0);
    padding = 20 * constrainedScale(1.0);
    smallPadding = 12 * constrainedScale(1.0);

    spacing = 20 * constrainedScale(1.0);
    smallSpacing = 8 * constrainedScale(1.0);
    fieldSpacing = 16 * constrainedScale(1.0);
    largeSpacing = 30 * constrainedScale(1.0);

    logoSize = 80 * constrainedScale(1.0);
    iconSize = 24 * constrainedScale(1.0);

    borderRadius = 12 * constrainedScale(1.0);
    cardBorderRadius = 20 * constrainedScale(1.0);
    buttonBorderRadius = 30 * constrainedScale(1.0);

    titleFontSize = 28 * constrainedScale(1.0);
    subtitleFontSize = 16 * constrainedScale(1.0);
    sectionTitleFontSize = 18 * constrainedScale(1.0);
    normalFontSize = 14 * constrainedScale(1.0);
    buttonFontSize = 16 * constrainedScale(1.0);

    buttonHeight = 56 * constrainedScale(1.0);
    inputHeight = 56 * constrainedScale(1.0);
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
    required this.controller,
    required this.label,
    required this.icon,
    required this.responsiveValues,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  bool _isObscured = true;

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
