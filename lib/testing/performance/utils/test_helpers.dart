import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../models/test_results.dart';
import '../models/performance_metrics.dart';

/// Utility functions for performance testing
class PerformanceTestHelpers {
  /// Generate mock booking data for performance testing
  static List<Map<String, dynamic>> generateMockBookings(int count) {
    final random = Random();
    final bookingTypes = ['Car Wash', 'Oil Change', 'Full Service'];
    final statuses = ['Pending', 'In Progress', 'Completed'];
    final customerNames = ['Ahmed Al-Rashid', 'Fatima Hassan', 'Mohammed Ali', 'Sarah Abdullah'];
    
    return List.generate(count, (index) {
      return {
        'id': 'booking_${index + 1}',
        'customerName': customerNames[random.nextInt(customerNames.length)],
        'serviceType': bookingTypes[random.nextInt(bookingTypes.length)],
        'status': statuses[random.nextInt(statuses.length)],
        'scheduledTime': DateTime.now().add(Duration(hours: random.nextInt(24))),
        'estimatedDuration': Duration(minutes: 30 + random.nextInt(90)),
        'price': 50.0 + random.nextDouble() * 200.0,
        'vehicleInfo': {
          'make': 'Toyota',
          'model': 'Camry',
          'year': 2018 + random.nextInt(5),
          'plateNumber': 'UAE-${random.nextInt(9999)}',
        },
        'technicianId': 'tech_${random.nextInt(10) + 1}',
        'notes': 'Test booking for performance testing',
      };
    });
  }
  
  /// Generate mock payment data for testing
  static List<Map<String, dynamic>> generateMockPayments(int count) {
    final random = Random();
    final paymentMethods = ['NFC', 'Card', 'Cash', 'Digital Wallet'];
    
    return List.generate(count, (index) {
      return {
        'id': 'payment_${index + 1}',
        'bookingId': 'booking_${index + 1}',
        'amount': 50.0 + random.nextDouble() * 300.0,
        'method': paymentMethods[random.nextInt(paymentMethods.length)],
        'timestamp': DateTime.now().subtract(Duration(days: random.nextInt(30))),
        'status': random.nextBool() ? 'Completed' : 'Pending',
        'transactionId': 'txn_${random.nextInt(999999)}',
      };
    });
  }
  
  /// Simulate network delay for API testing
  static Future<void> simulateNetworkDelay({
    Duration min = const Duration(milliseconds: 100),
    Duration max = const Duration(milliseconds: 500),
  }) async {
    final random = Random();
    final delayMs = min.inMilliseconds + 
                   random.nextInt(max.inMilliseconds - min.inMilliseconds);
    await Future.delayed(Duration(milliseconds: delayMs));
  }
  
  /// Simulate memory-intensive operation
  static Future<void> simulateMemoryIntensiveOperation({
    int iterations = 1000,
    Duration delay = const Duration(microseconds: 100),
  }) async {
    final data = <List<int>>[];
    
    for (int i = 0; i < iterations; i++) {
      // Create some memory pressure
      data.add(List.generate(100, (index) => index));
      
      if (i % 100 == 0) {
        await Future.delayed(delay);
      }
    }
    
    // Clean up
    data.clear();
  }
  
  /// Wait for widget to be ready for testing
  static Future<void> waitForWidgetReady(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await tester.pumpAndSettle(timeout);
  }
  
  /// Pump frames for a specific duration
  static Future<void> pumpFramesForDuration(
    WidgetTester tester,
    Duration duration, {
    Duration frameInterval = const Duration(milliseconds: 16),
  }) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < duration) {
      await tester.pump(frameInterval);
    }
  }
  
  /// Create a test results summary from multiple results
  static Map<String, dynamic> createTestSummary(List<TestResults> results) {
    if (results.isEmpty) {
      return {
        'totalTests': 0,
        'passedTests': 0,
        'failedTests': 0,
        'passRate': 0.0,
        'averageScore': 0.0,
        'executionTime': 0,
      };
    }
    
    final passedTests = results.where((r) => r.passed).length;
    final failedTests = results.length - passedTests;
    final passRate = (passedTests / results.length) * 100;
    
    // Calculate average improvement percentage
    final improvements = results
        .where((r) => r.showsImprovement)
        .map((r) => r.improvementPercentage)
        .toList();
    
    final averageImprovement = improvements.isNotEmpty
        ? improvements.reduce((a, b) => a + b) / improvements.length
        : 0.0;
    
    // Calculate total execution time
    final totalExecutionTime = results
        .map((r) => r.additionalMetrics['executionTimeMs'] as int? ?? 0)
        .reduce((a, b) => a + b);
    
    return {
      'totalTests': results.length,
      'passedTests': passedTests,
      'failedTests': failedTests,
      'passRate': passRate,
      'averageImprovement': averageImprovement,
      'executionTime': totalExecutionTime,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  /// Validate Champion Car Wash specific performance requirements
  static bool validateChampionCarWashRequirements(PerformanceMetrics metrics) {
    return metrics.meetsStartupRequirement &&
           metrics.meetsFrameRateRequirement &&
           metrics.meetsMemoryRequirement &&
           metrics.meetsAPIRequirement;
  }
  
  /// Generate performance report
  static String generatePerformanceReport(
    List<TestResults> results,
    PerformanceMetrics? metrics,
  ) {
    final summary = createTestSummary(results);
    final buffer = StringBuffer();
    
    buffer.writeln('=== Champion Car Wash Performance Test Report ===');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln();
    
    // Test Summary
    buffer.writeln('Test Summary:');
    buffer.writeln('  Total Tests: ${summary['totalTests']}');
    buffer.writeln('  Passed: ${summary['passedTests']}');
    buffer.writeln('  Failed: ${summary['failedTests']}');
    buffer.writeln('  Pass Rate: ${summary['passRate'].toStringAsFixed(1)}%');
    buffer.writeln('  Execution Time: ${summary['executionTime']}ms');
    buffer.writeln();
    
    // Individual Test Results
    buffer.writeln('Individual Test Results:');
    for (final result in results) {
      final status = result.passed ? 'PASS' : 'FAIL';
      buffer.writeln('  [$status] ${result.testName}');
      buffer.writeln('    Actual: ${result.actualValue}${result.unit}');
      buffer.writeln('    Target: ${result.targetValue}${result.unit}');
      
      if (result.showsImprovement) {
        buffer.writeln('    Improvement: +${result.improvementPercentage.toStringAsFixed(1)}%');
      }
      
      if (!result.passed && result.additionalMetrics.containsKey('error')) {
        buffer.writeln('    Error: ${result.additionalMetrics['error']}');
      }
      
      buffer.writeln();
    }
    
    // Performance Metrics
    if (metrics != null) {
      buffer.writeln('Current Performance Metrics:');
      buffer.writeln('  Startup Time: ${metrics.startupTimeMs}ms');
      buffer.writeln('  Frame Rate: ${metrics.frameRate.toStringAsFixed(1)} fps');
      buffer.writeln('  Memory Usage: ${metrics.memoryUsageMB.toStringAsFixed(1)} MB');
      buffer.writeln('  API Response Time: ${metrics.apiResponseTimeMs}ms');
      buffer.writeln('  Performance Score: ${metrics.performanceScore.toStringAsFixed(1)}/10');
      buffer.writeln('  Health Status: ${metrics.healthStatus.description}');
      buffer.writeln();
    }
    
    // Recommendations
    buffer.writeln('Recommendations:');
    final failedTests = results.where((r) => !r.passed).toList();
    
    if (failedTests.isEmpty) {
      buffer.writeln('  ✅ All tests passed! Performance is optimal.');
    } else {
      for (final failed in failedTests) {
        buffer.writeln('  ❌ ${failed.testName}: ${_getRecommendation(failed)}');
      }
    }
    
    return buffer.toString();
  }
  
  /// Get performance improvement recommendation
  static String _getRecommendation(TestResults result) {
    switch (result.testName) {
      case 'Startup Performance Test':
        return 'Consider reducing StatefulWidget count or optimizing initialization';
      case 'Memory Stability Test':
        return 'Check for memory leaks and ensure proper disposal of controllers';
      case 'UI Performance Test':
        return 'Optimize list rendering and reduce unnecessary rebuilds';
      case 'API Performance Test':
        return 'Implement caching and optimize network requests';
      default:
        return 'Review test-specific optimizations';
    }
  }
  
  /// Create mock device specifications for testing
  static Map<String, dynamic> createMockDeviceSpecs({
    String processor = 'MediaTek Helio G85',
    int ramGB = 4,
    String androidVersion = '11',
    double screenSize = 6.1,
  }) {
    return {
      'processor': processor,
      'ramGB': ramGB,
      'androidVersion': androidVersion,
      'screenSize': screenSize,
      'isLowEndDevice': ramGB <= 2 || processor.contains('MediaTek'),
      'isHighEndDevice': ramGB >= 8 && processor.contains('Snapdragon 8'),
    };
  }
  
  /// Benchmark function execution time
  static Future<double> benchmarkFunction(Future<void> Function() function) async {
    final stopwatch = Stopwatch()..start();
    await function();
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds.toDouble();
  }
  
  /// Log performance test information
  static void logPerformanceInfo(String message) {
    if (kDebugMode) {
      print('[PERFORMANCE TEST] $message');
    }
  }
}