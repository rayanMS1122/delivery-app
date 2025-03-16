import 'package:delivery_app/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';

class SwipeableCartItem extends StatelessWidget {
  final String id;
  final String image;
  final String name;
  final int price;
  final int amount;
  final VoidCallback onDismissed;

  const SwipeableCartItem({
    Key? key,
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    required this.amount,
    required this.onDismissed,
    required bool isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismissed();
      },
      child: CartItemWidget(
        image: image,
        name: name,
        price: price,
        id: id,
      ),
    );
  }
}
