import 'dart:convert';

import 'package:champion_car_wash_app/view/bottom_nav/bottom_nav.dart';
import 'package:champion_car_wash_app/view/carwash_tech/carwas_homepage.dart';
import 'package:champion_car_wash_app/view/login/login.dart';
import 'package:champion_car_wash_app/view/oil_tech/oil_homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Top-level function to be executed in a separate isolate
Future<Map<String, String?>> _readSecureStorageData(
  RootIsolateToken? token,
) async {
  // Ensure the background isolate can communicate with the platform
  if (token != null) {
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);
  }
  const secureStorage = FlutterSecureStorage();
  String? apiKey = await secureStorage.read(key: 'api_key');
  String? rolesString = await secureStorage.read(key: 'roles');
  return {'api_key': apiKey, 'roles': rolesString};
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Get the token before going into the background isolate
    final token = RootIsolateToken.instance;
    // Run the secure storage reading in a background isolate
    final secureData = await compute(_readSecureStorageData, token);

    final apiKey = secureData['api_key'];
    final rolesString = secureData['roles'];

    if (mounted) {
      if (apiKey != null && rolesString != null) {
        List<String> roles = List<String>.from(jsonDecode(rolesString));

        if (roles.contains('Carwash Technician')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const CarWashTechnicianHomePage(),
            ),
          );
        } else if (roles.contains('Oil Technician')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OilTechnicianHomePage()),
          );
          return;
        } else if (roles.contains('supervisors')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BottomNavigation()),
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
