import 'package:delivery_app/controllers/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart'; // Import your login screen

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF460A),
                Color(0xFFFF6B3A)
              ], // Gradient background
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1, // 10% of screen width
        vertical: 44,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle Icon with Neumorphic Effect
          Container(
            width: 80,
            height: 80,
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
                  color: Colors.white.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(-4, -4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.person_add_alt_1,
                color: const Color(0xFFFF460A), // Orange icon
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title Text
          Text(
            "Create Account",
            style: TextStyle(
              fontSize: screenWidth * 0.09, // Responsive font size
              fontFamily: "San-Francisco-Pro-Fonts-master",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Subtitle Text
          Text(
            "Sign up to get started",
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Responsive font size
              fontFamily: "San-Francisco-Pro-Fonts-master",
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.1, // 10% of screen width
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Full Name Field
          CustomTextField(
            controller: controller.nameController,
            label: "Full Name",
            icon: Icons.person,
          ),
          const SizedBox(height: 20),

          // Email Field
          CustomTextField(
            controller: controller.emailController,
            label: "Email",
            icon: Icons.email,
          ),
          const SizedBox(height: 20),

          // Password Field
          CustomTextField(
            controller: controller.passwordController,
            label: "Password",
            icon: Icons.lock,
            obscureText: true,
          ),
          const SizedBox(height: 20),

          // Confirm Password Field
          CustomTextField(
            controller: controller.confirmPasswordController,
            label: "Confirm Password",
            icon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 40),

          // Sign Up Button
          _buildSignUpButton(controller),
          const SizedBox(height: 20),

          // Login Text
          _buildLoginText(),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(SignupController controller) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: controller.signUp, // Call the signUp method
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF460A), // Orange background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: "San-Francisco-Pro-Fonts-master",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: "Already have an account? ",
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "San-Francisco-Pro-Fonts-master",
              ),
            ),
            TextSpan(
              text: 'Login',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.offAll(() => LoginScreen()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF460A), // Orange text
                fontFamily: "San-Francisco-Pro-Fonts-master",
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

  const CustomTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        color: Colors.black,
        fontFamily: "San-Francisco-Pro-Fonts-master",
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.6),
          fontFamily: "San-Francisco-Pro-Fonts-master",
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFFF460A)), // Orange icon
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFFF460A), // Orange border
            width: 2,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
