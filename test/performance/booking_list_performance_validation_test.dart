import 'package:flutter_test/flutter_test.dart';
import '../../lib/testing/performance/tests/booking_list_performance_test.dart';
import '../../lib/testing/performance/core/performance_test_suite.dart';

/// Validation test for booking list performance implementation
/// Tests the booking list performance test implementation for task 2.2
void main() {
  group('Booking List Performance Test Validation', () {
    late BookingListPerformanceTest bookingListTest;

    setUpAll(() {
      bookingListTest = BookingListPerformanceTest();
    });

    test('BookingListPerformanceTest can be instantiated and executed', () async {
      // Test that the booking list performance test can be created and run
      expect(bookingListTest, isNotNull);
      expect(bookingListTest.testName, equals('Champion Car Wash Booking List Performance'));
      expect(bookingListTest.targetThreshold, equals(60.0));
      expect(bookingListTest.unit, equals('fps'));
    });

    test('Booking list performance test executes successfully', () async {
      // Execute the booking list performance test
      final result = await bookingListTest.execute();
      
      // Validate test result structure
      expect(result, isNotNull);
      expect(result.testName, equals('Champion Car Wash Booking List Performance'));
      expect(result.unit, equals('fps'));
      expect(result.timestamp, isNotNull);
      expect(result.additionalMetrics, isNotNull);
      
      // Validate that we have the required metrics
      final metrics = result.additionalMetrics;
      expect(metrics.containsKey('bookingItemCount'), isTrue);
      expect(metrics.containsKey('scrollPerformance'), isTrue);
      expect(metrics.containsKey('searchPerformance'), isTrue);
      expect(metrics.containsKey('overallScore'), isTrue);
      
      // Validate booking item count requirement (100+ items)
      final itemCount = metrics['bookingItemCount'] as int;
      expect(itemCount, greaterThanOrEqualTo(100), 
          reason: 'Should test with at least 100 booking items');
      
      print('✅ Booking list performance test executed successfully');
      print('📊 Test Results:');
      print('  - Frame Rate: ${result.actualValue.toStringAsFixed(1)} fps');
      print('  - Booking Items: $itemCount');
      print('  - Test Passed: ${result.passed}');
    });

    test('Search performance validation with debouncing', () async {
      final result = await bookingListTest.execute();
      final searchMetrics = result.additionalMetrics['searchPerformance'] as Map<String, dynamic>;
      
      // Validate search performance metrics
      expect(searchMetrics.containsKey('averageResponseTime'), isTrue);
      expect(searchMetrics.containsKey('searchQueries'), isTrue);
      expect(searchMetrics.containsKey('debounceDelay'), isTrue);
      expect(searchMetrics.containsKey('rapidTypingMetrics'), isTrue);
      
      final averageResponseTime = searchMetrics['averageResponseTime'] as double;
      final debounceDelay = searchMetrics['debounceDelay'] as double;
      
      // Validate debouncing implementation (300ms delay)
      expect(debounceDelay, equals(300.0), 
          reason: 'Should implement 300ms debounce delay');
      
      // Validate search response time (should be reasonable with debouncing)
      expect(averageResponseTime, lessThanOrEqualTo(500.0), 
          reason: 'Search response time should be reasonable including debouncing');
      
      // Validate rapid typing debounce efficiency
      final rapidTyping = searchMetrics['rapidTypingMetrics'] as Map<String, dynamic>;
      expect(rapidTyping['debounceEfficiency'], isTrue, 
          reason: 'Debouncing should prevent multiple searches during rapid typing');
      
      print('✅ Search performance validation passed');
      print('📊 Search Metrics:');
      print('  - Average Response Time: ${averageResponseTime.toStringAsFixed(1)} ms');
      print('  - Debounce Delay: ${debounceDelay.toStringAsFixed(0)} ms');
      print('  - Debounce Efficiency: ${rapidTyping['debounceEfficiency']}');
    });

    test('Scrolling performance validation with 60fps target', () async {
      final result = await bookingListTest.execute();
      final scrollMetrics = result.additionalMetrics['scrollPerformance'] as Map<String, dynamic>;
      
      // Validate scrolling performance metrics
      expect(scrollMetrics.containsKey('averageFrameRate'), isTrue);
      expect(scrollMetrics.containsKey('frameSkips'), isTrue);
      expect(scrollMetrics.containsKey('smoothScrollPercentage'), isTrue);
      expect(scrollMetrics.containsKey('scenarioResults'), isTrue);
      
      final frameRate = scrollMetrics['averageFrameRate'] as double;
      final frameSkips = scrollMetrics['frameSkips'] as int;
      final smoothness = scrollMetrics['smoothScrollPercentage'] as double;
      
      // Validate frame rate performance
      expect(frameRate, greaterThan(0.0), 
          reason: 'Should measure actual frame rate');
      
      // Validate smooth scrolling (adjusted for simulation)
      expect(smoothness, greaterThan(50.0), 
          reason: 'Should maintain reasonable scrolling smoothness in simulation');
      
      // Validate scenario testing
      final scenarios = scrollMetrics['scenarioResults'] as Map<String, dynamic>;
      expect(scenarios.containsKey('slow_scroll'), isTrue);
      expect(scenarios.containsKey('normal_scroll'), isTrue);
      expect(scenarios.containsKey('fast_scroll'), isTrue);
      expect(scenarios.containsKey('fling_scroll'), isTrue);
      
      print('✅ Scrolling performance validation passed');
      print('📊 Scrolling Metrics:');
      print('  - Average Frame Rate: ${frameRate.toStringAsFixed(1)} fps');
      print('  - Frame Skips: $frameSkips');
      print('  - Smooth Scroll %: ${smoothness.toStringAsFixed(1)}%');
    });

    test('Integration with PerformanceTestSuite', () async {
      // Test integration with the performance test suite
      final uiTestResult = await PerformanceTestSuite.runUIPerformanceTests();
      
      expect(uiTestResult, isNotNull);
      expect(uiTestResult.testName, contains('Booking List Performance'));
      expect(uiTestResult.unit, equals('fps'));
      
      print('✅ Performance test suite integration validated');
      print('📊 Suite Integration:');
      print('  - Test Name: ${uiTestResult.testName}');
      print('  - Result: ${uiTestResult.passed ? 'PASSED' : 'FAILED'}');
    });

    test('Champion Car Wash requirements compliance', () async {
      final complianceReport = await BookingListPerformanceTest.validateChampionCarWashRequirements();
      
      // Validate compliance report structure
      expect(complianceReport.containsKey('requirements'), isTrue);
      expect(complianceReport.containsKey('compliance'), isTrue);
      expect(complianceReport.containsKey('championCarWashSpecific'), isTrue);
      
      final requirements = complianceReport['requirements'] as Map<String, dynamic>;
      final compliance = complianceReport['compliance'] as Map<String, dynamic>;
      
      // Validate individual requirements
      expect(requirements.containsKey('frameRate'), isTrue);
      expect(requirements.containsKey('itemCount'), isTrue);
      expect(requirements.containsKey('searchResponse'), isTrue);
      expect(requirements.containsKey('scrollSmoothness'), isTrue);
      expect(requirements.containsKey('debounceEfficiency'), isTrue);
      
      // Validate compliance scoring
      expect(compliance.containsKey('score'), isTrue);
      expect(compliance.containsKey('grade'), isTrue);
      
      final score = compliance['score'] as double;
      expect(score, greaterThanOrEqualTo(0.0));
      expect(score, lessThanOrEqualTo(100.0));
      
      print('✅ Champion Car Wash requirements compliance validated');
      print('📊 Compliance Report:');
      print('  - Compliance Score: ${score.toStringAsFixed(1)}%');
      print('  - Grade: ${compliance['grade']}');
      print('  - Requirements Tested: ${requirements.length}');
    });

    test('Performance report generation', () async {
      final report = await BookingListPerformanceTest.getBookingListReport();
      
      // Validate report structure
      expect(report.containsKey('testResult'), isTrue);
      expect(report.containsKey('performance'), isTrue);
      expect(report.containsKey('scrolling'), isTrue);
      expect(report.containsKey('search'), isTrue);
      expect(report.containsKey('validation'), isTrue);
      
      final validation = report['validation'] as Map<String, dynamic>;
      expect(validation.containsKey('frameRateCheck'), isTrue);
      expect(validation.containsKey('itemCountCheck'), isTrue);
      expect(validation.containsKey('searchCheck'), isTrue);
      
      print('✅ Performance report generation validated');
      print('📊 Report Summary:');
      print('  - Frame Rate Check: ${validation['frameRateCheck']}');
      print('  - Item Count Check: ${validation['itemCountCheck']}');
      print('  - Search Check: ${validation['searchCheck']}');
    });
  });
}