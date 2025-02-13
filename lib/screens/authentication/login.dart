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
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF460A), // Orange background
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
                        Icons.lock_outline,
                        color: Color(0xFFFF4B3A),
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 41),
                  // Title Text
                  const Text(
                    "Welcome Back!",
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
                child: Obx(() {
                  return Column(
                    children: [
                      // Email Field
                      _buildTextField(
                        controller.emailController,
                        "Email",
                        Icons.email,
                        onChanged: (_) => controller.clearError(),
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      _buildTextField(
                        controller.passwordController,
                        "Password",
                        Icons.lock,
                        obscureText: true,
                        onChanged: (_) => controller.clearError(),
                      ),
                      const SizedBox(height: 20),

                      // Error Message
                      if (controller.errorMessage.isNotEmpty)
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "San-Francisco-Pro-Fonts-master",
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Sign In Button
                      _buildSignInButton(controller),
                      const SizedBox(height: 20),

                      // Register Text
                      _buildRegisterText(),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(
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
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildSignInButton(LoginController controller) {
    return Obx(() {
      return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: TextButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          child: controller.isLoading.value
              ? CircularProgressIndicator(color: Color(0xFFFF4B3A))
              : Text(
                  'Sign In',
                  style: TextStyle(
                    color: Color(0xFFFF4B3A),
                    fontSize: 18,
                    fontFamily: "San-Francisco-Pro-Fonts-master",
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildRegisterText() {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Colors.white70,
              fontFamily: "San-Francisco-Pro-Fonts-master",
            ),
          ),
          TextSpan(
            text: 'Create',
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.to(() => SignupScreen()),
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
