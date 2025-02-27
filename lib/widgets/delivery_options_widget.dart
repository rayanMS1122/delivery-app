import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOptionsWidget extends StatelessWidget {
  final DeliveryOptionsController controller =
      Get.put(DeliveryOptionsController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 66,
                decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(45, 18, 18, 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery to Mainland',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: 240,
                      height: 1,
                      color: Colors.black,
                    ),
                    SizedBox(height: 17),
                    Text(
                      'Delivery to island',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 58),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.cancelDelivery();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.proceedDelivery();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFA4A0C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 44,
                              vertical: 17,
                            ),
                          ),
                          child: Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeliveryOptionsController extends GetxController {
  void cancelDelivery() {
    // Implement cancel logic here
    Get.back();
  }

  void proceedDelivery() {
    // Implement proceed logic here
  }
}
