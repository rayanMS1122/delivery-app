import 'package:delivery_app/screens/cart_screen.dart';
import 'package:delivery_app/screens/authentication/login.dart';
import 'package:delivery_app/screens/authentication/register.dart';
import 'package:delivery_app/screens/checkout_screen.dart';
import 'package:delivery_app/screens/history_screen.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/no_internet_screen.dart';
import 'package:delivery_app/screens/offer_screen.dart';
import 'package:delivery_app/screens/order_screen.dart';
import 'package:delivery_app/screens/password_change.dart';
import 'package:delivery_app/screens/payment_screen.dart';
import 'package:delivery_app/screens/product_detail_screen.dart';
import 'package:delivery_app/screens/profile_screen.dart';
import 'package:delivery_app/screens/search_screen.dart';
import 'package:delivery_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllScreen extends StatelessWidget {
  const AllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFF460A), // Orange background
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              // Top Section with Title

              // List of Screens
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildScreenTile(
                        context, 'Welcome Screen', const WelcomeScreen()),
                    _buildScreenTile(context, 'Login Screen', LoginScreen()),
                    _buildScreenTile(context, 'Signup Screen', SignupScreen()),
                    _buildScreenTile(
                        context, 'History Screen', HistoryScreen()),
                    _buildScreenTile(
                        context, 'Home Screen', const HomeScreen()),
                    _buildScreenTile(context, 'No Internet Screen',
                        NoInternetConnectionScreen()),
                    _buildScreenTile(context, 'Order Screen', OrderScreen()),
                    _buildScreenTile(
                        context, 'Search Screen', AdvancedSearchScreen()),
                    _buildScreenTile(context, 'Editable Profile Screen',
                        EditableProfileScreen()),
                    _buildScreenTile(context, 'Product Detail Screen',
                        ProductDetailScreen()),
                    _buildScreenTile(
                        context, 'Checkout Screen', CheckoutScreen()),
                    _buildScreenTile(context, 'Cart Screen', CartScreen()),
                    _buildScreenTile(
                        context, 'Offers Screen', MyOffersScreen()),
                    _buildScreenTile(
                        context, 'Payment Screen', PaymentScreen()),
                    _buildScreenTile(context, 'Password Change Screen',
                        PasswordChangeScreen()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreenTile(BuildContext context, String title, Widget screen) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFF460A), width: 2),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFFF460A),
          ),
        ),
        onTap: () {
          Get.to(screen);
        },
      ),
    );
  }
}
