import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import '../models/test_results.dart';
import '../tests/startup_performance_test.dart';
import '../tests/booking_list_performance_test.dart';
import '../tests/payment_performance_test.dart';
import '../tests/memory_stability_test.dart';

/// Core performance testing suite for Champion Car Wash app
/// Provides structured testing methodologies for startup, memory, UI, and API performance
class PerformanceTestSuite {
  static const Duration _defaultTestTimeout = Duration(minutes: 5);

  /// Runs startup performance tests targeting < 2 seconds with 35+ StatefulWidgets
  /// Requirements: 1.1
  static Future<TestResults> runStartupTests({
    Duration timeout = _defaultTestTimeout,
  }) async {
    try {
      // Use specialized startup performance test
      final startupTest = StartupPerformanceTest();
      return await startupTest.execute();
    } catch (e) {
      return TestResults(
        testName: 'Champion Car Wash Startup Performance',
        passed: false,
        actualValue: -1,
        targetValue: 2000.0,
        unit: 'ms',
        timestamp: DateTime.now(),
        additionalMetrics: {
          'error': e.toString(),
          'testType': 'startup_performance',
        },
      );
    }
  }

  /// Runs memory stability tests for technician workflows over 30+ minutes
  /// Requirements: 1.4
  static Future<TestResults> runMemoryTests({
    Duration testDuration = const Duration(minutes: 30),
  }) async {
    try {
      // Use specialized memory stability test
      if (testDuration == const Duration(minutes: 30)) {
        final memoryTest = MemoryStabilityTest();
        return await memoryTest.execute();
      } else {
        // Use quick test for custom durations
        return await MemoryStabilityTest.runQuickTest(duration: testDuration);
      }
    } catch (e) {
      return TestResults(
        testName: 'Champion Car Wash Memory Stability',
        passed: false,
        actualValue: -1,
        targetValue: 120.0,
        unit: 'MB',
        timestamp: DateTime.now(),
        additionalMetrics: {
          'error': e.toString(),
          'testType': 'memory_stability',
        },
      );
    }
  }

  /// Runs UI performance tests for booking list scrolling at 60fps with 100+ items
  /// Requirements: 1.2
  static Future<TestResults> runUIPerformanceTests() async {
    try {
      // Use specialized booking list performance test
      final bookingListTest = BookingListPerformanceTest();
      return await bookingListTest.execute();
    } catch (e) {
      return TestResults(
        testName: 'Champion Car Wash UI Performance',
        passed: false,
        actualValue: -1,
        targetValue: 60.0,
        unit: 'fps',
        timestamp: DateTime.now(),
        additionalMetrics: {
          'error': e.toString(),
          'testType': 'ui_performance',
        },
      );
    }
  }

  /// Runs API performance tests for payment processing and response handling
  /// Requirements: 1.3, 1.5
  static Future<TestResults> runAPITests() async {
    try {
      // Use specialized payment performance test for API testing
      final paymentTest = PaymentPerformanceTest();
      return await paymentTest.execute();
    } catch (e) {
      return TestResults(
        testName: 'Champion Car Wash API Performance',
        passed: false,
        actualValue: -1,
        targetValue: 5000.0,
        unit: 'ms',
        timestamp: DateTime.now(),
        additionalMetrics: {
          'error': e.toString(),
          'testType': 'api_performance',
        },
      );
    }
  }

  /// Calculates overall performance score from 1-10 based on all test results
  /// Requirements: 2.4
  static Future<OverallScore> calculatePerformanceScore(
    List<TestResults> testResults,
  ) async {
    if (testResults.isEmpty) {
      return OverallScore(
        score: 0.0,
        grade: 'F',
        timestamp: DateTime.now(),
        breakdown: {},
      );
    }

    double totalScore = 0.0;
    final Map<String, double> breakdown = {};

    for (final result in testResults) {
      double testScore = result.passed ? 10.0 : 0.0;

      // Calculate weighted score based on performance metrics
      if (result.passed && result.actualValue > 0) {
        final ratio = result.targetValue / result.actualValue;
        testScore = (ratio * 10.0).clamp(0.0, 10.0);
      }

      breakdown[result.testName] = testScore;
      totalScore += testScore;
    }

    final averageScore = totalScore / testResults.length;
    final grade = _calculateGrade(averageScore);

    return OverallScore(
      score: averageScore,
      grade: grade,
      timestamp: DateTime.now(),
      breakdown: breakdown,
    );
  }

  // Helper methods for performance testing suite

  /// Runs all Champion Car Wash performance tests in sequence
  static Future<List<TestResults>> runAllTests({
    Duration memoryTestDuration = const Duration(minutes: 30),
  }) async {
    final results = <TestResults>[];

    if (kDebugMode) {
      print('Running complete Champion Car Wash performance test suite...');
    }

    // Run startup performance test
    try {
      final startupResult = await runStartupTests();
      results.add(startupResult);
      if (kDebugMode) {
        print('Startup test: ${startupResult.passed ? 'PASSED' : 'FAILED'}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Startup test failed with error: $e');
      }
    }

    // Run UI performance test (booking list)
    try {
      final uiResult = await runUIPerformanceTests();
      results.add(uiResult);
      if (kDebugMode) {
        print('UI performance test: ${uiResult.passed ? 'PASSED' : 'FAILED'}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('UI performance test failed with error: $e');
      }
    }

    // Run API performance test (payment processing)
    try {
      final apiResult = await runAPITests();
      results.add(apiResult);
      if (kDebugMode) {
        print(
          'API performance test: ${apiResult.passed ? 'PASSED' : 'FAILED'}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('API performance test failed with error: $e');
      }
    }

    // Run memory stability test
    try {
      final memoryResult = await runMemoryTests(
        testDuration: memoryTestDuration,
      );
      results.add(memoryResult);
      if (kDebugMode) {
        print(
          'Memory stability test: ${memoryResult.passed ? 'PASSED' : 'FAILED'}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Memory stability test failed with error: $e');
      }
    }

    return results;
  }

  static String _calculateGrade(double score) {
    if (score >= 9.0) return 'A+';
    if (score >= 8.0) return 'A';
    if (score >= 7.0) return 'B+';
    if (score >= 6.0) return 'B';
    if (score >= 5.0) return 'C+';
    if (score >= 4.0) return 'C';
    if (score >= 3.0) return 'D';
    return 'F';
  }
}

/// Overall performance score result
class OverallScore {
  final double score;
  final String grade;
  final DateTime timestamp;
  final Map<String, double> breakdown;

  const OverallScore({
    required this.score,
    required this.grade,
    required this.timestamp,
    required this.breakdown,
  });

  @override
  String toString() {
    return 'Performance Score: $score/10 (Grade: $grade)';
  }
}
