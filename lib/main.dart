import 'package:champion_car_wash_app/controller/add_prebooking_controller.dart';
import 'package:champion_car_wash_app/controller/cancel_prebook_controller.dart';
import 'package:champion_car_wash_app/controller/confirm_prebook_controller.dart';
import 'package:champion_car_wash_app/controller/get_allbooking_controller.dart';
import 'package:champion_car_wash_app/controller/get_carwash_controller.dart';
import 'package:champion_car_wash_app/controller/get_completed_controller.dart';
import 'package:champion_car_wash_app/controller/get_newbooking_controller.dart';
import 'package:champion_car_wash_app/controller/get_oil_brand_contrtoller.dart';
import 'package:champion_car_wash_app/controller/get_prebooking_controller.dart';
import 'package:champion_car_wash_app/controller/get_services_controller.dart';
import 'package:champion_car_wash_app/controller/login_controller.dart';
import 'package:champion_car_wash_app/controller/service_underproccessing_controller.dart';
import 'package:champion_car_wash_app/controller/underprocess_controller.dart';
import 'package:champion_car_wash_app/view/splashscreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => GetPrebookingListController()),
        ChangeNotifierProvider(create: (_) => ServiceTypeController()),
        ChangeNotifierProvider(create: (_) => AddPrebookingController()),
        ChangeNotifierProvider(create: (_) => CarwashServiceController()),
        ChangeNotifierProvider(create: (_) => GetOilBrandContrtoller()),
        ChangeNotifierProvider(create: (_) => ConfirmPrebookController()),
        ChangeNotifierProvider(create: (_) => CancelPrebookController()),
        ChangeNotifierProvider(create: (_) => GetNewbookingController()),
        ChangeNotifierProvider(
          create: (_) => ServiceUnderproccessingController(),
        ),
        ChangeNotifierProvider(create: (_) => UnderProcessingController()),
        ChangeNotifierProvider(create: (_) => GetAllbookingController()),
        ChangeNotifierProvider(create: (_) => GetCompletedController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Sarabun',
        // You can customize further if needed
      ),

      home: SplashScreen(),
    );
  }
}
