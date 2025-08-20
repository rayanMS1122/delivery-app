import 'package:delivery_app/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SwipeableCartItem extends StatelessWidget {
  final String id;
  final String image;
  final String name;
  final double price;
  final int amount;
  final String? restaurantName;
  final VoidCallback onDismissed;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final bool isTablet;

  const SwipeableCartItem({
    Key? key,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.amount,
    this.restaurantName,
    required this.onDismissed,
    this.onIncrease,
    this.onDecrease,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final size = MediaQuery.of(context).size;
    final controller = Get.find<CartController>();

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismissed();
        Get.snackbar(
          'Item Removed',
          '$name removed from cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: image.isNotEmpty &&
                        Uri.tryParse(image)?.hasAbsolutePath == true
                    ? NetworkImage(image)
                    : const AssetImage('assets/Mask Group.png')
                        as ImageProvider,
                width: isTablet ? size.width * 0.15 : size.width * 0.2,
                height: isTablet ? size.height * 0.1 : size.height * 0.12,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Cart item image load error: $error');
                  return Image.asset(
                    'assets/Mask Group.png',
                    width: isTablet ? size.width * 0.15 : size.width * 0.2,
                    height: isTablet ? size.height * 0.1 : size.height * 0.12,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty ? 'Unknown Item' : name,
                    style: GoogleFonts.poppins(
                      fontSize: (isTablet ? 18 : 16) * textScaleFactor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (restaurantName != null && restaurantName!.isNotEmpty)
                    Text(
                      restaurantName!,
                      style: GoogleFonts.poppins(
                        fontSize: (isTablet ? 14 : 12) * textScaleFactor,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${price.toStringAsFixed(2)} x $amount = \$${(price * amount).toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: (isTablet ? 16 : 14) * textScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFA4A0C),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() => controller.updatingItemIds.contains(id)
                ? const SizedBox(
                    width: 80,
                    child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle_outline,
                          size: isTablet ? 30 : 24,
                          color:
                              amount > 1 ? Colors.grey[700] : Colors.grey[400],
                        ),
                        onPressed: onDecrease,
                      ),
                      Text(
                        '$amount',
                        style: GoogleFonts.poppins(
                          fontSize: (isTablet ? 18 : 16) * textScaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: isTablet ? 30 : 24,
                          color: Colors.grey[700],
                        ),
                        onPressed: onIncrease,
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }
}
