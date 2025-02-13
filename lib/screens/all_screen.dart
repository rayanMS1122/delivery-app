import 'package:delivery_app/screens/cart_screen.dart';
import 'package:delivery_app/screens/authentication/login.dart';
import 'package:delivery_app/screens/authentication/register.dart';
import 'package:delivery_app/screens/checkout_screen.dart';
import 'package:delivery_app/screens/history_screen.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/item_not_found_screen.dart';
import 'package:delivery_app/screens/no_internet_screen.dart';
import 'package:delivery_app/screens/offer_screen.dart';
import 'package:delivery_app/screens/order_screen.dart';
import 'package:delivery_app/screens/product_detail_screen.dart';
import 'package:delivery_app/screens/profile_screen.dart';
import 'package:delivery_app/screens/search_screen.dart';
import 'package:delivery_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

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
                    _buildScreenTile(context, 'Login Screen', LoginScreen()),
                    _buildScreenTile(context, 'Signup Screen', SignupScreen()),
                    _buildScreenTile(
                        context, 'History Screen', const HistoryScreen()),
                    _buildScreenTile(
                        context, 'Home Screen', const HomeScreen()),
                    _buildScreenTile(context, 'No Internet Screen',
                        const NoInternetConnectionScreen()),
                    _buildScreenTile(
                        context, 'Order Screen', const OrderScreen()),
                    _buildScreenTile(
                        context, 'Welcome Screen', const WelcomeScreen()),
                    _buildScreenTile(
                        context, 'Search Screen', const SearchScreen()),
                    _buildScreenTile(context, 'Item Not Found Screen',
                        const ItemNotFoundScreen()),
                    _buildScreenTile(
                        context, 'Profile screen', const ProfileScreen()),
                    _buildScreenTile(context, 'Product Detail Screen',
                        ProductDetailScreen()),
                    _buildScreenTile(
                        context, 'Checkout Screen', const CheckoutScreen()),
                    _buildScreenTile(context, 'Cart Screen', CartScreen()),
                    _buildScreenTile(
                        context, 'Offers Screen', MyOffersScreen()),
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
            fontFamily: "San-Francisco-Pro-Fonts-master",
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      ),
    );
  }
}
