import 'package:champion_car_wash_app/modal/get_prebooking_list.dart';
import 'package:champion_car_wash_app/service/get_prebooking_list_service.dart';
import 'package:flutter/material.dart';

class GetPrebookingListController extends ChangeNotifier {
  final GetPrebookingListService _service = GetPrebookingListService();

  GetPreBookingList? _preBookingList;
  bool _isLoading = false;
  String? _error;

  // Getters
  GetPreBookingList? get preBookingList => _preBookingList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Datum> get bookingData => _preBookingList?.message.data ?? [];

  // Fetch pre-booking list
  Future<void> fetchPreBookingList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _preBookingList = await _service.getPreBookingList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _preBookingList = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchPreBookingList();
  }

  // Filter bookings by status
  List<Datum> getBookingsByStatus(String status) {
    return bookingData.where((booking) => booking.status == status).toList();
  }

  // Filter bookings by date
  List<Datum> getBookingsByDate(DateTime date) {
    return bookingData
        .where(
          (booking) =>
              booking.date.year == date.year &&
              booking.date.month == date.month &&
              booking.date.day == date.day,
        )
        .toList();
  }

  // Search bookings by customer name or phone

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
