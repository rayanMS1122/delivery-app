import 'package:delivery_app/screens/all_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add this import for GetX

import 'screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Replace MaterialApp with GetMaterialApp
      debugShowCheckedModeBanner: false,
      home: AllScreen(),
    );
  }
}
