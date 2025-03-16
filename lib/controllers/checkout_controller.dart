import 'package:get/get.dart';

class CheckoutController extends GetxController {
  // Selected delivery method
  var selectedDeliveryMethod = 'Door delivery'.obs;

  // Address details
  var address =
      'Km 5 refinery road opposite republic road, effurun, delta state'.obs;
  var name = 'Marvis Kparobo'.obs;
  var phone = '+234 9011039271'.obs;

  // Update delivery method
  void updateDeliveryMethod(String method) {
    selectedDeliveryMethod.value = method;
  }

  // Update address details
  void updateAddress(String newAddress, String newName, String newPhone) {
    address.value = newAddress;
    name.value = newName;
    phone.value = newPhone;
  }
}
