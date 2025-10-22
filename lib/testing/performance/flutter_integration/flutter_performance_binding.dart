import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import '../models/performance_metrics.dart';

/// Flutter-specific performance testing integration
/// Provides bindings to Flutter's performance monitoring capabilities
class FlutterPerformanceBinding {
  static FlutterPerformanceBinding? _instance;
  static FlutterPerformanceBinding get instance =>
      _instance ??= FlutterPerformanceBinding._();

  FlutterPerformanceBinding._();

  final List<FrameTiming> _frameTimings = [];
  final List<double> _memorySnapshots = [];
  StreamSubscription<FrameTiming>? _frameTimingSubscription;
  Timer? _memoryMonitoringTimer;
  bool _isMonitoring = false;

  /// Start monitoring Flutter performance metrics
  Future<void> startMonitoring() async {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _frameTimings.clear();
    _memorySnapshots.clear();

    // Start frame timing monitoring
    await _startFrameTimingMonitoring();

    // Start memory monitoring
    _startMemoryMonitoring();

    if (kDebugMode) {
      print('Flutter performance monitoring started');
    }
  }

  /// Stop monitoring Flutter performance metrics
  Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;

    _isMonitoring = false;

    // Stop frame timing monitoring
    await _frameTimingSubscription?.cancel();
    _frameTimingSubscription = null;

    // Stop memory monitoring
    _memoryMonitoringTimer?.cancel();
    _memoryMonitoringTimer = null;

    if (kDebugMode) {
      print('Flutter performance monitoring stopped');
    }
  }

  /// Get current performance metrics
  Future<PerformanceMetrics> getCurrentMetrics() async {
    final frameRate = _calculateCurrentFrameRate();
    final frameSkips = _countFrameSkips();
    final memoryUsage = await _getCurrentMemoryUsage();

    return PerformanceMetrics.now(
      startupTimeMs: 0, // Will be measured separately
      frameSkips: frameSkips,
      memoryUsageMB: memoryUsage,
      apiResponseTimeMs: 0, // Will be measured separately
      frameRate: frameRate,
      batteryDrainPerHour: 0, // Will be measured separately
      deviceMetrics: await _getDeviceMetrics(),
    );
  }

  /// Measure widget build performance
  Future<double> measureWidgetBuildTime(
    WidgetTester tester,
    Widget widget,
  ) async {
    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    stopwatch.stop();
    return stopwatch.elapsedMilliseconds.toDouble();
  }

  /// Measure scrolling performance
  Future<Map<String, dynamic>> measureScrollingPerformance(
    WidgetTester tester,
    Finder scrollable, {
    int scrollCount = 10,
  }) async {
    final frameRatesBefore = List<double>.from(_getRecentFrameRates());

    // Perform scrolling
    for (int i = 0; i < scrollCount; i++) {
      await tester.drag(scrollable, const Offset(0, -100));
      await tester.pump();
    }

    await tester.pumpAndSettle();

    final frameRatesAfter = _getRecentFrameRates();
    final scrollingFrameRates = frameRatesAfter
        .skip(frameRatesBefore.length)
        .toList();

    return {
      'averageFrameRate': scrollingFrameRates.isNotEmpty
          ? scrollingFrameRates.reduce((a, b) => a + b) /
                scrollingFrameRates.length
          : 0.0,
      'minFrameRate': scrollingFrameRates.isNotEmpty
          ? scrollingFrameRates.reduce((a, b) => a < b ? a : b)
          : 0.0,
      'frameDrops': scrollingFrameRates.where((rate) => rate < 55.0).length,
      'scrollCount': scrollCount,
    };
  }

  /// Measure animation performance
  Future<Map<String, dynamic>> measureAnimationPerformance(
    WidgetTester tester,
    VoidCallback triggerAnimation,
    Duration animationDuration,
  ) async {
    final frameTimingsBefore = List<FrameTiming>.from(_frameTimings);

    // Trigger animation
    triggerAnimation();

    // Wait for animation to complete
    await tester.pump();
    await tester.pump(animationDuration);
    await tester.pumpAndSettle();

    final animationFrameTimings = _frameTimings
        .skip(frameTimingsBefore.length)
        .toList();

    return _analyzeFrameTimings(animationFrameTimings);
  }

  /// Count StatefulWidgets in the widget tree
  int countStatefulWidgets(WidgetTester tester) {
    int count = 0;

    void visitor(Element element) {
      if (element.widget is StatefulWidget) {
        count++;
      }
      element.visitChildren(visitor);
    }

    tester.binding.rootElement?.visitChildren(visitor);
    return count;
  }

  /// Detect potential memory leaks in StatefulWidgets
  Future<List<String>> detectStatefulWidgetLeaks(WidgetTester tester) async {
    final leaks = <String>[];

    // This is a simplified leak detection - in a real implementation,
    // we would track widget lifecycle and disposal
    void visitor(Element element) {
      if (element.widget is StatefulWidget) {
        final state = (element as StatefulElement).state;

        // Check if state has controllers that might not be disposed
        final stateString = state.toString();
        if (stateString.contains('Controller') &&
            !stateString.contains('disposed')) {
          leaks.add('Potential leak in ${element.widget.runtimeType}');
        }
      }
      element.visitChildren(visitor);
    }

    tester.binding.rootElement?.visitChildren(visitor);
    return leaks;
  }

  // Private helper methods

  Future<void> _startFrameTimingMonitoring() async {
    if (!kIsWeb) {
      // Frame timing is not available on web
      SchedulerBinding.instance.addTimingsCallback(_onFrameTiming);
    }
  }

  void _onFrameTiming(List<FrameTiming> timings) {
    _frameTimings.addAll(timings);

    // Keep only recent frame timings (last 1000 frames)
    if (_frameTimings.length > 1000) {
      _frameTimings.removeRange(0, _frameTimings.length - 1000);
    }
  }

  void _startMemoryMonitoring() {
    _memoryMonitoringTimer = Timer.periodic(const Duration(seconds: 1), (
      _,
    ) async {
      final memoryUsage = await _getCurrentMemoryUsage();
      _memorySnapshots.add(memoryUsage);

      // Keep only recent memory snapshots (last 300 seconds)
      if (_memorySnapshots.length > 300) {
        _memorySnapshots.removeAt(0);
      }
    });
  }

  double _calculateCurrentFrameRate() {
    if (_frameTimings.isEmpty) return 0.0;

    final recentTimings = _frameTimings.take(60).toList(); // Last 60 frames
    if (recentTimings.isEmpty) return 0.0;

    final totalDuration = recentTimings
        .map((timing) => timing.totalSpan.inMicroseconds)
        .reduce((a, b) => a + b);

    final averageFrameTime = totalDuration / recentTimings.length;
    return 1000000.0 / averageFrameTime; // Convert to FPS
  }

  int _countFrameSkips() {
    if (_frameTimings.isEmpty) return 0;

    const targetFrameTime = 16667; // 60 FPS in microseconds
    return _frameTimings
        .where(
          (timing) => timing.totalSpan.inMicroseconds > targetFrameTime * 1.5,
        )
        .length;
  }

  Future<double> _getCurrentMemoryUsage() async {
    try {
      // This is a simplified memory measurement
      // In a real implementation, we would use platform-specific methods
      return _memorySnapshots.isNotEmpty ? _memorySnapshots.last : 50.0;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting memory usage: $e');
      }
      return 0.0;
    }
  }

  List<double> _getRecentFrameRates() {
    const int sampleSize = 30;
    final recentTimings = _frameTimings.take(sampleSize).toList();

    return recentTimings.map((timing) {
      final frameTime = timing.totalSpan.inMicroseconds;
      return frameTime > 0 ? 1000000.0 / frameTime : 0.0;
    }).toList();
  }

  Map<String, dynamic> _analyzeFrameTimings(List<FrameTiming> timings) {
    if (timings.isEmpty) {
      return {
        'averageFrameTime': 0.0,
        'maxFrameTime': 0.0,
        'frameDrops': 0,
        'averageFrameRate': 0.0,
      };
    }

    final frameTimes = timings
        .map((timing) => timing.totalSpan.inMicroseconds.toDouble())
        .toList();

    final averageFrameTime =
        frameTimes.reduce((a, b) => a + b) / frameTimes.length;
    final maxFrameTime = frameTimes.reduce((a, b) => a > b ? a : b);
    final frameDrops = frameTimes
        .where((time) => time > 16667 * 1.5)
        .length; // > 1.5x target
    final averageFrameRate = 1000000.0 / averageFrameTime;

    return {
      'averageFrameTime': averageFrameTime / 1000, // Convert to milliseconds
      'maxFrameTime': maxFrameTime / 1000,
      'frameDrops': frameDrops,
      'averageFrameRate': averageFrameRate,
    };
  }

  Future<Map<String, dynamic>> _getDeviceMetrics() async {
    return {
      'platform': defaultTargetPlatform.name,
      'isDebugMode': kDebugMode,
      'isProfileMode': kProfileMode,
      'isReleaseMode': kReleaseMode,
    };
  }
}
