import 'package:champion_car_wash_app/modal/get_completed_modal.dart';
import 'package:champion_car_wash_app/service/get_completed_services.dart';
import 'package:flutter/material.dart';

class GetCompletedController extends ChangeNotifier {
  final GetCompletedServices _service = GetCompletedServices();

  GetCompletedModal? completedservices;
  bool _isLoading = false;
  String? _error;

  // OPTIMIZATION: Enhanced caching with time-based expiration
  DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(
    minutes: 10,
  ); // Longer for completed data
  static const Duration _backgroundRefreshThreshold = Duration(minutes: 7);

  // Getters
  GetCompletedModal? get completed => completedservices;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CompletedServiceData> get bookingData => completedservices?.data ?? [];

  // OPTIMIZATION: Enhanced fetch with time-based caching
  Future<void> fetchcompletedlist({bool forceRefresh = false}) async {
    print(
      '✅ [COMPLETED_CONTROLLER] fetchcompletedlist called - forceRefresh: $forceRefresh',
    );

    final now = DateTime.now();

    // Check cache validity
    if (!forceRefresh && _lastFetchTime != null && completedservices != null) {
      final timeSinceLastFetch = now.difference(_lastFetchTime!);
      print(
        '✅ [COMPLETED_CONTROLLER] Cache check - time since last fetch: ${timeSinceLastFetch.inMinutes} minutes',
      );

      // If cache is still valid, return immediately
      if (timeSinceLastFetch < _cacheValidDuration) {
        print(
          '✅ [COMPLETED_CONTROLLER] Using cached data (${bookingData.length} services)',
        );

        // If approaching expiry, trigger background refresh
        if (timeSinceLastFetch > _backgroundRefreshThreshold) {
          print('✅ [COMPLETED_CONTROLLER] Triggering background refresh');
          // ignore: unawaited_futures
          _backgroundRefresh();
        }
        return; // Use cached data
      }
    }

    print('✅ [COMPLETED_CONTROLLER] Fetching fresh data from API...');

    // Only notify if we're not in the initial state
    if (completedservices != null || _error != null) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    } else {
      // Initial load - set loading state without notifying
      _isLoading = true;
      _error = null;
    }

    try {
      completedservices = await _service.getcompleted();
      _lastFetchTime = now;
      _error = null;
    } catch (e) {
      _error = e.toString();
      completedservices = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // OPTIMIZATION: Background refresh for seamless user experience
  Future<void> _backgroundRefresh() async {
    try {
      final freshData = await _service.getcompleted();
      completedservices = freshData;
      _lastFetchTime = DateTime.now();
      _error = null;
      notifyListeners(); // Update UI with fresh data
    } catch (e) {
      // Silently fail background refresh, keep existing data
    }
  }

  // Refresh data (force refresh)
  Future<void> refreshData() async {
    await fetchcompletedlist(forceRefresh: true);
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
