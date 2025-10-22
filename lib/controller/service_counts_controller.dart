import 'package:champion_car_wash_app/modal/service_counts_modal.dart';
import 'package:champion_car_wash_app/service/service_counts_service.dart';
import 'package:flutter/material.dart';

/// Controller for managing service and prebooking counts
/// Used on the home screen to display dashboard statistics
class ServiceCountsController extends ChangeNotifier {
  final ServiceCountsService _service = ServiceCountsService();

  ServiceCountsResponse? _countsResponse;
  bool _isLoading = false;
  String? _error;

  // OPTIMIZATION: Enhanced caching with time-based expiration
  DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(minutes: 2);
  static const Duration _backgroundRefreshThreshold = Duration(minutes: 1);

  // Getters
  ServiceCountsResponse? get countsResponse => _countsResponse;
  ServiceCounts? get counts => _countsResponse?.counts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Individual count getters for convenience
  int get prebookingCount => counts?.prebookingCount ?? 0;
  int get openServiceCount => counts?.openServiceCount ?? 0;
  int get inprogressServiceCount => counts?.inprogressServiceCount ?? 0;
  int get completedServiceCount => counts?.completedServiceCount ?? 0;
  int get totalServiceCount => counts?.totalServiceCount ?? 0;

  /// Fetch service counts from API
  /// [forceRefresh] - If true, bypasses cache and fetches fresh data
  Future<void> fetchServiceCounts({bool forceRefresh = false}) async {
    print('📊 [SERVICE_COUNTS] fetchServiceCounts called - forceRefresh: $forceRefresh');
    
    final now = DateTime.now();

    // Check cache validity
    if (!forceRefresh && _lastFetchTime != null && _countsResponse != null) {
      final timeSinceLastFetch = now.difference(_lastFetchTime!);
      print('📊 [SERVICE_COUNTS] Cache check - time since last fetch: ${timeSinceLastFetch.inMinutes} minutes');

      // If cache is still valid, return immediately
      if (timeSinceLastFetch < _cacheValidDuration) {
        print('📊 [SERVICE_COUNTS] Using cached data (valid for ${_cacheValidDuration.inMinutes} minutes)');
        
        // If approaching expiry, trigger background refresh
        if (timeSinceLastFetch > _backgroundRefreshThreshold) {
          print('📊 [SERVICE_COUNTS] Triggering background refresh');
          // Ignore result - background refresh is fire-and-forget
          // ignore: unawaited_futures
          _backgroundRefresh();
        }
        return; // Use cached data
      }
    }

    print('📊 [SERVICE_COUNTS] Fetching fresh data from API...');

    // Only notify if we're not in the initial state
    if (_countsResponse != null || _error != null) {
      _isLoading = true;
      _error = null;
      print('📊 [SERVICE_COUNTS] Setting loading state and notifying listeners');
      notifyListeners();
    } else {
      // Initial load - set loading state without notifying
      _isLoading = true;
      _error = null;
      print('📊 [SERVICE_COUNTS] Initial load - setting loading state');
    }

    try {
      _countsResponse = await _service.getServiceCounts();
      _lastFetchTime = now;
      _error = null;
      
      print('✅ [SERVICE_COUNTS] API call successful');
      print('📊 [SERVICE_COUNTS] Counts - Open: ${openServiceCount}, Pre: ${prebookingCount}, InProgress: ${inprogressServiceCount}, Completed: ${completedServiceCount}');
    } catch (e) {
      _error = e.toString();
      _countsResponse = null;
      print('❌ [SERVICE_COUNTS] API call failed: $e');
    } finally {
      _isLoading = false;
      print('📊 [SERVICE_COUNTS] Notifying listeners with final state');
      notifyListeners();
    }
  }

  /// Background refresh for seamless user experience
  /// Silently updates data without showing loading indicators
  Future<void> _backgroundRefresh() async {
    print('🔄 [SERVICE_COUNTS] Background refresh started');
    
    try {
      final freshData = await _service.getServiceCounts();
      _countsResponse = freshData;
      _lastFetchTime = DateTime.now();
      _error = null;
      print('✅ [SERVICE_COUNTS] Background refresh successful');
      notifyListeners(); // Update UI with fresh data
    } catch (e) {
      print('❌ [SERVICE_COUNTS] Background refresh failed: $e');
      // Silently fail background refresh, keep existing data
    }
  }

  /// Force refresh data
  /// Shows loading indicator and fetches fresh data
  Future<void> refreshData() async {
    print('🔄 [SERVICE_COUNTS] Force refresh requested');
    await fetchServiceCounts(forceRefresh: true);
  }

  /// Clear all data and reset state
  void clearData() {
    _countsResponse = null;
    _error = null;
    _isLoading = false;
    _lastFetchTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
