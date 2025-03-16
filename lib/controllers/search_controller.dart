// Controller for Search Screen
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SearchsController extends GetxController {
  // Observable variable for search query
  var searchQuery = ''.obs;

  // Observable list for search results
  var searchResults = <String>[].obs;

  // Function to update search results based on query
  void updateSearchResults(String query) {
    searchQuery.value = query;
    // Simulate search results (replace with actual search logic)
    if (query.isNotEmpty) {
      searchResults.value = List.generate(6, (index) => "Result ${index + 1}");
    } else {
      searchResults.value = [];
    }
  }
}
