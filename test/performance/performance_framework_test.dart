import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/performance_testing.dart';

/// Integration tests for the performance testing framework
/// Demonstrates how to use the framework with Flutter's test system
void main() {
  group('Performance Testing Framework', () {
    late PerformanceTestRunner runner;
    
    setUpAll(() {
      runner = PerformanceTestRunner.instance;
    });
    
    tearDownAll(() async {
      await runner.cleanup();
    });
    
    testWidgets('Framework initialization', (WidgetTester tester) async {
      // Test framework initialization
      await runner.initialize();
      
      // Verify framework is ready
      expect(runner, isNotNull);
    });
    
    testWidgets('Performance metrics collection', (WidgetTester tester) async {
      await runner.initialize();
      
      // Get current metrics
      final metrics = await runner.getCurrentMetrics();
      
      // Verify metrics structure
      expect(metrics, isA<PerformanceMetrics>());
      expect(metrics.timestamp, isNotNull);
      expect(metrics.frameRate, greaterThanOrEqualTo(0));
      expect(metrics.memoryUsageMB, greaterThanOrEqualTo(0));
    });
    
    testWidgets('Startup performance test', (WidgetTester tester) async {
      await runner.initialize();
      
      // Run startup test
      final result = await PerformanceTest.startup();
      
      // Verify test result structure
      expect(result, isA<TestResults>());
      expect(result.testName, equals('Startup Performance Test'));
      expect(result.unit, equals('ms'));
      expect(result.targetValue, equals(2000.0));
      expect(result.timestamp, isNotNull);
    });
    
    testWidgets('Memory stability test', (WidgetTester tester) async {
      await runner.initialize();
      
      // Run memory test with shorter duration for testing
      final result = await PerformanceTestSuite.runMemoryTests(
        testDuration: const Duration(seconds: 5),
      );
      
      // Verify test result
      expect(result, isA<TestResults>());
      expect(result.testName, equals('Memory Stability Test'));
      expect(result.unit, equals('MB'));
      expect(result.targetValue, equals(120.0));
    });
    
    testWidgets('UI performance test', (WidgetTester tester) async {
      await runner.initialize();
      
      // Run UI performance test
      final result = await PerformanceTest.ui();
      
      // Verify test result
      expect(result, isA<TestResults>());
      expect(result.testName, equals('UI Performance Test'));
      expect(result.unit, equals('fps'));
      expect(result.targetValue, equals(60.0));
    });
    
    testWidgets('API performance test', (WidgetTester tester) async {
      await runner.initialize();
      
      // Run API performance test
      final result = await PerformanceTest.api();
      
      // Verify test result
      expect(result, isA<TestResults>());
      expect(result.testName, equals('API Performance Test'));
      expect(result.unit, equals('ms'));
      expect(result.targetValue, equals(1000.0));
    });
    
    testWidgets('Complete test suite execution', (WidgetTester tester) async {
      await runner.initialize();
      
      // Run all tests
      final results = await PerformanceTest.all();
      
      // Verify all tests ran
      expect(results, hasLength(4));
      expect(results.map((r) => r.testName), containsAll([
        'Startup Performance Test',
        'Memory Stability Test',
        'UI Performance Test',
        'API Performance Test',
      ]));
    });
    
    testWidgets('Performance score calculation', (WidgetTester tester) async {
      await runner.initialize();
      
      // Run tests and calculate score
      final results = await PerformanceTest.all();
      final score = await PerformanceTestSuite.calculatePerformanceScore(results);
      
      // Verify score structure
      expect(score, isA<OverallScore>());
      expect(score.score, greaterThanOrEqualTo(0.0));
      expect(score.score, lessThanOrEqualTo(10.0));
      expect(score.grade, isNotEmpty);
      expect(score.breakdown, hasLength(results.length));
    });
    
    testWidgets('Performance report generation', (WidgetTester tester) async {
      await runner.initialize();
      
      // Generate performance report
      final report = await runner.generateReport();
      
      // Verify report content
      expect(report, isNotEmpty);
      expect(report, contains('Champion Car Wash Performance Test Report'));
      expect(report, contains('Test Summary:'));
      expect(report, contains('Individual Test Results:'));
      expect(report, contains('Performance Metrics:'));
    });
    
    testWidgets('Requirements validation', (WidgetTester tester) async {
      await runner.initialize();
      
      // Validate requirements
      final meetsRequirements = await runner.validateRequirements();
      
      // Verify validation result
      expect(meetsRequirements, isA<bool>());
    });
  });
  
  group('Test Helpers', () {
    test('Mock data generation', () {
      // Test booking data generation
      final bookings = PerformanceTestHelpers.generateMockBookings(100);
      expect(bookings, hasLength(100));
      expect(bookings.first.keys, contains('id'));
      expect(bookings.first.keys, contains('customerName'));
      expect(bookings.first.keys, contains('serviceType'));
      
      // Test payment data generation
      final payments = PerformanceTestHelpers.generateMockPayments(50);
      expect(payments, hasLength(50));
      expect(payments.first.keys, contains('id'));
      expect(payments.first.keys, contains('amount'));
      expect(payments.first.keys, contains('method'));
    });
    
    test('Test summary creation', () {
      // Create mock test results
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
    
    test('Device specs creation', () {
      final specs = PerformanceTestHelpers.createMockDeviceSpecs(
        processor: 'Snapdragon 888',
        ramGB: 8,
      );
      
      expect(specs['processor'], equals('Snapdragon 888'));
      expect(specs['ramGB'], equals(8));
      expect(specs['isHighEndDevice'], isTrue);
      expect(specs['isLowEndDevice'], isFalse);
    });
  });
  
  group('Performance Metrics', () {
    test('Metrics creation and scoring', () {
      final metrics = PerformanceMetrics.now(
        startupTimeMs: 1500.0,
        frameSkips: 2,
        memoryUsageMB: 95.0,
        apiResponseTimeMs: 800.0,
        frameRate: 58.5,
        batteryDrainPerHour: 5.0,
      );
      
      expect(metrics.startupTimeMs, equals(1500.0));
      expect(metrics.meetsStartupRequirement, isTrue);
      expect(metrics.meetsMemoryRequirement, isTrue);
      expect(metrics.performanceScore, greaterThan(0.0));
      expect(metrics.healthStatus, isA<PerformanceHealth>());
    });
    
    test('Performance health calculation', () {
      // Excellent performance
      final excellentMetrics = PerformanceMetrics.now(
        startupTimeMs: 1000.0,
        frameSkips: 0,
        memoryUsageMB: 80.0,
        apiResponseTimeMs: 500.0,
        frameRate: 60.0,
        batteryDrainPerHour: 3.0,
      );
      
      expect(excellentMetrics.healthStatus, equals(PerformanceHealth.excellent));
      
      // Poor performance
      final poorMetrics = PerformanceMetrics.now(
        startupTimeMs: 5000.0,
        frameSkips: 20,
        memoryUsageMB: 200.0,
        apiResponseTimeMs: 3000.0,
        frameRate: 30.0,
        batteryDrainPerHour: 15.0,
      );
      
      expect(poorMetrics.healthStatus, equals(PerformanceHealth.poor));
    });
  });
}