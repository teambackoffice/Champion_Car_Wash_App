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
import 'package:champion_car_wash_app/controller/oil_subtype_by_brand_controller.dart';
import 'package:champion_car_wash_app/controller/service_counts_controller.dart';
import 'package:champion_car_wash_app/controller/service_underproccessing_controller.dart';
import 'package:champion_car_wash_app/controller/underprocess_controller.dart';
import 'package:champion_car_wash_app/service/car_wash_tech/inprogress_to_complete_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        ChangeNotifierProvider(create: (_) => ServiceCountsController(), lazy: true),
      ],
      child: child,
    );
  }
}
