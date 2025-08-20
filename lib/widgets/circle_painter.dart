import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange // Farbe des Kreises
      ..style = PaintingStyle.stroke // Nur Umrandung zeichnen
      ..strokeWidth = 5.0; // Dicke der Linie

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - paint.strokeWidth / 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CircleUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Hintergrundfarbe
      body: Center(
        child: CustomPaint(
          size: Size(50, 50), // Größe des Kreises
          painter: CirclePainter(), // Der CustomPainter
        ),
      ),
    );
  }
}
