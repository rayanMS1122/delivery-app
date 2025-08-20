// Controller for Search Screen
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SearchController extends GetxController {
  // Observable variable for search query
  var searchQuery = ''.obs;

  // Observable list for search results
  var searchResults = <Map<String, String>>[].obs;

  // Function to update search results based on query
  void updateSearchResults(String query) {
    searchQuery.value = query;
    // Simulate search results with static data
    if (query.isNotEmpty) {
      searchResults.value = [
        {'title': 'Pizza', 'category': 'Food'},
        {'title': 'Burger', 'category': 'Food'},
        {'title': 'Sushi', 'category': 'Food'},
        {'title': 'Pasta', 'category': 'Food'},
        {'title': 'Salad', 'category': 'Food'},
        {'title': 'Smoothie', 'category': 'Drink'},
      ]
          .where((item) =>
              item['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      searchResults.value = [];
    }
  }
}
