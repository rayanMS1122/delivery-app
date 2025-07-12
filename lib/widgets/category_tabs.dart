import 'package:delivery_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<HomeController>(
      builder: (_) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              _.categories.length, // Use the length of the categories list
              (index) => CategoryTab(
                label: _
                    .categories[index], // Access categories from the controller
                isSelected: index ==
                    _.selectedCategoryIndex.value, // Use selectedCategoryIndex
                onTap: () => _.updateCategoryIndex(
                    index), // Use updateCategoryIndex method
              ),
            ),
          ),
        );
      },
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFFF4A3A) : Colors.grey,
              ),
            ),
            if (isSelected)
              Container(
                width: 87,
                height: 3,
                color: const Color(0xFFFF4A3A),
              ),
          ],
        ),
      ),
    );
  }
}
