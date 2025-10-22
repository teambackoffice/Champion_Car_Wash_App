import 'package:champion_car_wash_app/service/oil_tech/inspection_list_service.dart';
import 'package:champion_car_wash_app/controller/oil_tech/inspection_list_controller.dart';
import 'package:flutter/foundation.dart';

class InspectionFlowTester {
  static Future<void> testInspectionFlow() async {
    if (kDebugMode) {
      print('🧪 [INSPECTION_TEST] Starting inspection flow test...');
      
      try {
        // Test 1: Service API call
        print('🧪 [INSPECTION_TEST] Test 1: Testing service API call');
        final service = InspectionListService();
        final result = await service.getInspectionList('oil change');
        
        print('🧪 [INSPECTION_TEST] ✅ Service test passed');
        print('🧪 [INSPECTION_TEST] Questions received: ${result.message.questions.length}');
        
        // Test 2: Controller functionality
        print('🧪 [INSPECTION_TEST] Test 2: Testing controller');
        final controller = InspectionListController();
        await controller.fetchInspectionList('oil change');
        
        if (controller.error != null) {
          print('🧪 [INSPECTION_TEST] ❌ Controller error: ${controller.error}');
        } else {
          print('🧪 [INSPECTION_TEST] ✅ Controller test passed');
          print('🧪 [INSPECTION_TEST] Items loaded: ${controller.inspectionItems.length}');
          
          // Test 3: Toggle functionality
          if (controller.inspectionItems.isNotEmpty) {
            print('🧪 [INSPECTION_TEST] Test 3: Testing toggle functionality');
            controller.toggleCheck(0, true);
            print('🧪 [INSPECTION_TEST] ✅ Toggle test passed');
          }
        }
        
      } catch (e) {
        print('🧪 [INSPECTION_TEST] ❌ Test failed: $e');
      }
    }
  }

  static void logInspectionState(InspectionListController controller) {
    if (kDebugMode) {
      print('🧪 [INSPECTION_STATE] Current state:');
      print('🧪 [INSPECTION_STATE] - Loading: ${controller.isLoading}');
      print('🧪 [INSPECTION_STATE] - Error: ${controller.error}');
      print('🧪 [INSPECTION_STATE] - Items count: ${controller.inspectionItems.length}');
      print('🧪 [INSPECTION_STATE] - All checked: ${controller.allItemsChecked}');
      
      for (int i = 0; i < controller.inspectionItems.length; i++) {
        final item = controller.inspectionItems[i];
        print('🧪 [INSPECTION_STATE] - Item $i: "${item.questions}" (checked: ${item.isChecked}, mandatory: ${item.isMandatory})');
      }
    }
  }
}