import 'package:delivery_app/controllers/login_controller.dart';
import 'package:delivery_app/screens/authentication/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

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
          // Animated Circle Icon with Neumorphic Effect
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
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
                Icons.lock_outline,
                color: const Color(0xFFFF460A), // Orange icon
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title Text with Fade Animation
          FadeIn(
            delay: 300,
            child: Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: screenWidth * 0.09, // Responsive font size

                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Subtitle Text with Fade Animation
          FadeIn(
            delay: 500,
            child: Text(
              "Sign in to continue",
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Responsive font size

                color: Colors.white.withOpacity(0.8),
              ),
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

          // Error Message with Slide Animation
          Obx(() {
            if (controller.errorMessage.isNotEmpty) {
              return SlideIn(
                delay: 200,
                child: AnimatedOpacity(
                  opacity: controller.errorMessage.isNotEmpty ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 20),

          // Sign In Button with Bounce Animation
          BounceIn(
            delay: 500,
            child: _buildSignInButton(controller),
          ),
          const SizedBox(height: 20),

          // Register Text with Fade Animation
          FadeIn(
            delay: 700,
            child: _buildRegisterText(),
          ),
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
            backgroundColor: const Color(0xFFFF460A), // Orange background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.2),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(
                  color: const Color(0xFFFA4A0C),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                color: Colors.black54,
              ),
            ),
            TextSpan(
              text: 'Create',
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.to(() => SignupScreen()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF460A), // Orange text
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
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.6),
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

// Animation Widgets
class FadeIn extends StatelessWidget {
  final Widget child;
  final int delay;

  const FadeIn({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class SlideIn extends StatelessWidget {
  final Widget child;
  final int delay;

  const SlideIn({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: const Offset(0, 20), end: Offset.zero),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }
}

class BounceIn extends StatelessWidget {
  final Widget child;
  final int delay;

  const BounceIn({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
}
