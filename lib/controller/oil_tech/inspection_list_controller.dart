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
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final data = await _service.getInspectionList(inspectionType);
      inspectionItems = data.message.questions
          .map(
            (q) => Question(
              questions: q.questions,
              isMandatory: q.isMandatory,
            ),
          )
          .toList();
    } catch (e) {
      error = 'Failed to load inspection list';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle a checkbox
  void toggleCheck(int index, bool value) {
    inspectionItems[index].isChecked = value;
    notifyListeners();
  }

  /// Check if all are checked
  bool get allItemsChecked =>
      inspectionItems.isNotEmpty &&
      inspectionItems.every((item) => item.isChecked);
}
