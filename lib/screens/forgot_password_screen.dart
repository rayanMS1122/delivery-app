import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool codeSent = false;
  String? errorMessage;

  // For verification code entry
  final List<TextEditingController> codeControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void dispose() {
    emailController.dispose();
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void sendResetCode() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Simulate network delay
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
          codeSent = true;
        });

        Get.snackbar(
          "Code Sent",
          "A verification code has been sent to ${emailController.text}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      });
    }
  }

  void verifyCode() {
    String enteredCode =
        codeControllers.map((controller) => controller.text).join();

    if (enteredCode.length != 4) {
      setState(() {
        errorMessage = "Please enter the complete 4-digit code";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    // Simulate verification process
    Future.delayed(Duration(seconds: 2), () {
      // Demo code: 1234
      if (enteredCode == "1234") {
        setState(() {
          isLoading = false;
        });
        // Navigate to password reset screen
        Get.to(() => ResetPasswordScreen());
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Invalid verification code. Please try again.";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          codeSent ? "Verify Code" : "Forgot Password",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.055,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.04),

              // Logo or Icon
              Center(
                child: Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  decoration: BoxDecoration(
                    color: Color(0xFFFA4A0C).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    codeSent ? Icons.sms_outlined : Icons.lock_outline,
                    size: screenWidth * 0.1,
                    color: Color(0xFFFA4A0C),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Title and Instructions
              Text(
                codeSent ? "Verification Code" : "Forgot Password?",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              Text(
                codeSent
                    ? "Enter the 4-digit code we sent to your email address."
                    : "Enter your email and we'll send you a code to reset your password.",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Error message if any
              if (errorMessage != null)
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Input fields
              if (!codeSent) ...[
                // Email field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Color(0xFFFA4A0C)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
              ] else ...[
                // Verification code fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: screenWidth * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: codeControllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            focusNodes[index + 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Resend code option
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.snackbar(
                        "Code Resent",
                        "A new verification code has been sent to your email",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                    child: Text(
                      "Didn't receive the code? Resend",
                      style: TextStyle(
                        color: Color(0xFFFA4A0C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],

              SizedBox(height: screenHeight * 0.04),

              // Submit Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : (codeSent ? verifyCode : sendResetCode),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFA4A0C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    disabledBackgroundColor: Color(0xFFFA4A0C).withOpacity(0.5),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          codeSent ? "Verify Code" : "Send Code",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reset Password Screen that appears after verification
class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Simulate password reset
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });

        Get.snackbar(
          "Success",
          "Your password has been reset successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );

        // Navigate back to login screen after a short delay
        Future.delayed(Duration(seconds: 1), () {
          // Navigate back to login screen
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Reset Password",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.055,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.04),

              // Logo or Icon
              Center(
                child: Container(
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  decoration: BoxDecoration(
                    color: Color(0xFFFA4A0C).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: screenWidth * 0.1,
                    color: Color(0xFFFA4A0C),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Title and Instructions
              Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: screenHeight * 0.01),

              Text(
                "Your new password must be different from your previous password.",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Password field
              Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: "New Password",
                    prefixIcon:
                        Icon(Icons.lock_outline, color: Color(0xFFFA4A0C)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
              ),

              // Confirm Password field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon:
                        Icon(Icons.lock_outline, color: Color(0xFFFA4A0C)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Password requirements
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password must contain:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildRequirement("At least 8 characters"),
                    _buildRequirement("Both uppercase and lowercase letters"),
                    _buildRequirement("At least one number"),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Reset Button
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFA4A0C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    disabledBackgroundColor: Color(0xFFFA4A0C).withOpacity(0.5),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "Reset Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: Color(0xFFFA4A0C)),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
