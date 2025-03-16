import 'package:delivery_app/controllers/offers_controller.dart';
import 'package:delivery_app/screens/cart_screen.dart';
import 'package:delivery_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOffersScreen extends StatelessWidget {
  final MyOffersController _controller = Get.put(MyOffersController());

  MyOffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get device dimensions for responsive layout
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    // Calculate safe area dimensions
    final safeHeight = size.height - padding.top - padding.bottom;

    // Determine if we're on a tablet
    final isTablet = size.shortestSide >= 600;

    // Responsive dimensions
    final horizontalPadding = size.width * 0.05;
    final verticalSpacing = safeHeight * 0.02;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    const Color(0xFFF5F5F8),
                  ],
                  stops: const [0.0, 0.3],
                ),
              ),
              child: Stack(
                children: [
                  // Background circles decoration
                  Positioned(
                    top: -50,
                    right: -20,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFA4A0C).withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFA4A0C).withOpacity(0.07),
                      ),
                    ),
                  ),

                  // Main content
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: verticalSpacing),

                            // Custom AppBar with responsive sizing
                            CustomAppBar(
                              title: "Offers",
                              onBackPressed: () => Get.back(),
                              titleStyle: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF333333),
                              ),
                              iconSize: isTablet ? 28 : 24,
                            ),

                            SizedBox(height: verticalSpacing * 1.5),

                            // Header with subtitle
                            _buildHeader(isTablet),

                            SizedBox(height: verticalSpacing * 1.5),

                            // Offers content
                            Obx(() {
                              return _controller.isLoading.value
                                  ? _buildLoadingIndicator(safeHeight)
                                  : _controller.offers.isEmpty
                                      ? _buildNoOffersMessage(
                                          isTablet, safeHeight)
                                      : _buildOffersListAdvanced(isTablet);
                            }),

                            // Extra space at bottom for scrolling
                            SizedBox(height: verticalSpacing * 2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'My Offers',
              style: TextStyle(
                fontSize: isTablet ? 30 : 24,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                color: const Color(0xFF333333),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFA4A0C).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    size: isTablet ? 20 : 16,
                    color: const Color(0xFFFA4A0C),
                  ),
                  const SizedBox(width: 4),
                  Obx(() => Text(
                        '${_controller.offers.length} Offers',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFFA4A0C),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 10 : 8),
        Text(
          'Check out exclusive offers just for you!',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(double safeHeight) {
    return Container(
      height: safeHeight * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFFFA4A0C),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Loading offers...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoOffersMessage(bool isTablet, double safeHeight) {
    return Container(
      height: safeHeight * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTablet ? 160 : 120,
              height: isTablet ? 160 : 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_offer_outlined,
                size: isTablet ? 80 : 60,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: isTablet ? 30 : 20),
            Text(
              'No Offers Available Yet',
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                color: const Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 15 : 10),
            Container(
              width: isTablet ? 300 : 250,
              child: Text(
                'Bella doesn\'t have any offers yet.\nCheck back soon for exclusive deals!',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: isTablet ? 30 : 20),
            OutlinedButton.icon(
              onPressed: () => _controller.refreshOffers(),
              icon: const Icon(Icons.refresh, color: Color(0xFFFA4A0C)),
              label: Text(
                'Refresh',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFA4A0C),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFA4A0C)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 30 : 20,
                  vertical: isTablet ? 15 : 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersListAdvanced(bool isTablet) {
    final MyOffersController _controller = Get.find();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _controller.offers.length,
      itemBuilder: (context, index) {
        final offer = _controller.offers[index];

        // Calculate discount percentage for progress indicator
        final discountValue =
            int.tryParse(offer.discount.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final progress = discountValue / 100.0;

        return Container(
          margin: EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showOfferDetails(offer),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 20 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Offer icon/image
                        Container(
                          width: isTablet ? 60 : 50,
                          height: isTablet ? 60 : 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFA4A0C).withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(isTablet ? 15 : 12),
                          ),
                          child: Icon(
                            Icons.local_offer,
                            size: isTablet ? 30 : 25,
                            color: const Color(0xFFFA4A0C),
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),

                        // Offer details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer.title,
                                style: TextStyle(
                                  fontSize: isTablet ? 18 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                              SizedBox(height: isTablet ? 8 : 6),
                              Text(
                                offer.description,
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 13,
                                  color: Colors.grey[600],
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Discount badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 12 : 10,
                            vertical: isTablet ? 8 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFA4A0C),
                            borderRadius:
                                BorderRadius.circular(isTablet ? 12 : 10),
                          ),
                          child: Text(
                            offer.discount,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 16 : 12),

                    // Time remaining and progress indicator
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: isTablet ? 18 : 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Valid for 3 more days',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(progress * 100).toInt()}% claimed',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFA4A0C),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 10 : 8),

                    // Linear progress indicator for offer claim status
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFA4A0C)),
                        minHeight: isTablet ? 8 : 6,
                      ),
                    ),

                    SizedBox(height: isTablet ? 16 : 12),

                    // Action button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () => _applyOffer(offer),
                          child: Text(
                            'Apply Offer',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFA4A0C),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFA4A0C)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 20 : 16,
                              vertical: isTablet ? 10 : 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => _showFilterOptions(),
      backgroundColor: const Color(0xFFFA4A0C),
      child: const Icon(Icons.filter_list, color: Colors.white),
      elevation: 4,
    );
  }

  void _showOfferDetails(dynamic offer) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  offer.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFA4A0C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    offer.discount,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              offer.description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Terms & Conditions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '• Offer valid for in-app orders only\n'
              '• Cannot be combined with other offers\n'
              '• Valid until the expiration date\n'
              '• Bella reserves the right to modify or cancel the offer',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  _applyOffer(offer);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA4A0C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Apply Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  void _applyOffer(dynamic offer) {
    // Handle applying offer
    Get.snackbar(
      'Offer Applied',
      'Discount of ${offer.discount} has been applied to your order.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );

    // Navigate to cart or checkout
    Get.to(CartScreen());
  }

  void _showFilterOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Offers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFilterOption('All Offers', true),
            _buildFilterOption('Highest Discount', false),
            _buildFilterOption('Expiring Soon', false),
            _buildFilterOption('Food Only', false),
            _buildFilterOption('Delivery Discounts', false),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA4A0C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? const Color(0xFFFA4A0C) : Colors.grey,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              color: isSelected ? const Color(0xFF333333) : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void refreshOffers() {
    _controller.refreshOffers();
  }
}
