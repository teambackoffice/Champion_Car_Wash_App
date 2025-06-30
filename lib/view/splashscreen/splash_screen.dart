import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/logo2.png', // Replace with your logo path
          width: 200, // Adjust size as needed
          height: 200, // Adjust size as needed
        ),
      ),
    );
  }
}