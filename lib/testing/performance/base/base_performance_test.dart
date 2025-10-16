import 'dart:async';
import 'package:flutter/foundation.dart';
import '../interfaces/performance_test_interface.dart';
import '../models/test_results.dart';

/// Base class for all performance tests providing common functionality
abstract class BasePerformanceTest implements PerformanceTestInterface {
  final Completer<void> _setupCompleter = Completer<void>();
  final Completer<void> _teardownCompleter = Completer<void>();
  bool _isSetUp = false;
  bool _isTornDown = false;
  
  /// Default timeout for performance tests
  static const Duration defaultTimeout = Duration(minutes: 5);
  
  @override
  Future<TestResults> execute() async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Ensure setup is completed
      await setUp();
      
      // Execute the actual test
      final result = await executeTest();
      
      // Ensure teardown is completed
      await tearDown();
      
      stopwatch.stop();
      
      // Add execution time to additional metrics
      final updatedMetrics = Map<String, dynamic>.from(result.additionalMetrics);
      updatedMetrics['executionTimeMs'] = stopwatch.elapsedMilliseconds;
      
      return TestResults(
        testName: result.testName,
        passed: result.passed,
        actualValue: result.actualValue,
        targetValue: result.targetValue,
        unit: result.unit,
        timestamp: result.timestamp,
        additionalMetrics: updatedMetrics,
      );
    } catch (e, stackTrace) {
      stopwatch.stop();
      
      // Log error for debugging
      if (kDebugMode) {
        print('Performance test error in $testName: $e');
        print('Stack trace: $stackTrace');
      }
      
      return TestResults(
        testName: testName,
        passed: false,
        actualValue: -1,
        targetValue: targetThreshold,
        unit: unit,
        timestamp: DateTime.now(),
        additionalMetrics: {
          'error': e.toString(),
          'stackTrace': stackTrace.toString(),
          'executionTimeMs': stopwatch.elapsedMilliseconds,
        },
      );
    }
  }
  
  /// Abstract method for actual test implementation
  Future<TestResults> executeTest();
  
  @override
  Future<void> setUp() async {
    if (_isSetUp) return;
    
    try {
      await performSetUp();
      _isSetUp = true;
      _setupCompleter.complete();
    } catch (e) {
      _setupCompleter.completeError(e);
      rethrow;
    }
  }
  
  @override
  Future<void> tearDown() async {
    if (_isTornDown) return;
    
    try {
      await performTearDown();
      _isTornDown = true;
      _teardownCompleter.complete();
    } catch (e) {
      _teardownCompleter.completeError(e);
      rethrow;
    }
  }
  
  /// Override this method to implement custom setup logic
  Future<void> performSetUp() async {}
  
  /// Override this method to implement custom teardown logic
  Future<void> performTearDown() async {}
  
  @override
  bool validateResults(TestResults results) {
    // Basic validation - can be overridden for specific requirements
    return results.passed && results.actualValue >= 0;
  }
  
  /// Helper method to create a test result
  TestResults createResult({
    required bool passed,
    required double actualValue,
    Map<String, dynamic> additionalMetrics = const {},
  }) {
    return TestResults(
      testName: testName,
      passed: passed,
      actualValue: actualValue,
      targetValue: targetThreshold,
      unit: unit,
      timestamp: DateTime.now(),
      additionalMetrics: additionalMetrics,
    );
  }
  
  /// Helper method to measure execution time of a function
  Future<T> measureExecutionTime<T>(
    Future<T> Function() function,
    String operationName,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await function();
      stopwatch.stop();
      
      if (kDebugMode) {
        print('$operationName completed in ${stopwatch.elapsedMilliseconds}ms');
      }
      
      return result;
    } catch (e) {
      stopwatch.stop();
      
      if (kDebugMode) {
        print('$operationName failed after ${stopwatch.elapsedMilliseconds}ms: $e');
      }
      
      rethrow;
    }
  }
  
  /// Helper method to wait for a condition with timeout
  Future<bool> waitForCondition(
    bool Function() condition,
    Duration timeout, {
    Duration checkInterval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < timeout) {
      if (condition()) {
        return true;
      }
      
      await Future.delayed(checkInterval);
    }
    
    return false;
  }
  
  /// Helper method to retry an operation with exponential backoff
  Future<T> retryOperation<T>(
    Future<T> Function() operation,
    int maxRetries, {
    Duration initialDelay = const Duration(milliseconds: 100),
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;
    
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        
        if (attempts >= maxRetries) {
          rethrow;
        }
        
        if (kDebugMode) {
          print('Operation failed (attempt $attempts/$maxRetries), retrying in ${delay.inMilliseconds}ms: $e');
        }
        
        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
      }
    }
    
    throw Exception('Operation failed after $maxRetries attempts');
  }
  
  /// Helper method to collect performance samples over time
  Future<List<T>> collectSamples<T>(
    Future<T> Function() sampler,
    Duration duration, {
    Duration interval = const Duration(seconds: 1),
  }) async {
    final samples = <T>[];
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < duration) {
      try {
        final sample = await sampler();
        samples.add(sample);
      } catch (e) {
        if (kDebugMode) {
          print('Sample collection error: $e');
        }
      }
      
      await Future.delayed(interval);
    }
    
    return samples;
  }
  
  /// Helper method to calculate statistics from numeric samples
  Map<String, double> calculateStatistics(List<double> samples) {
    if (samples.isEmpty) {
      return {
        'count': 0,
        'min': 0,
        'max': 0,
        'average': 0,
        'median': 0,
        'standardDeviation': 0,
      };
    }
    
    final sortedSamples = List<double>.from(samples)..sort();
    final count = samples.length;
    final sum = samples.reduce((a, b) => a + b);
    final average = sum / count;
    
    final median = count % 2 == 0
        ? (sortedSamples[count ~/ 2 - 1] + sortedSamples[count ~/ 2]) / 2
        : sortedSamples[count ~/ 2];
    
    final variance = samples
        .map((x) => (x - average) * (x - average))
        .reduce((a, b) => a + b) / count;
    final standardDeviation = variance > 0 ? variance.toDouble() : 0.0;
    
    return {
      'count': count.toDouble(),
      'min': sortedSamples.first,
      'max': sortedSamples.last,
      'average': average,
      'median': median,
      'standardDeviation': standardDeviation,
    };
  }
}