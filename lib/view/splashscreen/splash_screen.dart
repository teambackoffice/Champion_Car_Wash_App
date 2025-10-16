import 'dart:convert';

import 'package:champion_car_wash_app/view/bottom_nav/bottom_nav.dart';
import 'package:champion_car_wash_app/view/carwash_tech/carwas_homepage.dart';
import 'package:champion_car_wash_app/view/login/login.dart';
import 'package:champion_car_wash_app/view/oil_tech/oil_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // await Future.delayed(const Duration(seconds: 3));

    // Check if user is logged in by checking API key or SID
    String? apiKey = await _secureStorage.read(key: 'api_key');
    String? rolesString = await _secureStorage.read(key: 'roles');

    if (mounted) {
      if (apiKey != null && rolesString != null) {
        List<String> roles = List<String>.from(jsonDecode(rolesString));

        if (roles.contains('Carwash Technician')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => CarWashTechnicianHomePage()),
          );
        } else if (roles.contains('Oil Technician')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => OilTechnicianHomePage()),
          );
          return;
        } else if (roles.contains('supervisors')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BottomNavigation()),
          );
        } else {
          // Unknown role fallback
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } else {
        // Not logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: No controllers to dispose, but good practice
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset('assets/logo.png', width: 200, height: 200),
      ),
    );
  }
}
