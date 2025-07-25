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
import 'package:champion_car_wash_app/controller/service_underproccessing_controller.dart';
import 'package:champion_car_wash_app/controller/underprocess_controller.dart';
import 'package:champion_car_wash_app/view/splashscreen/splash_screen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LoginController()),
            ChangeNotifierProvider(
              create: (_) => GetPrebookingListController(),
            ),
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
            ChangeNotifierProvider(create: (_) => GetNewCarWashController()),
            ChangeNotifierProvider(create: (_) => NewOilTechController()),
            ChangeNotifierProvider(create: (_) => ExtraWorkController()),
            ChangeNotifierProvider(create: (_) => InspectionListController()),
            ChangeNotifierProvider(
              create: (_) => OilsubtypeBybrandController(),
            ),
            ChangeNotifierProvider(
              create: (_) => InprogressCarWashController(),
            ),
            ChangeNotifierProvider(create: (_) => InProgressOilController()),
            ChangeNotifierProvider(create: (_) => CompletedOilController()),
            ChangeNotifierProvider(create: (_) => CompletedCarController()),
          ],
          child: MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true, // 👈 Important for device_preview
      locale: DevicePreview.locale(context), // 👈 Use the preview locale
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Sarabun',
        // You can customize further if needed
      ),

      home: SplashScreen(),
    );
  }
}
