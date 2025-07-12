// Payment Screen
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Payment",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.055,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Summary
            Container(
              margin: EdgeInsets.all(screenWidth * 0.05),
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildOrderItem(
                    "Veggie tomato mix",
                    "\$1,900",
                    "assets/Mask Group.png",
                    context,
                  ),
                  Divider(height: 25),
                  _buildOrderItem(
                    "Spicy chicken",
                    "\$2,300",
                    "assets/Mask Group.png",
                    context,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Fee:",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                      Text(
                        "\$200",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                      Text(
                        "\$4,400",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: Color(0xFFFA4A0C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Payment Method
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Method",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: 15),

                  // Payment Method Tabs
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildPaymentTab("Card Payment", true, context),
                        _buildPaymentTab("Bank Transfer", false, context),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Credit Card Form
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              cardBgColor: Color(0xFFFA4A0C),
              height: 200,
              textStyle: TextStyle(color: Colors.white),
              width: MediaQuery.of(context).size.width,
              animationDuration: Duration(milliseconds: 1000),
              onCreditCardWidgetChange: (CreditCardBrand) {},
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: CreditCardForm(
                formKey: formKey,
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                themeColor: Color(0xFFFA4A0C),
                textColor: Colors.black,
                cardNumberDecoration:
                    _buildInputDecoration("Card Number", "XXXX XXXX XXXX XXXX"),
                expiryDateDecoration:
                    _buildInputDecoration("Expiry Date", "MM/YY"),
                cvvCodeDecoration: _buildInputDecoration("CVV", "XXX"),
                cardHolderDecoration:
                    _buildInputDecoration("Card Holder Name", "Name on Card"),
                onCreditCardModelChange: (creditCardModel) {
                  setState(() {
                    cardNumber = creditCardModel.cardNumber;
                    expiryDate = creditCardModel.expiryDate;
                    cardHolderName = creditCardModel.cardHolderName;
                    cvvCode = creditCardModel.cvvCode;
                    isCvvFocused = creditCardModel.isCvvFocused;
                  });
                },
              ),
            ),

            SizedBox(height: 30),

            // Pay Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              width: double.infinity,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Show processing payment dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return PaymentProcessingDialog();
                      },
                    );

                    // Simulate payment processing
                    Future.delayed(Duration(seconds: 3), () {
                      Get.off(context);

                      // Show success dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PaymentSuccessDialog();
                        },
                      );
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Color(0xFFFA4A0C), Color(0xFFFF6B3A)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFA4A0C).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Pay \$4,400",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey[700]),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFA4A0C), width: 2.0),
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(15),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(15),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(15),
      ),
      floatingLabelStyle: TextStyle(color: Color(0xFFFA4A0C)),
    );
  }

  Widget _buildPaymentTab(String text, bool isActive, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Color(0xFFFA4A0C) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(
      String name, String price, String imagePath, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "x1",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.04,
          ),
        ),
      ],
    );
  }
}

// Payment Processing Dialog
class PaymentProcessingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFA4A0C)),
            ),
            SizedBox(height: 20),
            Text(
              "Processing Payment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Please wait while we process your payment...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Payment Success Dialog
class PaymentSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFFFA4A0C).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Color(0xFFFA4A0C),
                size: 50,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Payment Successful!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Your order has been placed successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Order #FD-35672",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.off(context);

                  Get.off(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFA4A0C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Track Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Get.off(context);

                Get.off(context);
              },
              child: Text(
                "Back to Home",
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum CreditCardBrand { visa, mastercard, amex, discover, other }

class CreditCardWidget extends StatefulWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool showBackView;
  final bool obscureCardNumber;
  final bool obscureCardCvv;
  final Color cardBgColor;
  final double height;
  final TextStyle textStyle;
  final double width;
  final Duration animationDuration;
  final Function(CreditCardBrand) onCreditCardWidgetChange;

  const CreditCardWidget({
    Key? key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.showBackView,
    this.obscureCardNumber = false,
    this.obscureCardCvv = false,
    this.cardBgColor = const Color(0xFF5D5D5D),
    this.height = 200,
    this.textStyle = const TextStyle(color: Colors.white),
    required this.width,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.onCreditCardWidgetChange,
  }) : super(key: key);

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  late bool isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _frontRotation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 2)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(2),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _backRotation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(2),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -2, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _detectCardBrand(widget.cardNumber);
  }

  @override
  void didUpdateWidget(CreditCardWidget oldWidget) {
    if (widget.showBackView != oldWidget.showBackView) {
      _updateRotations();
    }
    if (widget.cardNumber != oldWidget.cardNumber) {
      _detectCardBrand(widget.cardNumber);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _updateRotations() {
    if (widget.showBackView) {
      _controller.forward();
      setState(() {
        isFrontVisible = false;
      });
    } else {
      _controller.reverse();
      setState(() {
        isFrontVisible = true;
      });
    }
  }

  void _detectCardBrand(String cardNumber) {
    CreditCardBrand brand = _getCardBrand(cardNumber);
    widget.onCreditCardWidgetChange(brand);
  }

  CreditCardBrand _getCardBrand(String cardNumber) {
    if (cardNumber.isEmpty) {
      return CreditCardBrand.other;
    }

    // Remove spaces and check patterns
    String cleanNumber = cardNumber.replaceAll(' ', '');

    // Visa: Starts with 4
    if (cleanNumber.startsWith('4')) {
      return CreditCardBrand.visa;
    }
    // Mastercard: Starts with 51-55 or 2221-2720
    else if ((cleanNumber.startsWith('5') &&
            int.tryParse(cleanNumber.substring(1, 2)) != null &&
            int.parse(cleanNumber.substring(1, 2)) >= 1 &&
            int.parse(cleanNumber.substring(1, 2)) <= 5) ||
        (cleanNumber.length >= 4 &&
            int.tryParse(cleanNumber.substring(0, 4)) != null &&
            int.parse(cleanNumber.substring(0, 4)) >= 2221 &&
            int.parse(cleanNumber.substring(0, 4)) <= 2720)) {
      return CreditCardBrand.mastercard;
    }
    // American Express: Starts with 34 or 37
    else if (cleanNumber.startsWith('34') || cleanNumber.startsWith('37')) {
      return CreditCardBrand.amex;
    }
    // Discover: Starts with 6011, 622126-622925, 644-649, or 65
    else if (cleanNumber.startsWith('6011') ||
        (cleanNumber.length >= 6 &&
            int.tryParse(cleanNumber.substring(0, 6)) != null &&
            int.parse(cleanNumber.substring(0, 6)) >= 622126 &&
            int.parse(cleanNumber.substring(0, 6)) <= 622925) ||
        (cleanNumber.startsWith('64') &&
            cleanNumber.length >= 3 &&
            int.tryParse(cleanNumber.substring(2, 3)) != null &&
            int.parse(cleanNumber.substring(2, 3)) >= 4 &&
            int.parse(cleanNumber.substring(2, 3)) <= 9) ||
        cleanNumber.startsWith('65')) {
      return CreditCardBrand.discover;
    } else {
      return CreditCardBrand.other;
    }
  }

  String _getObscuredNumber() {
    if (widget.obscureCardNumber) {
      String number = widget.cardNumber.replaceAll(' ', '');
      if (number.length > 4) {
        String lastFour = number.substring(number.length - 4);
        String obscured = 'XXXX XXXX XXXX $lastFour';
        return obscured;
      } else {
        return widget.cardNumber;
      }
    } else {
      return widget.cardNumber.isEmpty
          ? 'XXXX XXXX XXXX XXXX'
          : widget.cardNumber;
    }
  }

  String _getExpiryDate() {
    return widget.expiryDate.isEmpty ? 'MM/YY' : widget.expiryDate;
  }

  String _getCardHolderName() {
    return widget.cardHolderName.isEmpty
        ? 'CARD HOLDER'
        : widget.cardHolderName.toUpperCase();
  }

  String _getCvv() {
    return widget.obscureCardCvv
        ? 'XXX'
        : (widget.cvvCode.isEmpty ? 'XXX' : widget.cvvCode);
  }

  Widget _buildFrontCard() {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.cardBgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/chip.png',
                height: 30,
                width: 40,
              ),
              _buildCardBrandImage(),
            ],
          ),
          Text(
            _getObscuredNumber(),
            style: widget.textStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Holder',
                    style: widget.textStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _getCardHolderName(),
                    style: widget.textStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expires',
                    style: widget.textStyle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _getExpiryDate(),
                    style: widget.textStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.cardBgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            height: 40,
            color: Colors.black,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 40,
                    color: Colors.grey[200],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Text(
                      _getCvv(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildCardBrandImage(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrandImage() {
    CreditCardBrand brand = _getCardBrand(widget.cardNumber);
    String brandImage;

    switch (brand) {
      case CreditCardBrand.visa:
        brandImage = 'visa.png';
        break;
      case CreditCardBrand.mastercard:
        brandImage = 'mastercard.png';
        break;
      case CreditCardBrand.amex:
        brandImage = 'amex.png';
        break;
      case CreditCardBrand.discover:
        brandImage = 'discover.png';
        break;
      default:
        brandImage = 'credit_card.png';
    }

    // You would need to add these images to your assets
    return Image.asset(
      'assets/$brandImage',
      height: 30,
      width: 40,
      // package: 'flutter_credit_card',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          // Back card
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_backRotation.value),
                alignment: Alignment.center,
                child: _buildBackCard(),
              );
            },
          ),
          // Front card
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_frontRotation.value),
                alignment: Alignment.center,
                child: _buildFrontCard(),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CreditCardModel {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused;

  CreditCardModel({
    this.cardNumber = '',
    this.expiryDate = '',
    this.cardHolderName = '',
    this.cvvCode = '',
    this.isCvvFocused = false,
  });
}

class CreditCardForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool obscureCvv;
  final bool obscureNumber;
  final String cardNumber;
  final String cvvCode;
  final String cardHolderName;
  final String expiryDate;
  final Color themeColor;
  final Color textColor;
  final InputDecoration cardNumberDecoration;
  final InputDecoration expiryDateDecoration;
  final InputDecoration cvvCodeDecoration;
  final InputDecoration cardHolderDecoration;
  final Function(CreditCardModel) onCreditCardModelChange;

  CreditCardForm({
    required this.formKey,
    required this.obscureCvv,
    required this.obscureNumber,
    required this.cardNumber,
    required this.cvvCode,
    required this.cardHolderName,
    required this.expiryDate,
    required this.themeColor,
    required this.textColor,
    required this.cardNumberDecoration,
    required this.expiryDateDecoration,
    required this.cvvCodeDecoration,
    required this.cardHolderDecoration,
    required this.onCreditCardModelChange,
  });

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  late bool isCvvFocused;

  late FocusNode cvvFocusNode;
  late FocusNode cardNumberFocusNode;
  late FocusNode expiryDateFocusNode;
  late FocusNode cardHolderFocusNode;

  void textFieldFocusDidChange() {
    setState(() {
      isCvvFocused = cvvFocusNode.hasFocus;
    });
  }

  void createCreditCardModel() {
    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;

    CreditCardModel creditCardModel = CreditCardModel(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      isCvvFocused: isCvvFocused,
    );

    widget.onCreditCardModelChange(creditCardModel);
  }

  @override
  void initState() {
    super.initState();

    cardNumber = widget.cardNumber;
    expiryDate = widget.expiryDate;
    cardHolderName = widget.cardHolderName;
    cvvCode = widget.cvvCode;
    isCvvFocused = false;

    cvvFocusNode = FocusNode();
    cardNumberFocusNode = FocusNode();
    expiryDateFocusNode = FocusNode();
    cardHolderFocusNode = FocusNode();

    cvvFocusNode.addListener(textFieldFocusDidChange);
  }

  @override
  void dispose() {
    cvvFocusNode.removeListener(textFieldFocusDidChange);
    cardNumberFocusNode.dispose();
    expiryDateFocusNode.dispose();
    cardHolderFocusNode.dispose();
    cvvFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          // Card Number TextField
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: TextFormField(
              obscureText: widget.obscureNumber,
              focusNode: cardNumberFocusNode,
              controller: TextEditingController()..text = cardNumber,
              decoration: widget.cardNumberDecoration,
              style: TextStyle(color: widget.textColor),
              onChanged: (String value) {
                setState(() {
                  cardNumber = value;
                  createCreditCardModel();
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                CardNumberInputFormatter(),
              ],
              validator: (String? value) {
                // Validation logic here
                if (value == null || value.isEmpty || value.length < 16) {
                  return 'Please enter a valid card number';
                }
                return null;
              },
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(expiryDateFocusNode);
              },
            ),
          ),

          // Expiry Date and CVV Fields Row
          Row(
            children: <Widget>[
              // Expiry Date TextField
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 16, right: 8),
                  child: TextFormField(
                    focusNode: expiryDateFocusNode,
                    controller: TextEditingController()..text = expiryDate,
                    decoration: widget.expiryDateDecoration,
                    style: TextStyle(color: widget.textColor),
                    onChanged: (String value) {
                      setState(() {
                        expiryDate = value;
                        createCreditCardModel();
                      });
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      CardMonthInputFormatter(),
                    ],
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      if (value.length < 5) {
                        return 'Invalid date format';
                      }
                      return null;
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(cvvFocusNode);
                    },
                  ),
                ),
              ),

              // CVV TextField
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 16, left: 8),
                  child: TextFormField(
                    focusNode: cvvFocusNode,
                    obscureText: widget.obscureCvv,
                    controller: TextEditingController()..text = cvvCode,
                    decoration: widget.cvvCodeDecoration,
                    style: TextStyle(color: widget.textColor),
                    onChanged: (String value) {
                      setState(() {
                        cvvCode = value;
                        createCreditCardModel();
                      });
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    validator: (String? value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Please enter a valid CVV';
                      }
                      return null;
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(cardHolderFocusNode);
                    },
                  ),
                ),
              ),
            ],
          ),

          // Card Holder TextField
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: TextFormField(
              focusNode: cardHolderFocusNode,
              controller: TextEditingController()..text = cardHolderName,
              decoration: widget.cardHolderDecoration,
              style: TextStyle(color: widget.textColor),
              onChanged: (String value) {
                setState(() {
                  cardHolderName = value;
                  createCreditCardModel();
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card holder name';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Input formatters for card number and expiry date
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != inputData.length) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.toString().length,
      ),
    );
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.length > 2) {
      if (newText.substring(2, 3) != '/') {
        newText = newText.substring(0, 2) + '/' + newText.substring(2);
      }
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newText.length,
      ),
    );
  }
}
