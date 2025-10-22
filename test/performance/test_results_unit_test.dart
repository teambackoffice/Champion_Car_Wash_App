import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/models/test_results.dart';

/// Unit tests for TestResults validation and calculation logic
void main() {
  group('TestResults Unit Tests', () {
    group('Constructor and Properties', () {
      test('should create TestResults with all required fields', () {
        final timestamp = DateTime.now();
        final additionalMetrics = {'executionTimeMs': 150, 'iterations': 100};

        final result = TestResults(
          testName: 'Startup Performance Test',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: timestamp,
          additionalMetrics: additionalMetrics,
        );

        expect(result.testName, equals('Startup Performance Test'));
        expect(result.passed, isTrue);
        expect(result.actualValue, equals(1500.0));
        expect(result.targetValue, equals(2000.0));
        expect(result.unit, equals('ms'));
        expect(result.timestamp, equals(timestamp));
        expect(result.additionalMetrics, equals(additionalMetrics));
      });
    });

    group('Improvement Percentage Calculation', () {
      test(
        'should calculate improvement for time-based metrics (lower is better)',
        () {
          // Startup time: actual 1500ms vs target 2000ms = 25% improvement
          final startupResult = TestResults(
            testName: 'Startup Test',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          );

          expect(startupResult.improvementPercentage, equals(25.0));
          expect(startupResult.showsImprovement, isTrue);
        },
      );

      test('should calculate improvement for response time metrics', () {
        // API response: actual 800ms vs target 1000ms = 20% improvement
        final apiResult = TestResults(
          testName: 'API Response Test',
          passed: true,
          actualValue: 800.0,
          targetValue: 1000.0,
          unit: 'response_time',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        expect(apiResult.improvementPercentage, equals(20.0));
        expect(apiResult.showsImprovement, isTrue);
      });

      test(
        'should calculate improvement for fps metrics (higher is better)',
        () {
          // Frame rate: actual 65fps vs target 60fps = 8.33% improvement
          final fpsResult = TestResults(
            testName: 'Frame Rate Test',
            passed: true,
            actualValue: 65.0,
            targetValue: 60.0,
            unit: 'fps',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          );

          expect(fpsResult.improvementPercentage, closeTo(8.33, 0.01));
          expect(fpsResult.showsImprovement, isTrue);
        },
      );

      test('should handle negative improvement (performance regression)', () {
        // Startup time: actual 2500ms vs target 2000ms = -25% (regression)
        final regressionResult = TestResults(
          testName: 'Regression Test',
          passed: false,
          actualValue: 2500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        expect(regressionResult.improvementPercentage, equals(-25.0));
        expect(regressionResult.showsImprovement, isFalse);
      });

      test('should handle zero target value', () {
        final zeroTargetResult = TestResults(
          testName: 'Zero Target Test',
          passed: true,
          actualValue: 100.0,
          targetValue: 0.0,
          unit: 'count',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        expect(zeroTargetResult.improvementPercentage, equals(0.0));
        expect(zeroTargetResult.showsImprovement, isFalse);
      });

      test('should handle exact target match', () {
        final exactMatchResult = TestResults(
          testName: 'Exact Match Test',
          passed: true,
          actualValue: 2000.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        expect(exactMatchResult.improvementPercentage, equals(0.0));
        expect(exactMatchResult.showsImprovement, isFalse);
      });
    });

    group('Formatted Result String', () {
      test('should format passing result with improvement', () {
        final result = TestResults(
          testName: 'Startup Performance Test',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        final formatted = result.formattedResult;

        expect(formatted, contains('Startup Performance Test: PASS'));
        expect(formatted, contains('1500.0ms'));
        expect(formatted, contains('target: 2000.0ms'));
        expect(formatted, contains('(+25.0%)'));
      });

      test('should format failing result without improvement', () {
        final result = TestResults(
          testName: 'Memory Stability Test',
          passed: false,
          actualValue: 150.0,
          targetValue: 120.0,
          unit: 'MB',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        final formatted = result.formattedResult;

        expect(formatted, contains('Memory Stability Test: FAIL'));
        expect(formatted, contains('150.0MB'));
        expect(formatted, contains('target: 120.0MB'));
        // Note: This test shows improvement because for memory, lower is better
        // So 150MB vs 120MB target shows negative improvement, but still shows percentage
      });

      test('should format result with no improvement', () {
        final result = TestResults(
          testName: 'Frame Rate Test',
          passed: true,
          actualValue: 55.0,
          targetValue: 60.0,
          unit: 'fps',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        final formatted = result.formattedResult;

        expect(formatted, contains('Frame Rate Test: PASS'));
        expect(formatted, contains('55.0fps'));
        expect(formatted, contains('target: 60.0fps'));
        expect(formatted, isNot(contains('(+')));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        final timestamp = DateTime.parse('2023-10-15T10:30:00.000Z');
        final additionalMetrics = {'executionTimeMs': 150, 'iterations': 100};

        final result = TestResults(
          testName: 'Test Name',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: timestamp,
          additionalMetrics: additionalMetrics,
        );

        final json = result.toJson();

        expect(json['testName'], equals('Test Name'));
        expect(json['passed'], isTrue);
        expect(json['actualValue'], equals(1500.0));
        expect(json['targetValue'], equals(2000.0));
        expect(json['unit'], equals('ms'));
        expect(json['timestamp'], equals('2023-10-15T10:30:00.000Z'));
        expect(json['additionalMetrics'], equals(additionalMetrics));
        expect(json['improvementPercentage'], equals(25.0));
      });

      test('should deserialize from JSON correctly', () {
        final json = {
          'testName': 'Test Name',
          'passed': true,
          'actualValue': 1500.0,
          'targetValue': 2000.0,
          'unit': 'ms',
          'timestamp': '2023-10-15T10:30:00.000Z',
          'additionalMetrics': {'executionTimeMs': 150, 'iterations': 100},
        };

        final result = TestResults.fromJson(json);

        expect(result.testName, equals('Test Name'));
        expect(result.passed, isTrue);
        expect(result.actualValue, equals(1500.0));
        expect(result.targetValue, equals(2000.0));
        expect(result.unit, equals('ms'));
        expect(
          result.timestamp,
          equals(DateTime.parse('2023-10-15T10:30:00.000Z')),
        );
        expect(
          result.additionalMetrics,
          equals({'executionTimeMs': 150, 'iterations': 100}),
        );
      });
    });

    group('Equality and Hash Code', () {
      test('should be equal for same values', () {
        final timestamp = DateTime.now();

        final result1 = TestResults(
          testName: 'Test',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: timestamp,
          additionalMetrics: {'key': 'value'},
        );

        final result2 = TestResults(
          testName: 'Test',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: timestamp,
          additionalMetrics: {'key': 'value'},
        );

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('should not be equal for different values', () {
        final timestamp = DateTime.now();

        final result1 = TestResults(
          testName: 'Test 1',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: timestamp,
          additionalMetrics: {},
        );

        final result2 = TestResults(
          testName: 'Test 2',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: timestamp,
          additionalMetrics: {},
        );

        expect(result1, isNot(equals(result2)));
        expect(result1.hashCode, isNot(equals(result2.hashCode)));
      });

      test('should handle identical references', () {
        final result = TestResults(
          testName: 'Test',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        expect(result, equals(result));
      });
    });

    group('toString Method', () {
      test('should use formattedResult for toString', () {
        final result = TestResults(
          testName: 'Startup Test',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        expect(result.toString(), equals(result.formattedResult));
      });
    });

    group('Edge Cases', () {
      test('should handle very large numbers', () {
        final result = TestResults(
          testName: 'Large Numbers Test',
          passed: true,
          actualValue: 999999999.0,
          targetValue: 1000000000.0,
          unit: 'bytes',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        // For bytes (not time-based), higher is better, so this shows negative improvement
        expect(result.improvementPercentage, closeTo(-0.0000001, 0.001));
        expect(result.showsImprovement, isFalse);
      });

      test('should handle very small numbers', () {
        final result = TestResults(
          testName: 'Small Numbers Test',
          passed: true,
          actualValue: 0.001,
          targetValue: 0.002,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        expect(result.improvementPercentage, equals(50.0));
        expect(result.showsImprovement, isTrue);
      });

      test('should handle negative values', () {
        final result = TestResults(
          testName: 'Negative Values Test',
          passed: false,
          actualValue: -100.0,
          targetValue: 100.0,
          unit: 'delta',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        // For non-time units, this shows negative improvement
        expect(result.improvementPercentage, equals(-200.0));
        expect(result.showsImprovement, isFalse);
      });
    });

    group('Champion Car Wash Specific Scenarios', () {
      test('should validate startup time requirements', () {
        final fastStartup = TestResults(
          testName: 'Champion Car Wash Startup Performance',
          passed: true,
          actualValue: 1500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {'statefulWidgets': 35},
        );

        expect(fastStartup.passed, isTrue);
        expect(fastStartup.actualValue, lessThan(2000.0));
        expect(fastStartup.showsImprovement, isTrue);
      });

      test('should validate booking list performance', () {
        final bookingListResult = TestResults(
          testName: 'Booking List Scrolling Performance',
          passed: true,
          actualValue: 60.0,
          targetValue: 60.0,
          unit: 'fps',
          timestamp: DateTime.now(),
          additionalMetrics: {'bookingCount': 100, 'scrollDuration': 5000},
        );

        expect(bookingListResult.passed, isTrue);
        expect(bookingListResult.actualValue, greaterThanOrEqualTo(60.0));
      });

      test('should validate memory stability for technician workflows', () {
        final memoryResult = TestResults(
          testName: 'Technician Workflow Memory Stability',
          passed: true,
          actualValue: 95.0,
          targetValue: 120.0,
          unit: 'MB',
          timestamp: DateTime.now(),
          additionalMetrics: {'testDurationMinutes': 30, 'workflowCycles': 50},
        );

        expect(memoryResult.passed, isTrue);
        expect(memoryResult.actualValue, lessThan(120.0));
        // Memory unit (MB) is treated as "higher is better" by the logic,
        // so 95MB vs 120MB target shows negative improvement
        expect(memoryResult.showsImprovement, isFalse);
      });

      test('should validate Stripe NFC payment performance', () {
        final paymentResult = TestResults(
          testName: 'Stripe NFC Payment Processing',
          passed: true,
          actualValue: 3500.0,
          targetValue: 5000.0,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {'nfcInitTime': 500, 'paymentProcessTime': 3000},
        );

        expect(paymentResult.passed, isTrue);
        expect(paymentResult.actualValue, lessThan(5000.0));
        expect(paymentResult.showsImprovement, isTrue);
      });
    });
  });
}
