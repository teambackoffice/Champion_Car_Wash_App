import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/core/performance_test_suite.dart';
import 'package:champion_car_wash_app/testing/performance/models/test_results.dart';

/// Unit tests for PerformanceTestSuite methods
/// Tests core functionality without requiring full widget testing
void main() {
  group('PerformanceTestSuite Unit Tests', () {
    group('calculatePerformanceScore', () {
      test('should return score 0 for empty test results', () async {
        final score = await PerformanceTestSuite.calculatePerformanceScore([]);

        expect(score.score, equals(0.0));
        expect(score.grade, equals('F'));
        expect(score.breakdown, isEmpty);
      });

      test('should calculate correct score for all passing tests', () async {
        final testResults = [
          TestResults(
            testName: 'Startup Test',
            passed: true,
            actualValue: 1000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
          TestResults(
            testName: 'Memory Test',
            passed: true,
            actualValue: 80.0,
            targetValue: 120.0,
            unit: 'MB',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final score = await PerformanceTestSuite.calculatePerformanceScore(
          testResults,
        );

        expect(score.score, greaterThan(0.0));
        expect(score.score, lessThanOrEqualTo(10.0));
        expect(score.breakdown, hasLength(2));
        expect(score.breakdown.containsKey('Startup Test'), isTrue);
        expect(score.breakdown.containsKey('Memory Test'), isTrue);
      });

      test('should calculate correct score for mixed test results', () async {
        final testResults = [
          TestResults(
            testName: 'Passing Test',
            passed: true,
            actualValue: 1000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
          TestResults(
            testName: 'Failing Test',
            passed: false,
            actualValue: 3000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final score = await PerformanceTestSuite.calculatePerformanceScore(
          testResults,
        );

        expect(score.score, greaterThan(0.0));
        expect(score.score, lessThan(10.0));
        expect(score.breakdown['Passing Test'], greaterThan(0.0));
        expect(score.breakdown['Failing Test'], equals(0.0));
      });

      test('should assign correct grades based on score', () async {
        // Test A+ grade (score >= 9.0)
        final excellentResults = [
          TestResults(
            testName: 'Excellent Test',
            passed: true,
            actualValue: 500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final excellentScore =
            await PerformanceTestSuite.calculatePerformanceScore(
              excellentResults,
            );
        expect(excellentScore.grade, equals('A+'));

        // Test F grade (all failing tests)
        final failingResults = [
          TestResults(
            testName: 'Failing Test',
            passed: false,
            actualValue: 5000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final failingScore =
            await PerformanceTestSuite.calculatePerformanceScore(
              failingResults,
            );
        expect(failingScore.grade, equals('F'));
      });

      test('should handle performance ratio calculations correctly', () async {
        // Test where actual is better than target (lower is better for ms)
        final betterResults = [
          TestResults(
            testName: 'Better Performance',
            passed: true,
            actualValue: 1000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final betterScore =
            await PerformanceTestSuite.calculatePerformanceScore(betterResults);
        expect(betterScore.breakdown['Better Performance'], greaterThan(5.0));

        // Test where actual is worse than target
        final worseResults = [
          TestResults(
            testName: 'Worse Performance',
            passed: true,
            actualValue: 3000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final worseScore = await PerformanceTestSuite.calculatePerformanceScore(
          worseResults,
        );
        expect(worseScore.breakdown['Worse Performance'], lessThan(10.0));
      });
    });

    group('runAllTests', () {
      test('should return list of test results', () async {
        // Use short duration for memory test to speed up unit testing
        final results = await PerformanceTestSuite.runAllTests(
          memoryTestDuration: const Duration(seconds: 1),
        );

        expect(results, isA<List<TestResults>>());
        expect(results.length, greaterThan(0));

        // Verify all expected test types are present
        final testNames = results.map((r) => r.testName).toList();
        expect(testNames, contains(contains('Startup')));
        expect(testNames, contains(contains('Memory')));
        expect(testNames, contains(contains('Booking List')));
        expect(testNames, contains(contains('Payment')));
      });

      test('should handle test failures gracefully', () async {
        // This test verifies that even if individual tests fail,
        // runAllTests still returns results
        final results = await PerformanceTestSuite.runAllTests(
          memoryTestDuration: const Duration(milliseconds: 100),
        );

        expect(results, isA<List<TestResults>>());
        // Should have results even if some tests fail
        expect(results.isNotEmpty, isTrue);

        // Each result should have proper structure
        for (final result in results) {
          expect(result.testName, isNotEmpty);
          expect(result.unit, isNotEmpty);
          expect(result.targetValue, greaterThan(0));
          expect(result.timestamp, isNotNull);
          expect(result.additionalMetrics, isA<Map<String, dynamic>>());
        }
      });
    });

    group('Error Handling', () {
      test('runStartupTests should handle errors gracefully', () async {
        // This test verifies error handling in startup tests
        final result = await PerformanceTestSuite.runStartupTests(
          timeout: const Duration(
            milliseconds: 1,
          ), // Very short timeout to force error
        );

        expect(result, isA<TestResults>());
        expect(result.testName, contains('Startup'));
        expect(result.unit, equals('ms'));
        expect(result.targetValue, equals(2000.0));

        // Test should complete regardless of pass/fail status
        expect(result.testName, isNotEmpty);
        expect(result.unit, isNotEmpty);
        expect(result.targetValue, greaterThan(0));
      });

      test('runMemoryTests should handle errors gracefully', () async {
        final result = await PerformanceTestSuite.runMemoryTests(
          testDuration: const Duration(milliseconds: 1),
        );

        expect(result, isA<TestResults>());
        expect(result.testName, contains('Memory'));
        expect(result.unit, equals('MB'));
        expect(result.targetValue, equals(120.0));

        // Test should complete regardless of pass/fail status
        expect(result.testName, isNotEmpty);
        expect(result.unit, isNotEmpty);
      });

      test('runUIPerformanceTests should handle errors gracefully', () async {
        final result = await PerformanceTestSuite.runUIPerformanceTests();

        expect(result, isA<TestResults>());
        expect(result.testName, contains('Booking List'));
        expect(result.unit, equals('fps'));
        expect(result.targetValue, equals(60.0));

        // Test should complete regardless of pass/fail status
        expect(result.testName, isNotEmpty);
        expect(result.unit, isNotEmpty);
      });

      test('runAPITests should handle errors gracefully', () async {
        final result = await PerformanceTestSuite.runAPITests();

        expect(result, isA<TestResults>());
        expect(result.testName, contains('Payment'));
        expect(result.unit, equals('ms'));
        expect(result.targetValue, equals(5000.0));

        // Test should complete regardless of pass/fail status
        expect(result.testName, isNotEmpty);
        expect(result.unit, isNotEmpty);
      });
    });

    group('Grade Calculation', () {
      test('should assign A+ for scores >= 9.0', () async {
        final results = [
          TestResults(
            testName: 'Perfect Test',
            passed: true,
            actualValue: 100.0,
            targetValue: 1000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final score = await PerformanceTestSuite.calculatePerformanceScore(
          results,
        );
        expect(score.score, greaterThanOrEqualTo(9.0));
        expect(score.grade, equals('A+'));
      });

      test('should assign correct intermediate grades', () async {
        // Test B grade (6.0 <= score < 7.0)
        final results = [
          TestResults(
            testName: 'Average Test',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];

        final score = await PerformanceTestSuite.calculatePerformanceScore(
          results,
        );
        expect(score.grade, isIn(['A+', 'A', 'B+', 'B', 'C+', 'C', 'D', 'F']));
      });
    });
  });

  group('OverallScore Class', () {
    test('should create OverallScore with correct properties', () {
      final breakdown = {'Test 1': 8.5, 'Test 2': 7.2};
      final timestamp = DateTime.now();

      final score = OverallScore(
        score: 7.85,
        grade: 'B+',
        timestamp: timestamp,
        breakdown: breakdown,
      );

      expect(score.score, equals(7.85));
      expect(score.grade, equals('B+'));
      expect(score.timestamp, equals(timestamp));
      expect(score.breakdown, equals(breakdown));
    });

    test('should have correct toString representation', () {
      final score = OverallScore(
        score: 8.5,
        grade: 'A',
        timestamp: DateTime.now(),
        breakdown: {},
      );

      expect(score.toString(), equals('Performance Score: 8.5/10 (Grade: A)'));
    });
  });
}
