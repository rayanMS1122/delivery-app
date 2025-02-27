import 'dart:convert';

import 'package:delivery_app/api/api.dart';
import 'package:delivery_app/controllers/home_controller.dart';
import 'package:delivery_app/controllers/product_controller.dart';
import 'package:delivery_app/screens/profile_screen.dart';
import 'package:delivery_app/widgets/bottom_navigation.dart';
import 'package:delivery_app/widgets/build_featured_products.dart';
import 'package:delivery_app/widgets/category_tabs.dart';
import 'package:delivery_app/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'history_screen.dart';
import 'order_screen.dart';

import 'package:http/http.dart' as http;

class HomeScreenWithNodeJs extends StatefulWidget {
  const HomeScreenWithNodeJs({Key? key}) : super(key: key);

  @override
  State<HomeScreenWithNodeJs> createState() => _HomeScreenWithNodeJsState();
}

class _HomeScreenWithNodeJsState extends State<HomeScreenWithNodeJs> {
  // Initialize the HomeController
  final HomeController _controller = Get.put(HomeController());
  final _advancedDrawerController = AdvancedDrawerController();
  final ProductController _productController =
      Get.put(ProductController()); // Get the ProductController

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _buildHomeScreenWithNodeJs(context),
      ),
      drawer: DrawerWidget(onSignOut: () {}),
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFF460A),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      openScale: 0.6,
      childDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(-15, 0),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreenWithNodeJs(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2F2F2), Colors.white],
          ),
        ),
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.05,
          screenHeight * 0.05,
          screenWidth * 0.05,
          screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildFeaturedProducts(screenWidth),
          ],
        ),
      ),
    );
  }

  List<BuildFeaturedProductCard> products = [];

  Widget _buildFeaturedProducts(double screenWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Row(
                children: products,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              // final response = await http
              //     .get(Uri.parse("http://192.168.2.209:2000/api/get_product"));
              // final List<dynamic> data = json.decode(response.body);

              // setState(() {
              //   products = data
              //       .map((item) => BuildFeaturedProductCard.fromJson(item))
              //       .toList();
              // });

              final data = Api.getProduct();
              products = await data;
              setState(() {});
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
