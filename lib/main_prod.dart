import 'package:champion_car_wash_app/flavor_config.dart';
import 'package:champion_car_wash_app/providers.dart';
import 'package:champion_car_wash_app/view/splashscreen/splash_screen.dart';
import 'package:champion_car_wash_app/service/payment_history_service.dart'
    as history;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.prod,
    values: FlavorValues(baseUrl: 'https://example.com'),
  );
  WidgetsFlutterBinding.ensureInitialized();

  // PERFORMANCE FIX: Don't block app startup with service initialization
  // Initialize services in background after app starts
  Future.microtask(() => _initializeServicesAsync());

  runApp(const AppProviders(child: MyApp()));
}

Future<void> _initializeServicesAsync() async {
  try {
    if (kDebugMode) {
      debugPrint('Initializing Stripe...');
    }
    if (kDebugMode) {
      debugPrint('Stripe initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Stripe initialization failed: $e');
      debugPrint('App will continue without Stripe functionality');
    }
  }

  try {
    if (kDebugMode) {
      debugPrint('Initializing Payment History Service...');
    }
    await history.PaymentHistoryService.instance.initialize();
    if (kDebugMode) {
      debugPrint('Payment History Service initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Payment History Service initialization failed: $e');
      debugPrint('App will continue without payment history functionality');
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
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Sarabun',
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode:
          ThemeMode.dark, // Automatically switch between light and dark mode
      home: const SplashScreen(),
    );
  }
}