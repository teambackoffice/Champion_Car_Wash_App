import 'package:champion_car_wash_app/view/bottom_nav/bottom_nav.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/homepage.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/login_logo.png',
                  height: 29,
                  width: 88,
                ),
                const SizedBox(height: 130),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Login Id',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD01C32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                         Navigator.push(
  context, // <- this is missing or misplaced in your code
  MaterialPageRoute(builder: (context) => BottomNavigation()),
);

                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
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