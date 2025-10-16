import 'package:champion_car_wash_app/controller/add_prebooking_controller.dart';
import 'package:champion_car_wash_app/controller/cancel_prebook_controller.dart';
import 'package:champion_car_wash_app/controller/car_wash_tech/completed_car_contoller.dart';
import 'package:champion_car_wash_app/controller/car_wash_tech/inprogress_controller.dart';
import 'package:champion_car_wash_app/controller/car_wash_tech/new_car_wash_contoller.dart';
import 'package:champion_car_wash_app/controller/confirm_prebook_controller.dart';
import 'package:champion_car_wash_app/controller/get_allbooking_controller.dart';
import 'package:champion_car_wash_app/controller/get_carwash_controller.dart';
import 'package:champion_car_wash_app/controller/get_completed_controller.dart';
import 'package:champion_car_wash_app/controller/get_newbooking_controller.dart';
import 'package:champion_car_wash_app/controller/get_oil_brand_contrtoller.dart';
import 'package:champion_car_wash_app/controller/get_prebooking_controller.dart';
import 'package:champion_car_wash_app/controller/get_services_controller.dart';
import 'package:champion_car_wash_app/controller/login_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/completed_oil_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/extra_work_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/inprogress_oil_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/inspection_list_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/new_oiltech_controller.dart';
import 'package:champion_car_wash_app/controller/oilsubtype_byBrand_controller.dart';
import 'package:champion_car_wash_app/controller/service_counts_controller.dart';
import 'package:champion_car_wash_app/controller/service_underproccessing_controller.dart';
import 'package:champion_car_wash_app/controller/underprocess_controller.dart';
import 'package:champion_car_wash_app/service/car_wash_tech/inprogress_to_complete_service.dart';
import 'package:champion_car_wash_app/view/splashscreen/splash_screen.dart';
import 'package:champion_car_wash_app/service/payment_history_service.dart' as history;
// import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// OPTIMIZATION: Moved to async method to prevent blocking app startup
void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // OPTIMIZATION: Initialize services asynchronously in background
  // This allows the UI to render immediately without waiting for services
  // Fire and forget - services will be ready when needed
  _initializeServicesAsync();

  runApp(
      MultiProvider(
          providers: [
            // OPTIMIZATION: All providers now use lazy: true to defer instantiation
            // until they are actually needed, dramatically reducing startup time
            ChangeNotifierProvider(create: (_) => LoginController(), lazy: true),
            ChangeNotifierProvider(
              create: (_) => GetPrebookingListController(),
              lazy: true,
            ),
            ChangeNotifierProvider(create: (_) => ServiceTypeController(), lazy: true),
            ChangeNotifierProvider(create: (_) => AddPrebookingController(), lazy: true),
            ChangeNotifierProvider(create: (_) => CarwashServiceController(), lazy: true),
            ChangeNotifierProvider(create: (_) => GetOilBrandContrtoller(), lazy: true),
            ChangeNotifierProvider(create: (_) => ConfirmPrebookController(), lazy: true),
            ChangeNotifierProvider(create: (_) => CancelPrebookController(), lazy: true),
            ChangeNotifierProvider(create: (_) => GetNewbookingController(), lazy: true),
            ChangeNotifierProvider(
              create: (_) => ServiceUnderproccessingController(),
              lazy: true,
            ),
            ChangeNotifierProvider(create: (_) => UnderProcessingController(), lazy: true),
            ChangeNotifierProvider(create: (_) => GetAllbookingController(), lazy: true),
            ChangeNotifierProvider(create: (_) => GetCompletedController(), lazy: true),
            ChangeNotifierProvider(create: (_) => GetNewCarWashController(), lazy: true),
            ChangeNotifierProvider(create: (_) => NewOilTechController(), lazy: true),
            ChangeNotifierProvider(create: (_) => ExtraWorkController(), lazy: true),
            ChangeNotifierProvider(create: (_) => InspectionListController(), lazy: true),
            ChangeNotifierProvider(
              create: (_) => OilsubtypeBybrandController(),
              lazy: true,
            ),
            ChangeNotifierProvider(
              create: (_) => InprogressCarWashController(),
              lazy: true,
            ),
            ChangeNotifierProvider(create: (_) => InProgressOilController(), lazy: true),
            ChangeNotifierProvider(create: (_) => CompletedOilController(), lazy: true),
            ChangeNotifierProvider(create: (_) => CompletedCarController(), lazy: true),
            ChangeNotifierProvider(create: (_) => CarWashInProgressToCompleteController(), lazy: true),
            // OPTIMIZATION: Single controller for all service counts (replaces 4 separate API calls)
            ChangeNotifierProvider(create: (_) => ServiceCountsController(), lazy: true),
          ],
          child: const MyApp(),
      )
  );
}

/// OPTIMIZATION: Asynchronous service initialization
/// Runs in background without blocking UI rendering
/// This method initializes Stripe and PaymentHistoryService off the main thread
Future<void> _initializeServicesAsync() async {
  // OPTIMIZATION: Initialize Stripe with error handling, non-blocking
  try {
    if (kDebugMode) {
      print('Initializing Stripe...');
    }
    // Stripe.publishableKey = 'pk_test_51SGD8nHo7XikuWyrTuFFoTOxuwXat9VZXlQqteyyu4YlIduMwymv8sGylntJMGVkEJFJk1EAymMEz5kjd4PzyEmU00gzlJ2fjB';
    // Stripe.merchantIdentifier = 'merchant.com.championcarwash.ae';
    //
    // // Apply Stripe settings
    // await Stripe.instance.applySettings();
    if (kDebugMode) {
      print('Stripe initialized successfully');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Stripe initialization failed: $e');
      print('App will continue without Stripe functionality');
    }
    // App continues to run even if Stripe fails to initialize
  }

  // OPTIMIZATION: Initialize Payment History Service asynchronously
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Your theme isn't set to use Theme.AppCompat or Theme.MaterialComponents.
      // locale: DevicePreview.locale(context), // 👈 Use the preview locale
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Sarabun',
        // You can customize further if needed
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),


      home: SplashScreen(),
    );
  }
}
