import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width *
                  0.05, // 5% of screen width
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: MediaQuery.sizeOf(context).height * .15,
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

                const SizedBox(height: 40),

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
        ),
      ),
    );
  }
}
