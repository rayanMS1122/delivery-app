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
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF460A),
        ),
        child: Column(
          children: [
            // Top Section with Icon and Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 51, vertical: 44),
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
                  const SizedBox(height: 41),
                  // Title Text
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: "San-Francisco-Pro-Fonts-master",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Form Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 51),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(
                          controller.nameController, "Full Name", Icons.person),
                      const SizedBox(height: 20),
                      _buildTextField(
                          controller.emailController, "Email", Icons.email),
                      const SizedBox(height: 20),
                      _buildTextField(
                          controller.passwordController, "Password", Icons.lock,
                          obscureText: true),
                      const SizedBox(height: 20),
                      _buildTextField(controller.confirmPasswordController,
                          "Confirm Password", Icons.lock_outline,
                          obscureText: true),
                      const SizedBox(height: 40),
                      _buildSignUpButton(controller),
                      const SizedBox(height: 20),
                      _buildLoginText(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
          color: Color(0xFFFF4B3A),
          fontFamily: "San-Francisco-Pro-Fonts-master"),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Color(0xFFFF4B3A).withOpacity(0.7),
            fontFamily: "San-Francisco-Pro-Fonts-master"),
        prefixIcon: Icon(icon, color: Color(0xFFFF4B3A)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    );
  }

  Widget _buildSignUpButton(SignupController controller) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: TextButton(
        onPressed: controller.signUp, // Call the signUp method
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
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: "San-Francisco-Pro-Fonts-master",
            ),
          ),
        ],
      ),
    );
  }
}
