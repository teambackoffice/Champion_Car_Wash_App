import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/utils/test_helpers.dart';
import 'package:champion_car_wash_app/testing/performance/models/test_results.dart';
import 'package:champion_car_wash_app/testing/performance/models/performance_metrics.dart';

/// Unit tests for PerformanceTestHelpers utility functions
void main() {
  group('PerformanceTestHelpers Unit Tests', () {
    group('Mock Data Generation', () {
      test('should generate correct number of mock bookings', () {
        final bookings = PerformanceTestHelpers.generateMockBookings(50);
        
        expect(bookings, hasLength(50));
      });
      
      test('should generate bookings with required fields', () {
        final bookings = PerformanceTestHelpers.generateMockBookings(5);
        
        for (final booking in bookings) {
          expect(booking, containsPair('id', isA<String>()));
          expect(booking, containsPair('customerName', isA<String>()));
          expect(booking, containsPair('serviceType', isA<String>()));
          expect(booking, containsPair('status', isA<String>()));
          expect(booking, containsPair('scheduledTime', isA<DateTime>()));
          expect(booking, containsPair('estimatedDuration', isA<Duration>()));
          expect(booking, containsPair('price', isA<double>()));
          expect(booking, containsPair('vehicleInfo', isA<Map<String, dynamic>>()));
          expect(booking, containsPair('technicianId', isA<String>()));
          expect(booking, containsPair('notes', isA<String>()));
        }
      });
      
      test('should generate bookings with valid service types', () {
        final bookings = PerformanceTestHelpers.generateMockBookings(20);
        final validServiceTypes = ['Car Wash', 'Oil Change', 'Full Service'];
        
        for (final booking in bookings) {
          expect(validServiceTypes, contains(booking['serviceType']));
        }
      });
      
      test('should generate bookings with valid statuses', () {
        final bookings = PerformanceTestHelpers.generateMockBookings(20);
        final validStatuses = ['Pending', 'In Progress', 'Completed'];
        
        for (final booking in bookings) {
          expect(validStatuses, contains(booking['status']));
        }
      });
      
      test('should generate bookings with vehicle info', () {
        final bookings = PerformanceTestHelpers.generateMockBookings(5);
        
        for (final booking in bookings) {
          final vehicleInfo = booking['vehicleInfo'] as Map<String, dynamic>;
          expect(vehicleInfo, containsPair('make', isA<String>()));
          expect(vehicleInfo, containsPair('model', isA<String>()));
          expect(vehicleInfo, containsPair('year', isA<int>()));
          expect(vehicleInfo, containsPair('plateNumber', isA<String>()));
        }
      });
      
      test('should generate correct number of mock payments', () {
        final payments = PerformanceTestHelpers.generateMockPayments(30);
        
        expect(payments, hasLength(30));
      });
      
      test('should generate payments with required fields', () {
        final payments = PerformanceTestHelpers.generateMockPayments(5);
        
        for (final payment in payments) {
          expect(payment, containsPair('id', isA<String>()));
          expect(payment, containsPair('bookingId', isA<String>()));
          expect(payment, containsPair('amount', isA<double>()));
          expect(payment, containsPair('method', isA<String>()));
          expect(payment, containsPair('timestamp', isA<DateTime>()));
          expect(payment, containsPair('status', isA<String>()));
          expect(payment, containsPair('transactionId', isA<String>()));
        }
      });
      
      test('should generate payments with valid methods', () {
        final payments = PerformanceTestHelpers.generateMockPayments(20);
        final validMethods = ['NFC', 'Card', 'Cash', 'Digital Wallet'];
        
        for (final payment in payments) {
          expect(validMethods, contains(payment['method']));
        }
      });
    });
    
    group('Test Summary Creation', () {
      test('should create summary for empty results', () {
        final summary = PerformanceTestHelpers.createTestSummary([]);
        
        expect(summary['totalTests'], equals(0));
        expect(summary['passedTests'], equals(0));
        expect(summary['failedTests'], equals(0));
        expect(summary['passRate'], equals(0.0));
        expect(summary['averageScore'], equals(0.0));
        expect(summary['executionTime'], equals(0));
      });
      
      test('should create summary for all passing tests', () {
        final results = [
          TestResults(
            testName: 'Test 1',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 100},
          ),
          TestResults(
            testName: 'Test 2',
            passed: true,
            actualValue: 65.0,
            targetValue: 60.0,
            unit: 'fps',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 150},
          ),
        ];
        
        final summary = PerformanceTestHelpers.createTestSummary(results);
        
        expect(summary['totalTests'], equals(2));
        expect(summary['passedTests'], equals(2));
        expect(summary['failedTests'], equals(0));
        expect(summary['passRate'], equals(100.0));
        expect(summary['executionTime'], equals(250));
      });
      
      test('should create summary for mixed test results', () {
        final results = [
          TestResults(
            testName: 'Passing Test',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 100},
          ),
          TestResults(
            testName: 'Failing Test',
            passed: false,
            actualValue: 3000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 200},
          ),
        ];
        
        final summary = PerformanceTestHelpers.createTestSummary(results);
        
        expect(summary['totalTests'], equals(2));
        expect(summary['passedTests'], equals(1));
        expect(summary['failedTests'], equals(1));
        expect(summary['passRate'], equals(50.0));
        expect(summary['executionTime'], equals(300));
      });
      
      test('should calculate average improvement correctly', () {
        final results = [
          TestResults(
            testName: 'Test 1',
            passed: true,
            actualValue: 1500.0, // 25% improvement
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 100},
          ),
          TestResults(
            testName: 'Test 2',
            passed: true,
            actualValue: 66.0, // 10% improvement
            targetValue: 60.0,
            unit: 'fps',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 150},
          ),
        ];
        
        final summary = PerformanceTestHelpers.createTestSummary(results);
        
        expect(summary['averageImprovement'], closeTo(17.5, 0.1)); // (25 + 10) / 2
      });
      
      test('should handle missing executionTimeMs in additionalMetrics', () {
        final results = [
          TestResults(
            testName: 'Test 1',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {}, // No executionTimeMs
          ),
        ];
        
        final summary = PerformanceTestHelpers.createTestSummary(results);
        
        expect(summary['executionTime'], equals(0));
      });
    });
    
    group('Champion Car Wash Requirements Validation', () {
      test('should validate all requirements met', () {
        final excellentMetrics = PerformanceMetrics.now(
          startupTimeMs: 1500.0,  // < 2000 ✓
          frameSkips: 0,
          memoryUsageMB: 95.0,    // < 120 ✓
          apiResponseTimeMs: 800.0, // < 1000 ✓
          frameRate: 60.0,        // >= 60 ✓
          batteryDrainPerHour: 3.0,
        );
        
        final isValid = PerformanceTestHelpers.validateChampionCarWashRequirements(excellentMetrics);
        
        expect(isValid, isTrue);
      });
      
      test('should fail validation when startup requirement not met', () {
        final slowStartupMetrics = PerformanceMetrics.now(
          startupTimeMs: 2500.0,  // > 2000 ✗
          frameSkips: 0,
          memoryUsageMB: 95.0,    // < 120 ✓
          apiResponseTimeMs: 800.0, // < 1000 ✓
          frameRate: 60.0,        // >= 60 ✓
          batteryDrainPerHour: 3.0,
        );
        
        final isValid = PerformanceTestHelpers.validateChampionCarWashRequirements(slowStartupMetrics);
        
        expect(isValid, isFalse);
      });
      
      test('should fail validation when memory requirement not met', () {
        final highMemoryMetrics = PerformanceMetrics.now(
          startupTimeMs: 1500.0,  // < 2000 ✓
          frameSkips: 0,
          memoryUsageMB: 150.0,   // > 120 ✗
          apiResponseTimeMs: 800.0, // < 1000 ✓
          frameRate: 60.0,        // >= 60 ✓
          batteryDrainPerHour: 3.0,
        );
        
        final isValid = PerformanceTestHelpers.validateChampionCarWashRequirements(highMemoryMetrics);
        
        expect(isValid, isFalse);
      });
    });
    
    group('Performance Report Generation', () {
      test('should generate report with test results and metrics', () {
        final results = [
          TestResults(
            testName: 'Startup Test',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 100},
          ),
          TestResults(
            testName: 'Memory Test',
            passed: false,
            actualValue: 150.0,
            targetValue: 120.0,
            unit: 'MB',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 200, 'error': 'Memory leak detected'},
          ),
        ];
        
        final metrics = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 2,
          memoryUsageMB: 95.0,
          apiResponseTimeMs: 800.0,
          frameRate: 58.5,
          batteryDrainPerHour: 4.0,
        );
        
        final report = PerformanceTestHelpers.generatePerformanceReport(results, metrics);
        
        expect(report, contains('Champion Car Wash Performance Test Report'));
        expect(report, contains('Test Summary:'));
        expect(report, contains('Total Tests: 2'));
        expect(report, contains('Passed: 1'));
        expect(report, contains('Failed: 1'));
        expect(report, contains('Pass Rate: 50.0%'));
        expect(report, contains('Individual Test Results:'));
        expect(report, contains('[PASS] Startup Test'));
        expect(report, contains('[FAIL] Memory Test'));
        expect(report, contains('Current Performance Metrics:'));
        expect(report, contains('Startup Time: 1500.0ms'));
        expect(report, contains('Frame Rate: 58.5 fps'));
        expect(report, contains('Memory Usage: 95.0 MB'));
        expect(report, contains('Recommendations:'));
      });
      
      test('should generate report without metrics', () {
        final results = [
          TestResults(
            testName: 'Test',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {'executionTimeMs': 100},
          ),
        ];
        
        final report = PerformanceTestHelpers.generatePerformanceReport(results, null);
        
        expect(report, contains('Champion Car Wash Performance Test Report'));
        expect(report, contains('Test Summary:'));
        expect(report, contains('[PASS] Test'));
        expect(report, isNot(contains('Current Performance Metrics:')));
        expect(report, contains('Recommendations:'));
        expect(report, contains('All tests passed! Performance is optimal.'));
      });
      
      test('should include error information for failed tests', () {
        final results = [
          TestResults(
            testName: 'Failed Test',
            passed: false,
            actualValue: 3000.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {'error': 'Timeout occurred'},
          ),
        ];
        
        final report = PerformanceTestHelpers.generatePerformanceReport(results, null);
        
        expect(report, contains('[FAIL] Failed Test'));
        expect(report, contains('Error: Timeout occurred'));
      });
      
      test('should include improvement percentages', () {
        final results = [
          TestResults(
            testName: 'Improved Test',
            passed: true,
            actualValue: 1500.0,
            targetValue: 2000.0,
            unit: 'ms',
            timestamp: DateTime.now(),
            additionalMetrics: {},
          ),
        ];
        
        final report = PerformanceTestHelpers.generatePerformanceReport(results, null);
        
        expect(report, contains('Improvement: +25.0%'));
      });
    });
    
    group('Device Specifications', () {
      test('should create mock device specs with default values', () {
        final specs = PerformanceTestHelpers.createMockDeviceSpecs();
        
        expect(specs['processor'], equals('MediaTek Helio G85'));
        expect(specs['ramGB'], equals(4));
        expect(specs['androidVersion'], equals('11'));
        expect(specs['screenSize'], equals(6.1));
        expect(specs['isLowEndDevice'], isTrue);
        expect(specs['isHighEndDevice'], isFalse);
      });
      
      test('should create mock device specs with custom values', () {
        final specs = PerformanceTestHelpers.createMockDeviceSpecs(
          processor: 'Snapdragon 888',
          ramGB: 8,
          androidVersion: '12',
          screenSize: 6.7,
        );
        
        expect(specs['processor'], equals('Snapdragon 888'));
        expect(specs['ramGB'], equals(8));
        expect(specs['androidVersion'], equals('12'));
        expect(specs['screenSize'], equals(6.7));
        expect(specs['isLowEndDevice'], isFalse);
        expect(specs['isHighEndDevice'], isTrue);
      });
      
      test('should correctly identify low-end devices', () {
        final lowEndSpecs1 = PerformanceTestHelpers.createMockDeviceSpecs(
          processor: 'MediaTek Helio G35',
          ramGB: 2,
        );
        
        final lowEndSpecs2 = PerformanceTestHelpers.createMockDeviceSpecs(
          ramGB: 3,
        );
        
        expect(lowEndSpecs1['isLowEndDevice'], isTrue);
        expect(lowEndSpecs2['isLowEndDevice'], isTrue);
      });
      
      test('should correctly identify high-end devices', () {
        final highEndSpecs = PerformanceTestHelpers.createMockDeviceSpecs(
          processor: 'Snapdragon 8 Gen 1',
          ramGB: 12,
        );
        
        expect(highEndSpecs['isHighEndDevice'], isTrue);
        expect(highEndSpecs['isLowEndDevice'], isFalse);
      });
    });
    
    group('Benchmark Function', () {
      test('should measure function execution time', () async {
        final executionTime = await PerformanceTestHelpers.benchmarkFunction(() async {
          await Future.delayed(const Duration(milliseconds: 100));
        });
        
        expect(executionTime, greaterThanOrEqualTo(90.0)); // Allow some variance
        expect(executionTime, lessThan(200.0)); // Should not be too much longer
      });
      
      test('should handle synchronous functions', () async {
        var sum = 0;
        final executionTime = await PerformanceTestHelpers.benchmarkFunction(() async {
          // Synchronous operation
          for (int i = 0; i < 1000; i++) {
            sum += i;
          }
        });

        expect(executionTime, greaterThanOrEqualTo(0.0));
        expect(executionTime, lessThan(100.0)); // Should be very fast
        expect(sum, greaterThan(0)); // Verify sum was computed
      });
    });
    
    group('Simulation Functions', () {
      test('simulateNetworkDelay should respect min/max bounds', () async {
        final stopwatch = Stopwatch()..start();
        
        await PerformanceTestHelpers.simulateNetworkDelay(
          min: const Duration(milliseconds: 50),
          max: const Duration(milliseconds: 100),
        );
        
        stopwatch.stop();
        
        expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(45)); // Allow some variance
        expect(stopwatch.elapsedMilliseconds, lessThan(150));
      });
      
      test('simulateMemoryIntensiveOperation should complete without error', () async {
        // This test ensures the function doesn't crash or throw exceptions
        await PerformanceTestHelpers.simulateMemoryIntensiveOperation(
          iterations: 100,
          delay: const Duration(microseconds: 10),
        );
        
        // If we reach here, the function completed successfully
        expect(true, isTrue);
      });
    });
  });
}