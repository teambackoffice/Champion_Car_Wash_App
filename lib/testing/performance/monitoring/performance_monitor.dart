import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/performance_metrics.dart';

/// Real-time performance monitoring system for Champion Car Wash app
class PerformanceMonitor {
  static PerformanceMonitor? _instance;
  static PerformanceMonitor get instance => _instance ??= PerformanceMonitor._();
  
  PerformanceMonitor._();
  
  // Monitoring state
  bool _isMonitoring = false;
  Timer? _monitoringTimer;
  final StreamController<PerformanceMetrics> _metricsController = 
      StreamController<PerformanceMetrics>.broadcast();
  final StreamController<AlertEvent> _alertController = 
      StreamController<AlertEvent>.broadcast();
  
  // Performance tracking variables
  DateTime? _appStartTime;
  final List<double> _frameRates = [];
  final List<double> _memoryUsages = [];
  final List<double> _apiResponseTimes = [];
  int _frameSkipCount = 0;
  double _batteryLevel = 100.0;
  DateTime? _batteryTrackingStart;
  
  // Alert thresholds
  AlertThresholds _thresholds = AlertThresholds.championCarWashDefaults();
  
  /// Stream of real-time performance metrics
  Stream<PerformanceMetrics> get metricsStream => _metricsController.stream;
  
  /// Stream of performance alerts
  Stream<AlertEvent> get alertStream => _alertController.stream;
  
  /// Whether monitoring is currently active
  bool get isMonitoring => _isMonitoring;
  
  /// Current alert thresholds
  AlertThresholds get thresholds => _thresholds;
  
  /// Start real-time performance monitoring
  void startMonitoring({Duration interval = const Duration(seconds: 1)}) {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _appStartTime ??= DateTime.now();
    _batteryTrackingStart ??= DateTime.now();
    
    developer.log('PerformanceMonitor: Starting monitoring with ${interval.inSeconds}s interval');
    
    // Start periodic metric collection
    _monitoringTimer = Timer.periodic(interval, (_) => _collectMetrics());
    
    // Initialize frame rate monitoring
    _initializeFrameRateMonitoring();
    
    // Initialize memory monitoring
    _initializeMemoryMonitoring();
  }
  
  /// Stop performance monitoring
  void stopMonitoring() {
    if (!_isMonitoring) return;
    
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    
    developer.log('PerformanceMonitor: Stopped monitoring');
  }
  
  /// Get current performance metrics snapshot
  PerformanceMetrics getCurrentMetrics() {
    final now = DateTime.now();
    final startupTime = _appStartTime != null 
        ? now.difference(_appStartTime!).inMilliseconds.toDouble()
        : 0.0;
    
    final avgFrameRate = _frameRates.isNotEmpty 
        ? _frameRates.reduce((a, b) => a + b) / _frameRates.length
        : 60.0;
    
    final avgMemoryUsage = _memoryUsages.isNotEmpty
        ? _memoryUsages.reduce((a, b) => a + b) / _memoryUsages.length
        : 0.0;
    
    final avgApiResponseTime = _apiResponseTimes.isNotEmpty
        ? _apiResponseTimes.reduce((a, b) => a + b) / _apiResponseTimes.length
        : 0.0;
    
    final batteryDrain = _calculateBatteryDrainPerHour();
    
    return PerformanceMetrics.now(
      startupTimeMs: startupTime,
      frameSkips: _frameSkipCount,
      memoryUsageMB: avgMemoryUsage,
      apiResponseTimeMs: avgApiResponseTime,
      frameRate: avgFrameRate,
      batteryDrainPerHour: batteryDrain,
      deviceMetrics: _getDeviceMetrics(),
    );
  }
  
  /// Set custom alert thresholds
  void setAlertThresholds(AlertThresholds thresholds) {
    _thresholds = thresholds;
    developer.log('PerformanceMonitor: Updated alert thresholds');
  }
  
  /// Record API response time for monitoring
  void recordApiResponseTime(double responseTimeMs) {
    _apiResponseTimes.add(responseTimeMs);
    
    // Keep only last 100 measurements
    if (_apiResponseTimes.length > 100) {
      _apiResponseTimes.removeAt(0);
    }
    
    // Check for API performance alerts
    _checkApiAlert(responseTimeMs);
  }
  
  /// Record frame skip event
  void recordFrameSkip() {
    _frameSkipCount++;
    
    // Check for frame rate alerts
    if (_frameSkipCount > _thresholds.maxFrameSkips) {
      _triggerAlert(AlertEvent(
        level: AlertLevel.RED,
        metric: 'Frame Skips',
        currentValue: _frameSkipCount.toDouble(),
        threshold: _thresholds.maxFrameSkips.toDouble(),
        message: 'Excessive frame skips detected: $_frameSkipCount',
        timestamp: DateTime.now(),
      ));
    }
  }
  
  /// Update battery level for drain calculation
  void updateBatteryLevel(double level) {
    _batteryLevel = level;
  }
  
  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _metricsController.close();
    _alertController.close();
  }
  
  // Private methods
  
  void _collectMetrics() {
    if (!_isMonitoring) return;
    
    try {
      final metrics = getCurrentMetrics();
      _metricsController.add(metrics);
      
      // Check all alert conditions
      _checkAllAlerts(metrics);
      
    } catch (e) {
      developer.log('PerformanceMonitor: Error collecting metrics: $e');
    }
  }
  
  void _initializeFrameRateMonitoring() {
    // Use Flutter's frame callback to monitor frame rate
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      if (!_isMonitoring) return;
      
      // Calculate frame rate based on frame timing
      final frameRate = _calculateCurrentFrameRate();
      _frameRates.add(frameRate);
      
      // Keep only last 60 measurements (1 minute at 1fps)
      if (_frameRates.length > 60) {
        _frameRates.removeAt(0);
      }
      
      // Check for low frame rate
      if (frameRate < _thresholds.minFrameRate) {
        _triggerAlert(AlertEvent(
          level: AlertLevel.YELLOW,
          metric: 'Frame Rate',
          currentValue: frameRate,
          threshold: _thresholds.minFrameRate,
          message: 'Low frame rate detected: ${frameRate.toStringAsFixed(1)} fps',
          timestamp: DateTime.now(),
        ));
      }
    });
  }
  
  void _initializeMemoryMonitoring() {
    // Monitor memory usage periodically
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }
      
      final memoryUsage = _getCurrentMemoryUsage();
      _memoryUsages.add(memoryUsage);
      
      // Keep only last 60 measurements (5 minutes)
      if (_memoryUsages.length > 60) {
        _memoryUsages.removeAt(0);
      }
    });
  }
  
  double _calculateCurrentFrameRate() {
    // Simplified frame rate calculation
    // In a real implementation, this would use more sophisticated timing
    return 60.0; // Placeholder - would be calculated from actual frame timing
  }
  
  double _getCurrentMemoryUsage() {
    // Get current memory usage in MB
    // This is a simplified implementation
    try {
      // In a real implementation, this would use platform-specific memory APIs
      return 80.0; // Placeholder value
    } catch (e) {
      developer.log('PerformanceMonitor: Error getting memory usage: $e');
      return 0.0;
    }
  }
  
  double _calculateBatteryDrainPerHour() {
    if (_batteryTrackingStart == null) return 0.0;
    
    final elapsed = DateTime.now().difference(_batteryTrackingStart!);
    if (elapsed.inMinutes < 1) return 0.0;
    
    final drainPercentage = 100.0 - _batteryLevel;
    final hoursElapsed = elapsed.inMilliseconds / (1000 * 60 * 60);
    
    return drainPercentage / hoursElapsed;
  }
  
  Map<String, dynamic> _getDeviceMetrics() {
    return {
      'platform': Platform.operatingSystem,
      'isDebugMode': kDebugMode,
      'monitoringDuration': _appStartTime != null 
          ? DateTime.now().difference(_appStartTime!).inSeconds
          : 0,
    };
  }
  
  void _checkAllAlerts(PerformanceMetrics metrics) {
    // Check startup time alert
    if (metrics.startupTimeMs > _thresholds.maxStartupTimeMs) {
      _triggerAlert(AlertEvent(
        level: AlertLevel.RED,
        metric: 'Startup Time',
        currentValue: metrics.startupTimeMs,
        threshold: _thresholds.maxStartupTimeMs,
        message: 'Slow startup detected: ${metrics.startupTimeMs.toStringAsFixed(0)}ms',
        timestamp: DateTime.now(),
      ));
    }
    
    // Check memory usage alert
    if (metrics.memoryUsageMB > _thresholds.maxMemoryUsageMB) {
      _triggerAlert(AlertEvent(
        level: AlertLevel.YELLOW,
        metric: 'Memory Usage',
        currentValue: metrics.memoryUsageMB,
        threshold: _thresholds.maxMemoryUsageMB,
        message: 'High memory usage: ${metrics.memoryUsageMB.toStringAsFixed(1)}MB',
        timestamp: DateTime.now(),
      ));
    }
    
    // Check battery drain alert
    if (metrics.batteryDrainPerHour > _thresholds.maxBatteryDrainPerHour) {
      _triggerAlert(AlertEvent(
        level: AlertLevel.YELLOW,
        metric: 'Battery Drain',
        currentValue: metrics.batteryDrainPerHour,
        threshold: _thresholds.maxBatteryDrainPerHour,
        message: 'High battery drain: ${metrics.batteryDrainPerHour.toStringAsFixed(1)}%/hour',
        timestamp: DateTime.now(),
      ));
    }
  }
  
  void _checkApiAlert(double responseTime) {
    if (responseTime > _thresholds.maxApiResponseTimeMs) {
      _triggerAlert(AlertEvent(
        level: AlertLevel.YELLOW,
        metric: 'API Response Time',
        currentValue: responseTime,
        threshold: _thresholds.maxApiResponseTimeMs,
        message: 'Slow API response: ${responseTime.toStringAsFixed(0)}ms',
        timestamp: DateTime.now(),
      ));
    }
  }
  
  void _triggerAlert(AlertEvent alert) {
    _alertController.add(alert);
    developer.log('PerformanceMonitor Alert [${alert.level}]: ${alert.message}');
  }
}

/// Alert event for performance monitoring
class AlertEvent {
  final AlertLevel level;
  final String metric;
  final double currentValue;
  final double threshold;
  final String message;
  final DateTime timestamp;
  
  const AlertEvent({
    required this.level,
    required this.metric,
    required this.currentValue,
    required this.threshold,
    required this.message,
    required this.timestamp,
  });
  
  @override
  String toString() {
    return 'AlertEvent(${level.name}: $message)';
  }
}

/// Alert level enumeration
enum AlertLevel {
  RED,    // Critical performance issue
  YELLOW, // Performance warning
  GREEN;  // Performance is good
  
  String get description {
    switch (this) {
      case AlertLevel.RED:
        return 'Critical - Immediate action required';
      case AlertLevel.YELLOW:
        return 'Warning - Monitor closely';
      case AlertLevel.GREEN:
        return 'Good - Performance is optimal';
    }
  }
}

/// Configurable alert thresholds
class AlertThresholds {
  final double maxStartupTimeMs;
  final double minFrameRate;
  final int maxFrameSkips;
  final double maxMemoryUsageMB;
  final double maxApiResponseTimeMs;
  final double maxBatteryDrainPerHour;
  
  const AlertThresholds({
    required this.maxStartupTimeMs,
    required this.minFrameRate,
    required this.maxFrameSkips,
    required this.maxMemoryUsageMB,
    required this.maxApiResponseTimeMs,
    required this.maxBatteryDrainPerHour,
  });
  
  /// Default thresholds optimized for Champion Car Wash app
  factory AlertThresholds.championCarWashDefaults() {
    return const AlertThresholds(
      maxStartupTimeMs: 2000,    // 2 seconds max startup
      minFrameRate: 55.0,        // Minimum 55 fps (close to 60)
      maxFrameSkips: 10,         // Max 10 frame skips per monitoring period
      maxMemoryUsageMB: 120.0,   // Max 120MB memory usage
      maxApiResponseTimeMs: 1000, // Max 1 second API response
      maxBatteryDrainPerHour: 15.0, // Max 15% battery drain per hour
    );
  }
  
  /// Strict thresholds for high-end devices
  factory AlertThresholds.strict() {
    return const AlertThresholds(
      maxStartupTimeMs: 1000,    // 1 second max startup
      minFrameRate: 58.0,        // Minimum 58 fps
      maxFrameSkips: 5,          // Max 5 frame skips
      maxMemoryUsageMB: 80.0,    // Max 80MB memory usage
      maxApiResponseTimeMs: 500, // Max 500ms API response
      maxBatteryDrainPerHour: 10.0, // Max 10% battery drain per hour
    );
  }
  
  /// Relaxed thresholds for low-end devices
  factory AlertThresholds.relaxed() {
    return const AlertThresholds(
      maxStartupTimeMs: 3000,    // 3 seconds max startup
      minFrameRate: 45.0,        // Minimum 45 fps
      maxFrameSkips: 20,         // Max 20 frame skips
      maxMemoryUsageMB: 150.0,   // Max 150MB memory usage
      maxApiResponseTimeMs: 2000, // Max 2 seconds API response
      maxBatteryDrainPerHour: 20.0, // Max 20% battery drain per hour
    );
  }
}