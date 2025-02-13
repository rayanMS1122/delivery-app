import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F8),
        ),
        constraints: const BoxConstraints(maxWidth: 480),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(25, 47, 25, 47),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              "History",
              style: TextStyle(
                fontFamily: "SF-Pro-Text",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 40),

            // Illustration and Message
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history, // Use a more meaningful icon
                    size: 100,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No history yet",
                    style: TextStyle(
                      fontFamily: "SF-Pro-Text",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Hit the orange button below\nto create an order",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "SF-Pro-Text",
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Start Ordering Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFFA4A0C),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFA4A0C).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    // Add navigation or action here
                  },
                  child: Center(
                    child: Text(
                      "Start Ordering",
                      style: TextStyle(
                        fontFamily: "SF-Pro-Text",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
