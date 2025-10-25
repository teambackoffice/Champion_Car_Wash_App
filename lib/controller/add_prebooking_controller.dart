import 'package:champion_car_wash_app/modal/add_prebooking_modal.dart';
import 'package:champion_car_wash_app/service/add_prebooking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget_updater.dart';

class AddPrebookingController extends ChangeNotifier {
  bool isLoading = false;

  Future<bool> addPrebook({required AddPreBookingList prebook}) async {
    setIsLoading(true);
    notifyListeners();
    try {
      await AddPrebookingService.addPreBooking(preBooking: prebook);
      final serviceNames = prebook.services.map((s) => s.service).join(', ');
      final formattedDate = DateFormat('MMM dd, yyyy').format(prebook.date);
      
      // Get customer and vehicle info from available fields
      final customerName = prebook.customerName;
      final vehicleInfo = prebook.regNumber.isNotEmpty 
          ? 'Reg: ${prebook.regNumber}'
          : 'Vehicle Details';
      
      await updateBookingWidget(
        service: serviceNames,
        customer: customerName,
        date: formattedDate,
        time: prebook.time,
        vehicle: vehicleInfo,
        status: 'SCHEDULED',
      );
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
