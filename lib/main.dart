import 'package:champion_car_wash_app/providers.dart';
import 'package:champion_car_wash_app/view/splashscreen/splash_screen.dart';
import 'package:champion_car_wash_app/service/payment_history_service.dart' as history;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _initializeServicesAsync();

  runApp(
    const AppProviders(
      child: MyApp(),
    ),
  );
}

Future<void> _initializeServicesAsync() async {
  try {
    if (kDebugMode) {
      print('Initializing Stripe...');
    }
    if (kDebugMode) {
      print('Stripe initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Stripe initialization failed: $e');
      print('App will continue without Stripe functionality');
    }
  }

  try {
    if (kDebugMode) {
      print('Initializing Payment History Service...');
    }
    await history.PaymentHistoryService.instance.initialize();
    if (kDebugMode) {
      print('Payment History Service initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Payment History Service initialization failed: $e');
      print('App will continue without payment history functionality');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Sarabun',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}