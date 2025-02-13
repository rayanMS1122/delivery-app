import 'package:delivery_app/screens/all_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // Add this import for GetX

import 'screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
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
        // final ThemeData lightTheme = ThemeData(
        //   useMaterial3: false,
        //   fontFamily: 'SF Pro Display',
        //   appBarTheme: AppBarTheme(
        //     backgroundColor: AppColors.appPrimaryColor,
        //   ),
        //   brightness: Brightness.light,
        //   primaryColor: Colors.white,
        //   scaffoldBackgroundColor: Colors.white,
        // );
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: lightTheme,
          home: AllScreen(),
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 500),
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            final scale = mediaQueryData.textScaleFactor.clamp(0.8, 0.9);
            return MediaQuery(
              data: mediaQueryData.copyWith(textScaleFactor: scale),
              child: child!,
            );
          },
        );
      },
    );;
  }
}
