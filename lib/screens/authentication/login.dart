import 'package:delivery_app/controllers/auth_controller.dart';
import 'package:delivery_app/screens/authentication/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFFFF460A), // Orange background
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // Adjust for keyboard
            ),
            child: Column(
              children: [
                // Top Section with Icon and Title
                _buildTopSection(context),
                // Form Section
                _buildFormSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            MediaQuery.of(context).size.width * 0.1, // 10% of screen width
        vertical: 44,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle Icon
          Container(
            width: 73,
            height: 73,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.lock_outline,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title Text
          Text(
            "Welcome Back!",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width *
                  0.1, // Responsive font size
              fontFamily: "SF Pro",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            MediaQuery.of(context).size.width * 0.1, // 10% of screen width
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Email Field
          CustomTextField(
            controller: controller.emailController,
            label: "Email",
            icon: Icons.email,
            onChanged: (_) => controller.clearError(),
          ),
          const SizedBox(height: 20),

          // Password Field
          CustomTextField(
            controller: controller.passwordController,
            label: "Password",
            icon: Icons.lock,
            obscureText: true,
            onChanged: (_) => controller.clearError(),
          ),
          const SizedBox(height: 20),

          // Error Message
          Obx(() {
            if (controller.errorMessage.isNotEmpty) {
              return AnimatedOpacity(
                opacity: controller.errorMessage.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "SF Pro",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 20),

          // Sign In Button
          _buildSignInButton(controller),
          const SizedBox(height: 20),

          // Register Text
          _buildRegisterText(),
        ],
      ),
    );
  }

  Widget _buildSignInButton(LoginController controller) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Color(0xFFFF4B3A))
              : const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color(0xFFFF4B3A),
                    fontSize: 18,
                    fontFamily: "SF Pro",
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildRegisterText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(
                color: Colors.white70,
                fontFamily: "SF Pro",
              ),
            ),
            TextSpan(
              text: 'Create',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.to(() => SignupScreen()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: "SF Pro",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final Function(String)? onChanged;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final Color iconColor;
  final Color fillColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;

  const CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.onChanged,
    this.textStyle,
    this.labelStyle,
    this.iconColor = const Color(0xFFFF4B3A),
    this.fillColor = Colors.white,
    this.borderRadius = 15.0,
    this.contentPadding,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: textStyle ??
          const TextStyle(
            color: Color.fromARGB(255, 0, 12, 143),
            fontFamily: "SF Pro",
          ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle ??
            TextStyle(
              fontSize: 16,
              color: iconColor,
              fontFamily: "SF Pro",
            ),
        prefixIcon: Icon(icon, color: iconColor),
        filled: true,
        fillColor: fillColor,
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
      ),
      onChanged: onChanged,
    );
  }
}
