import 'dart:async';
import '../models/test_results.dart';
import '../models/performance_metrics.dart';

/// Base interface for all performance tests in the Champion Car Wash app
abstract class PerformanceTestInterface {
  /// Name of the performance test
  String get testName;

  /// Description of what this test validates
  String get description;

  /// Target performance threshold for this test
  double get targetThreshold;

  /// Unit of measurement for this test
  String get unit;

  /// Execute the performance test
  Future<TestResults> execute();

  /// Setup required before test execution
  Future<void> setUp() async {}

  /// Cleanup after test execution
  Future<void> tearDown() async {}

  /// Validate test results against requirements
  bool validateResults(TestResults results);
}

/// Interface for startup performance testing
abstract class StartupTestInterface extends PerformanceTestInterface {
  /// Measure app startup time with StatefulWidget counting
  Future<double> measureStartupTime();

  /// Count active StatefulWidgets during startup
  Future<int> countStatefulWidgets();

  /// Measure first meaningful paint time
  Future<double> measureFirstMeaningfulPaint();
}

/// Interface for memory performance testing
abstract class MemoryTestInterface extends PerformanceTestInterface {
  /// Monitor memory usage over specified duration
  Future<List<double>> monitorMemoryUsage(Duration duration);

  /// Detect memory leaks in StatefulWidgets
  Future<List<String>> detectMemoryLeaks();

  /// Validate StatefulWidget disposal
  Future<bool> validateWidgetDisposal();

  /// Check for undisposed controllers
  Future<List<String>> findUndisposedControllers();
}

/// Interface for UI performance testing
abstract class UITestInterface extends PerformanceTestInterface {
  /// Measure scrolling performance with specified item count
  Future<double> measureScrollingPerformance(int itemCount);

  /// Monitor frame rate during UI interactions
  Future<double> measureFrameRate();

  /// Count frame skips during animations
  Future<int> countFrameSkips();

  /// Test search functionality with debouncing
  Future<double> measureSearchPerformance();
}

/// Interface for API performance testing
abstract class APITestInterface extends PerformanceTestInterface {
  /// Measure API response times
  Future<List<double>> measureResponseTimes(List<String> endpoints);

  /// Test caching efficiency
  Future<double> measureCacheHitRate();

  /// Validate network error handling
  Future<bool> validateErrorHandling();

  /// Test concurrent API requests
  Future<double> measureConcurrentRequestPerformance();
}

/// Interface for device-specific testing
abstract class DeviceTestInterface extends PerformanceTestInterface {
  /// Test performance on low-end devices
  Future<TestResults> testLowEndDevice();

  /// Test performance on high-end devices
  Future<TestResults> testHighEndDevice();

  /// Measure battery impact during extended usage
  Future<double> measureBatteryImpact(Duration duration);

  /// Get device specifications for testing context
  Future<Map<String, dynamic>> getDeviceSpecs();
}

/// Interface for Champion Car Wash specific workflow testing
abstract class WorkflowTestInterface extends PerformanceTestInterface {
  /// Test technician workflow performance
  Future<TestResults> testTechnicianWorkflow();

  /// Test booking management performance
  Future<TestResults> testBookingManagement();

  /// Test payment processing workflow
  Future<TestResults> testPaymentWorkflow();

  /// Test supervisor dashboard performance
  Future<TestResults> testSupervisorDashboard();
}

/// Interface for performance monitoring
abstract class PerformanceMonitorInterface {
  /// Start continuous performance monitoring
  Future<void> startMonitoring();

  /// Stop performance monitoring
  Future<void> stopMonitoring();

  /// Get current performance metrics
  Future<PerformanceMetrics> getCurrentMetrics();

  /// Get performance metrics history
  Future<List<PerformanceMetrics>> getMetricsHistory(Duration period);

  /// Set alert thresholds
  void setAlertThresholds(Map<String, double> thresholds);

  /// Stream of performance alerts
  Stream<PerformanceAlert> get alertStream;
}

/// Performance alert data structure
class PerformanceAlert {
  final AlertLevel level;
  final String metric;
  final double currentValue;
  final double threshold;
  final String message;
  final DateTime timestamp;

  const PerformanceAlert({
    required this.level,
    required this.metric,
    required this.currentValue,
    required this.threshold,
    required this.message,
    required this.timestamp,
  });

  @override
  String toString() {
    return '${level.name.toUpperCase()} ALERT: $message '
        '(Current: $currentValue, Threshold: $threshold)';
  }
}

/// Alert severity levels
enum AlertLevel {
  green, // Performance is optimal
  yellow, // Performance degradation detected
  red; // Critical performance issues

  /// Human-readable description
  String get description {
    switch (this) {
      case AlertLevel.green:
        return 'Optimal Performance';
      case AlertLevel.yellow:
        return 'Performance Warning';
      case AlertLevel.red:
        return 'Critical Performance Issue';
    }
  }
}
