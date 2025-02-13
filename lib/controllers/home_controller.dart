import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable for selected category index
  var selectedCategoryIndex = 0.obs;

  // Observable for selected bottom navigation index
  var selectedNavIndex = 0.obs;

  // Reactive list of categories (private)
  final RxList<String> _categories =
      <String>["Foods", "Drinks", "Snacks", "Sauce", "Desserts", "Combos"].obs;

  // Getter to access categories
  List<String> get categories => _categories;

  // Method to update the selected category index
  void updateCategoryIndex(int index) {
    selectedCategoryIndex.value = index;
  }

  // Method to update the selected navigation index
  void updateNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  // Method to add a new category (example)
  void addCategory(String category) {
    _categories.add(category);
  }

  // Method to remove a category (example)
  void removeCategory(String category) {
    _categories.remove(category);
  }
}
