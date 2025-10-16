import 'package:champion_car_wash_app/modal/get_newbooking_modal.dart';
import 'package:champion_car_wash_app/service/get_new_booking_list_service.dart';
import 'package:flutter/material.dart';

class GetNewbookingController extends ChangeNotifier {
  final GetNewBookingListService _service = GetNewBookingListService();

  GetNewBookingListModal? _bookingList;
  bool _isLoading = false;
  String? _error;

  // OPTIMIZATION: Enhanced caching with time-based expiration
  DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);
  static const Duration _backgroundRefreshThreshold = Duration(minutes: 3);

  // Getters
  GetNewBookingListModal? get bookingList => _bookingList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ServiceData> get bookingData => _bookingList?.data ?? [];

  // OPTIMIZATION: Enhanced fetch with time-based caching
  Future<void> fetchBookingList({bool forceRefresh = false}) async {
    final now = DateTime.now();
    
    // Check cache validity
    if (!forceRefresh && _lastFetchTime != null && _bookingList != null) {
      final timeSinceLastFetch = now.difference(_lastFetchTime!);
      
      // If cache is still valid, return immediately
      if (timeSinceLastFetch < _cacheValidDuration) {
        // If approaching expiry, trigger background refresh
        if (timeSinceLastFetch > _backgroundRefreshThreshold) {
          // ignore: unawaited_futures
          _backgroundRefresh();
        }
        return; // Use cached data
      }
    }

    // Only notify if we're not in the initial state
    if (_bookingList != null || _error != null) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    } else {
      // Initial load - set loading state without notifying
      _isLoading = true;
      _error = null;
    }

    try {
      _bookingList = await _service.getnewbookinglist();
      _lastFetchTime = now;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _bookingList = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // OPTIMIZATION: Background refresh for seamless user experience
  Future<void> _backgroundRefresh() async {
    try {
      final freshData = await _service.getnewbookinglist();
      _bookingList = freshData;
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

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
