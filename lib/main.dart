import 'package:delivery_app/controllers/cart_controller.dart'; // Import the CartController
import 'package:delivery_app/controllers/favorites_controller.dart';
import 'package:delivery_app/controllers/home_controller.dart';
import 'package:delivery_app/controllers/product_controller.dart';
import 'package:delivery_app/controllers/profile_controller.dart';
import 'package:delivery_app/screens/all_screen.dart';
import 'package:delivery_app/screens/authentication/login.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/product_detail_screen.dart';
import 'package:delivery_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // For GetX

void main() {
  Get.put(ProfileController());
  Get.put(CartController());
  Get.put(HomeController());
  Get.put(FavoritesController());

  Get.put(ProductController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // Define a custom theme
        final ThemeData lightTheme = _buildLightTheme();

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme, // Apply the custom theme
          // home: LoginScreen(), // Set the initial screen
          home: AllScreen(),
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 500),
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            final scale = mediaQueryData.textScaleFactor.clamp(0.8, 0.9);
            return MediaQuery(
              data:
                  mediaQueryData.copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            );
          },
        );
      },
    );
  }

  // Helper method to build the light theme
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: false,
      fontFamily: 'San-Francisco-Pro-Fonts-master', // Set the default font
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFF460A), // Orange app bar
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFF460A), // Orange as primary color
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        labelLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFFFF460A), // Orange buttons
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF460A), // Orange background
          foregroundColor: Colors.white, // White text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}
