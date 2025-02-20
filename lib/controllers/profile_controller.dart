import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProfileController extends GetxController {
  // Observable variables for payment method selection
  var isCardSelected = false.obs;
  var isBankSelected = false.obs;
  var isPaypalSelected = false.obs;

  // Methods to toggle payment method selection
  void toggleCardSelection(bool value) {
    isCardSelected.value = value;
  }

  void toggleBankSelection(bool value) {
    isBankSelected.value = value;
  }

  void togglePaypalSelection(bool value) {
    isPaypalSelected.value = value;
  }
}
