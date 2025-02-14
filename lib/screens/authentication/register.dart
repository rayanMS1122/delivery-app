import 'package:delivery_app/controllers/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart'; // Import your login screen

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFF460A), // Orange background
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
                Icons.person_add_alt_1,
                color: Color(0xFFFF4B3A),
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title Text
          Text(
            "Create Account",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width *
                  0.1, // Responsive font size
              fontFamily: "San-Francisco-Pro-Fonts-master",
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).size.width * 0.1, // 10% of screen width
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
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
        ),
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFFFF4B3A),
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
                color: Colors.white70,
                fontFamily: "San-Francisco-Pro-Fonts-master",
              ),
            ),
            TextSpan(
              text: 'Login',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.offAll(() => LoginScreen()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
        color: Color(0xFFFF4B3A),
        fontFamily: "San-Francisco-Pro-Fonts-master",
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Color(0xFFFF4B3A).withOpacity(0.7),
          fontFamily: "San-Francisco-Pro-Fonts-master",
        ),
        prefixIcon: Icon(icon, color: Color(0xFFFF4B3A)),
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
      ),
      onChanged: onChanged,
    );
  }
}
