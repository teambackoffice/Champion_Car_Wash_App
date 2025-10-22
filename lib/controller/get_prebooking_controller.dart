import 'package:champion_car_wash_app/modal/get_prebooking_list.dart';
import 'package:champion_car_wash_app/service/get_prebooking_list_service.dart';
import 'package:flutter/material.dart';

class GetPrebookingListController extends ChangeNotifier {
  final GetPrebookingListService _service = GetPrebookingListService();

  GetPreBookingList? _preBookingList;
  bool _isLoading = false;
  String? _error;

  // OPTIMIZATION: Enhanced caching with configurable TTL
  DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(
    minutes: 5,
  ); // Increased TTL
  static const Duration _backgroundRefreshThreshold = Duration(
    minutes: 3,
  ); // Background refresh

  // Getters
  GetPreBookingList? get preBookingList => _preBookingList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Datum> get bookingData => _preBookingList?.message.data ?? [];

  // Fetch pre-booking list
  Future<void> fetchPreBookingList({bool forceRefresh = false}) async {
    print(
      '📅 [PRE_BOOKING_CONTROLLER] fetchPreBookingList called - forceRefresh: $forceRefresh',
    );

    final now = DateTime.now();

    // OPTIMIZATION: Enhanced caching logic with background refresh
    if (!forceRefresh && _lastFetchTime != null && _preBookingList != null) {
      final timeSinceLastFetch = now.difference(_lastFetchTime!);
      print(
        '📅 [PRE_BOOKING_CONTROLLER] Cache check - time since last fetch: ${timeSinceLastFetch.inMinutes} minutes',
      );

      // If cache is still valid, return immediately
      if (timeSinceLastFetch < _cacheValidDuration) {
        print(
          '📅 [PRE_BOOKING_CONTROLLER] Using cached data (${bookingData.length} bookings)',
        );

        // If approaching expiry, trigger background refresh
        if (timeSinceLastFetch > _backgroundRefreshThreshold) {
          print('📅 [PRE_BOOKING_CONTROLLER] Triggering background refresh');
          // ignore: unawaited_futures
          _backgroundRefresh();
        }
        return; // Use cached data
      }
    }

    print('📅 [PRE_BOOKING_CONTROLLER] Fetching fresh data from API...');

    // Set loading state and notify listeners
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _preBookingList = await _service.getPreBookingList();
      _lastFetchTime = DateTime.now(); // OPTIMIZATION: Update cache timestamp
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
    await fetchPreBookingList(
      forceRefresh: true,
    ); // OPTIMIZATION: Force refresh
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

  // OPTIMIZATION: Background refresh for seamless user experience
  Future<void> _backgroundRefresh() async {
    try {
      final freshData = await _service.getPreBookingList();
      _preBookingList = freshData;
      _lastFetchTime = DateTime.now();
      _error = null;
      notifyListeners(); // Update UI with fresh data
    } catch (e) {
      // Silently fail background refresh, keep existing data
    }
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
