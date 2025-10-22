import 'package:champion_car_wash_app/modal/add_prebooking_modal.dart';
import 'package:champion_car_wash_app/service/add_prebooking_service.dart';
import 'package:flutter/material.dart';

class AddPrebookingController extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> addPrebook({required AddPreBookingList prebook}) async {
    setIsLoading(true);
    notifyListeners();
    try {
      await AddPrebookingService.addPreBooking(preBooking: prebook);
      return true;
    } finally {
      setIsLoading(false);
      notifyListeners();
    }
  }

  void setIsLoading(bool value) {
    isLoading = value;
  }
}
