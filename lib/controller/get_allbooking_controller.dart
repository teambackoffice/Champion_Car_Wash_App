import 'package:champion_car_wash_app/modal/get_allbooking_modal.dart';
import 'package:champion_car_wash_app/service/get_allbooking_service.dart';
import 'package:flutter/material.dart';

class GetAllbookingController extends ChangeNotifier {
  final GetAllbookingServ _service = GetAllbookingServ();

  GetAllbookingModal? allbooking;
  bool _isLoading = false;
  String? _error;

  // OPTIMIZATION: Enhanced caching with time-based expiration
  DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);
  static const Duration _backgroundRefreshThreshold = Duration(minutes: 3);

  // Getters
  GetAllbookingModal? get allbookings => allbooking;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ServiceData> get bookingData => allbooking?.data ?? [];

  // OPTIMIZATION: Enhanced fetch with time-based caching
  Future<void> fetchBookingList({bool forceRefresh = false}) async {
    final now = DateTime.now();
    
    // Check cache validity
    if (!forceRefresh && _lastFetchTime != null && allbooking != null) {
      final timeSinceLastFetch = now.difference(_lastFetchTime!);
      
      // If cache is still valid, return immediately
      if (timeSinceLastFetch < _cacheValidDuration) {
        // If approaching expiry, trigger background refresh
        if (timeSinceLastFetch > _backgroundRefreshThreshold) {
          _backgroundRefresh();
        }
        return; // Use cached data
      }
    }

    // Only notify if we're not in the initial state
    if (allbooking != null || _error != null) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    } else {
      // Initial load - set loading state without notifying
      _isLoading = true;
      _error = null;
    }

    try {
      allbooking = await _service.getallbooking();
      _lastFetchTime = now;
      _error = null;
    } catch (e) {
      _error = e.toString();
      allbooking = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // OPTIMIZATION: Background refresh for seamless user experience
  Future<void> _backgroundRefresh() async {
    try {
      final freshData = await _service.getallbooking();
      allbooking = freshData;
      _lastFetchTime = DateTime.now();
      _error = null;
      notifyListeners(); // Update UI with fresh data
    } catch (e) {
      // Silently fail background refresh, keep existing data
    }
  }

  // Refresh data (force refresh)
  Future<void> refreshData() async {
    await fetchBookingList(forceRefresh: true);
  }

  // Check if cache is expired
  bool get isCacheExpired {
    if (_lastFetchTime == null) return true;
    return DateTime.now().difference(_lastFetchTime!) >= _cacheValidDuration;
  }

  // Get cache age in minutes
  int get cacheAgeMinutes {
    if (_lastFetchTime == null) return -1;
    return DateTime.now().difference(_lastFetchTime!).inMinutes;
  }

  // Filter bookings by status
  List<ServiceData> getBookingsByStatus(String status) {
    return bookingData.where((booking) => booking.status == status).toList();
  }

  // Search bookings
  List<ServiceData> searchBookings(String query) {
    if (query.isEmpty) return bookingData;
    final lowerQuery = query.toLowerCase();
    return bookingData.where((booking) => 
      booking.customerName.toLowerCase().contains(lowerQuery) ||
      booking.registrationNumber.toLowerCase().contains(lowerQuery) ||
      booking.phone.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
