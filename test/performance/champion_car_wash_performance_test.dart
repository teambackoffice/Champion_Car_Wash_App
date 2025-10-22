import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/core/performance_test_suite.dart';
import 'package:champion_car_wash_app/testing/performance/tests/startup_performance_test.dart';
import 'package:champion_car_wash_app/testing/performance/tests/booking_list_performance_test.dart';
import 'package:champion_car_wash_app/testing/performance/tests/payment_performance_test.dart';
import 'package:champion_car_wash_app/testing/performance/tests/memory_stability_test.dart';
import 'package:champion_car_wash_app/testing/performance/models/test_results.dart';

void main() {
  group('Champion Car Wash Performance Testing Framework', () {
    group('PerformanceTestSuite', () {
      test('should run startup performance tests successfully', () async {
        final result = await PerformanceTestSuite.runStartupTests();

        expect(result, isA<TestResults>());
        expect(
          result.testName,
          equals('Champion Car Wash Startup Performance'),
        );
        expect(result.unit, equals('ms'));
        expect(result.targetValue, equals(2000.0));
        expect(result.actualValue, greaterThan(0));
        expect(result.additionalMetrics, isNotEmpty);
        expect(
          result.additionalMetrics.containsKey('statefulWidgetCount'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('firstMeaningfulPaint'),
          isTrue,
        );
      });

      test('should run UI performance tests successfully', () async {
        final result = await PerformanceTestSuite.runUIPerformanceTests();

        expect(result, isA<TestResults>());
        expect(
          result.testName,
          equals('Champion Car Wash Booking List Performance'),
        );
        expect(result.unit, equals('fps'));
        expect(result.targetValue, equals(60.0));
        expect(result.actualValue, greaterThan(0));
        expect(result.additionalMetrics, isNotEmpty);
        expect(
          result.additionalMetrics.containsKey('bookingItemCount'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('scrollPerformance'),
          isTrue,
        );
      });

      test('should run API performance tests successfully', () async {
        final result = await PerformanceTestSuite.runAPITests();

        expect(result, isA<TestResults>());
        expect(
          result.testName,
          equals('Champion Car Wash Payment Performance'),
        );
        expect(result.unit, equals('ms'));
        expect(result.targetValue, equals(5000.0));
        expect(result.actualValue, greaterThan(0));
        expect(result.additionalMetrics, isNotEmpty);
        expect(
          result.additionalMetrics.containsKey('stripeInitialization'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('paymentProcessing'),
          isTrue,
        );
      });

      test('should run memory stability tests successfully', () async {
        // Use a shorter duration for testing
        final result = await PerformanceTestSuite.runMemoryTests(
          testDuration: const Duration(seconds: 30),
        );

        expect(result, isA<TestResults>());
        expect(result.testName, contains('Memory Stability'));
        expect(result.unit, equals('MB'));
        expect(result.targetValue, equals(120.0));
        expect(result.actualValue, greaterThan(0));
        expect(result.additionalMetrics, isNotEmpty);
        expect(
          result.additionalMetrics.containsKey('memoryLeaksDetected'),
          isTrue,
        );
        expect(result.additionalMetrics.containsKey('cycleCount'), isTrue);
      });

      test('should calculate performance score correctly', () async {
        final testResults = [
          TestResults(
            testName: 'Test 1',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
          TestResults(
            testName: 'Test 2',
            passed: true,
            actualValue: 58.0,
            targetValue: 60.0,
            unit: 'fps',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final score = await PerformanceTestSuite.calculatePerformanceScore(
          testResults,
        );

        expect(score.score, greaterThan(0));
        expect(score.score, lessThanOrEqualTo(10.0));
        expect(score.grade, isNotEmpty);
        expect(score.breakdown, hasLength(2));
        expect(score.breakdown.containsKey('Test 1'), isTrue);
        expect(score.breakdown.containsKey('Test 2'), isTrue);
      });

      test('should handle empty test results for performance score', () async {
        final score = await PerformanceTestSuite.calculatePerformanceScore([]);

        expect(score.score, equals(0.0));
        expect(score.grade, equals('F'));
        expect(score.breakdown, isEmpty);
      });

      test('should run all tests in sequence', () async {
        final results = await PerformanceTestSuite.runAllTests(
          memoryTestDuration: const Duration(seconds: 10),
        );

        expect(results, isNotEmpty);
        expect(results.length, equals(4)); // startup, UI, API, memory

        // Verify each test type is present
        final testNames = results.map((r) => r.testName).toList();
        expect(testNames.any((name) => name.contains('Startup')), isTrue);
        expect(testNames.any((name) => name.contains('Booking List')), isTrue);
        expect(testNames.any((name) => name.contains('Payment')), isTrue);
        expect(testNames.any((name) => name.contains('Memory')), isTrue);
      });
    });

    group('StartupPerformanceTest', () {
      test('should execute startup test with detailed metrics', () async {
        final test = StartupPerformanceTest();
        final result = await test.execute();

        expect(
          result.testName,
          equals('Champion Car Wash Startup Performance'),
        );
        expect(result.actualValue, lessThan(3000.0)); // Should be reasonable
        expect(
          result.additionalMetrics.containsKey('frameworkInitTime'),
          isTrue,
        );
        expect(result.additionalMetrics.containsKey('widgetTreeTime'), isTrue);
        expect(
          result.additionalMetrics.containsKey('firstMeaningfulPaint'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('statefulWidgetCount'),
          isTrue,
        );

        final widgetCount =
            result.additionalMetrics['statefulWidgetCount'] as int;
        expect(widgetCount, greaterThanOrEqualTo(35));
      });

      test('should generate detailed startup report', () async {
        final report = await StartupPerformanceTest.getStartupReport();

        expect(report.containsKey('testResult'), isTrue);
        expect(report.containsKey('performance'), isTrue);
        expect(report.containsKey('breakdown'), isTrue);
        expect(report.containsKey('validation'), isTrue);

        final validation = report['validation'] as Map<String, dynamic>;
        expect(validation.containsKey('timeCheck'), isTrue);
        expect(validation.containsKey('widgetCheck'), isTrue);
        expect(validation.containsKey('paintCheck'), isTrue);
      });
    });

    group('BookingListPerformanceTest', () {
      test('should execute booking list test with scrolling metrics', () async {
        final test = BookingListPerformanceTest();
        final result = await test.execute();

        expect(
          result.testName,
          equals('Champion Car Wash Booking List Performance'),
        );
        expect(result.unit, equals('fps'));
        expect(
          result.additionalMetrics.containsKey('bookingItemCount'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('scrollPerformance'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('searchPerformance'),
          isTrue,
        );

        final itemCount = result.additionalMetrics['bookingItemCount'] as int;
        expect(itemCount, greaterThanOrEqualTo(100));
      });

      test('should generate detailed booking list report', () async {
        final report = await BookingListPerformanceTest.getBookingListReport();

        expect(report.containsKey('testResult'), isTrue);
        expect(report.containsKey('scrolling'), isTrue);
        expect(report.containsKey('search'), isTrue);
        expect(report.containsKey('validation'), isTrue);

        final validation = report['validation'] as Map<String, dynamic>;
        expect(validation.containsKey('frameRateCheck'), isTrue);
        expect(validation.containsKey('itemCountCheck'), isTrue);
        expect(validation.containsKey('searchCheck'), isTrue);
      });
    });

    group('PaymentPerformanceTest', () {
      test('should execute payment test with Stripe NFC metrics', () async {
        final test = PaymentPerformanceTest();
        final result = await test.execute();

        expect(
          result.testName,
          equals('Champion Car Wash Payment Performance'),
        );
        expect(result.unit, equals('ms'));
        expect(
          result.additionalMetrics.containsKey('stripeInitialization'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('nfcResponsiveness'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('paymentProcessing'),
          isTrue,
        );
        expect(result.additionalMetrics.containsKey('paymentHistory'), isTrue);
      });

      test('should generate detailed payment report', () async {
        final report = await PaymentPerformanceTest.getPaymentReport();

        expect(report.containsKey('testResult'), isTrue);
        expect(report.containsKey('stripe'), isTrue);
        expect(report.containsKey('nfc'), isTrue);
        expect(report.containsKey('processing'), isTrue);
        expect(report.containsKey('validation'), isTrue);

        final validation = report['validation'] as Map<String, dynamic>;
        expect(validation.containsKey('stripeCheck'), isTrue);
        expect(validation.containsKey('nfcCheck'), isTrue);
        expect(validation.containsKey('processingCheck'), isTrue);
        expect(validation.containsKey('uiCheck'), isTrue);
      });
    });

    group('MemoryStabilityTest', () {
      test('should execute memory test with leak detection', () async {
        final result = await MemoryStabilityTest.runQuickTest(
          duration: const Duration(seconds: 5),
        );

        expect(result.testName, contains('Memory Stability'));
        expect(result.unit, equals('MB'));
        expect(
          result.additionalMetrics.containsKey('memoryLeaksDetected'),
          isTrue,
        );
        expect(
          result.additionalMetrics.containsKey('widgetDisposalChecks'),
          isTrue,
        );
        expect(result.additionalMetrics.containsKey('cycleCount'), isTrue);
        expect(result.additionalMetrics.containsKey('memoryGrowth'), isTrue);
      });

      test('should generate detailed memory report', () async {
        final report = await MemoryStabilityTest.getMemoryReport(
          testDuration: const Duration(seconds: 3),
        );

        expect(report.containsKey('testResult'), isTrue);
        expect(report.containsKey('stability'), isTrue);
        expect(report.containsKey('validation'), isTrue);

        final stability = report['stability'] as Map<String, dynamic>;
        expect(stability.containsKey('memoryGrowth'), isTrue);
        expect(stability.containsKey('leaksDetected'), isTrue);
        expect(stability.containsKey('disposalIssues'), isTrue);

        final validation = report['validation'] as Map<String, dynamic>;
        expect(validation.containsKey('memoryCheck'), isTrue);
        expect(validation.containsKey('leakCheck'), isTrue);
        expect(validation.containsKey('disposalCheck'), isTrue);
      });
    });

    group('TestResults Model', () {
      test(
        'should calculate improvement percentage correctly for time-based metrics',
        () {
          final result = TestResults(
            testName: 'Startup Test',
            passed: true,
            actualValue: 1500.0, // 1.5 seconds
            targetValue: 2000.0, // 2 seconds target
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          );

          expect(result.improvementPercentage, equals(25.0)); // 25% improvement
          expect(result.showsImprovement, isTrue);
        },
      );

      test(
        'should calculate improvement percentage correctly for rate-based metrics',
        () {
          final result = TestResults(
            testName: 'Frame Rate Test',
            passed: true,
            actualValue: 65.0, // 65 fps
            targetValue: 60.0, // 60 fps target
            unit: 'fps',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          );

          expect(
            result.improvementPercentage,
            closeTo(8.33, 0.1),
          ); // ~8.33% improvement
          expect(result.showsImprovement, isTrue);
        },
      );

      test('should format test results correctly', () {
        final result = TestResults(
          testName: 'Test Performance',
          passed: true,
          actualValue: 1800.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: DateTime.now(),
          additionalMetrics: {},
        );

        final formatted = result.formattedResult;
        expect(formatted, contains('Test Performance'));
        expect(formatted, contains('PASS'));
        expect(formatted, contains('1800.0ms'));
        expect(formatted, contains('target: 2000.0ms'));
        expect(formatted, contains('+10.0%')); // Improvement percentage
      });

      test('should serialize to and from JSON correctly', () {
        final original = TestResults(
          testName: 'JSON Test',
          passed: false,
          actualValue: 2500.0,
          targetValue: 2000.0,
          unit: 'ms',
          timestamp: DateTime.parse('2023-01-01T12:00:00Z'),
          additionalMetrics: {'extra': 'data'},
        );

        final json = original.toJson();
        final restored = TestResults.fromJson(json);

        expect(restored.testName, equals(original.testName));
        expect(restored.passed, equals(original.passed));
        expect(restored.actualValue, equals(original.actualValue));
        expect(restored.targetValue, equals(original.targetValue));
        expect(restored.unit, equals(original.unit));
        expect(restored.timestamp, equals(original.timestamp));
        expect(restored.additionalMetrics, equals(original.additionalMetrics));
      });
    });

    group('Performance Score Calculation', () {
      test('should assign correct grades based on score', () async {
        final perfectResults = [
          TestResults(
            testName: 'Perfect Test',
            passed: true,
            actualValue: 1000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final score = await PerformanceTestSuite.calculatePerformanceScore(
          perfectResults,
        );
        expect(score.grade, equals('A+'));
        expect(score.score, greaterThanOrEqualTo(9.0));
      });

      test('should handle failed tests in score calculation', () async {
        final failedResults = [
          TestResults(
            testName: 'Failed Test',
            passed: false,
            actualValue: 5000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final score = await PerformanceTestSuite.calculatePerformanceScore(
          failedResults,
        );
        expect(score.grade, equals('F'));
        expect(score.score, equals(0.0));
      });
    });
  });
}
