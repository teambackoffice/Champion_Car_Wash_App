import 'package:champion_car_wash_app/modal/oil_tech/inspection_list_modal.dart';
import 'package:champion_car_wash_app/service/oil_tech/inspection_list_service.dart';
import 'package:flutter/material.dart';

class InspectionListController extends ChangeNotifier {
  final InspectionListService _service = InspectionListService();

  bool isLoading = false;
  String? error;
  List<Question> inspectionItems = [];

  /// Fetch inspection checklist
  Future<void> fetchInspectionList(String inspectionType) async {
    print('🔍 [INSPECTION_CONTROLLER] Starting fetchInspectionList for type: $inspectionType');
    
    try {
      isLoading = true;
      error = null;
      print('🔍 [INSPECTION_CONTROLLER] Setting loading state to true');
      notifyListeners();

      print('🔍 [INSPECTION_CONTROLLER] Calling inspection service...');
      final data = await _service.getInspectionList(inspectionType);
      
      print('🔍 [INSPECTION_CONTROLLER] Service call successful');
      print('🔍 [INSPECTION_CONTROLLER] Raw data received: ${data.message.questions.length} questions');
      
      if (!data.message.success) {
        throw Exception('API returned success: false');
      }
      
      if (data.message.questions.isEmpty) {
        print('⚠️ [INSPECTION_CONTROLLER] Warning: No inspection questions received');
      }
      
      inspectionItems = data.message.questions
          .map(
            (q) => Question(questions: q.questions, isMandatory: q.isMandatory),
          )
          .toList();
          
      print('🔍 [INSPECTION_CONTROLLER] Mapped ${inspectionItems.length} inspection items');
      for (int i = 0; i < inspectionItems.length; i++) {
        print('🔍 [INSPECTION_CONTROLLER] Item $i: ${inspectionItems[i].questions} (Mandatory: ${inspectionItems[i].isMandatory})');
      }
      
    } catch (e) {
      print('❌ [INSPECTION_CONTROLLER] Error fetching inspection list: $e');
      error = 'Failed to load inspection list: $e';
    } finally {
      isLoading = false;
      print('🔍 [INSPECTION_CONTROLLER] Setting loading state to false');
      notifyListeners();
    }
  }

  /// Toggle a checkbox
  void toggleCheck(int index, bool value) {
    print('🔍 [INSPECTION_CONTROLLER] Toggling item $index to $value');
    
    if (index < 0 || index >= inspectionItems.length) {
      print('❌ [INSPECTION_CONTROLLER] Invalid index: $index (total items: ${inspectionItems.length})');
      return;
    }
    
    print('🔍 [INSPECTION_CONTROLLER] Item: ${inspectionItems[index].questions}');
    
    inspectionItems[index].isChecked = value;
    
    print('🔍 [INSPECTION_CONTROLLER] All items checked status: $allItemsChecked');
    notifyListeners();
  }

  /// Check if all are checked
  bool get allItemsChecked =>
      inspectionItems.isNotEmpty &&
      inspectionItems.every((item) => item.isChecked);
}
