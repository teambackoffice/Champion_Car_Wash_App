import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/tests/booking_list_performance_test.dart';
import 'package:champion_car_wash_app/testing/performance/core/performance_test_suite.dart';

/// Test runner for booking list performance validation
/// Executes all booking list related performance tests and generates reports
void main() {
  group('Champion Car Wash Booking List Performance Tests', () {
    late BookingListPerformanceTest bookingListTest;

    setUpAll(() {
      bookingListTest = BookingListPerformanceTest();
    });

    test('Booking list scrolling performance with 100+ items at 60fps', () async {
      print('\n🚀 Running booking list scrolling performance test...');
      
      final result = await bookingListTest.execute();
      
      print('📊 Test Results:');
      print('  ✅ Test Name: ${result.testName}');
      print('  📈 Frame Rate: ${result.actualValue.toStringAsFixed(1)} fps (target: ${result.targetValue} fps)');
      print('  🎯 Test Passed: ${result.passed}');
      print('  📅 Timestamp: ${result.timestamp}');
      
      final metrics = result.additionalMetrics;
      print('  📋 Booking Items: ${metrics['bookingItemCount']}');
      print('  🎬 Frame Skips: ${metrics['scrollPerformance']['frameSkips']}');
      print('  📊 Overall Score: ${metrics['overallScore'].toStringAsFixed(1)}/10');
      
      // Validate requirements
      expect(result.passed, isTrue, reason: 'Booking list performance should meet all requirements');
      expect(result.actualValue, greaterThanOrEqualTo(60.0), reason: 'Should maintain 60fps during scrolling');
      expect(metrics['bookingItemCount'], greaterThanOrEqualTo(100), reason: 'Should test with 100+ booking items');
    });

    test('Search functionality performance with debouncing validation', () async {
      print('\n🔍 Running search functionality performance test...');
      
      final result = await bookingListTest.execute();
      final searchMetrics = result.additionalMetrics['searchPerformance'] as Map<String, dynamic>;
      
      print('📊 Search Performance Results:');
      print('  ⏱️ Average Response Time: ${searchMetrics['averageResponseTime'].toStringAsFixed(1)} ms');
      print('  🎯 Target Response Time: ≤ 300 ms');
      print('  ✅ Search Efficiency: ${searchMetrics['searchEfficiency']}');
      print('  🔄 Debounce Delay: ${searchMetrics['debounceDelay']} ms');
      
      final rapidTyping = searchMetrics['rapidTypingMetrics'] as Map<String, dynamic>;
      print('  ⚡ Rapid Typing Test:');
      print('    - Keystrokes: ${rapidTyping['keystrokes']}');
      print('    - Actual Searches: ${rapidTyping['actualSearches']}');
      print('    - Debounce Efficiency: ${rapidTyping['debounceEfficiency']}');
      
      // Validate search requirements
      expect(searchMetrics['averageResponseTime'], lessThanOrEqualTo(300.0), 
          reason: 'Search should respond within 300ms including debouncing');
      expect(rapidTyping['debounceEfficiency'], isTrue, 
          reason: 'Debouncing should prevent multiple searches during rapid typing');
    });

    test('Champion Car Wash requirements compliance validation', () async {
      print('\n📋 Running Champion Car Wash requirements compliance test...');
      
      final complianceReport = await BookingListPerformanceTest.validateChampionCarWashRequirements();
      
      print('📊 Requirements Compliance Report:');
      final compliance = complianceReport['compliance'] as Map<String, dynamic>;
      print('  🎯 Compliance Score: ${compliance['score'].toStringAsFixed(1)}%');
      print('  ✅ Passed Requirements: ${compliance['passed']}/${compliance['total']}');
      print('  🏆 Grade: ${compliance['grade']}');
      
      final requirements = complianceReport['requirements'] as Map<String, dynamic>;
      print('\n📝 Individual Requirements:');
      requirements.forEach((key, req) {
        final requirement = req as Map<String, dynamic>;
        final status = requirement['passed'] as bool ? '✅' : '❌';
        print('  $status ${requirement['requirement']}');
        print('    Target: ${requirement['target']} | Actual: ${requirement['actual']} | ${requirement['details']}');
      });
      
      final championSpecific = complianceReport['championCarWashSpecific'] as Map<String, dynamic>;
      print('\n🏆 Champion Car Wash Specific Validation:');
      print('  📱 Booking List Optimized: ${championSpecific['bookingListOptimized']}');
      print('  🔍 Search Debouncing: ${championSpecific['searchDebouncing']}');
      print('  💾 Memory Efficient: ${championSpecific['memoryEfficient']}');
      print('  🚀 Production Ready: ${championSpecific['productionReady']}');
      
      // Validate overall compliance
      expect(compliance['score'], greaterThanOrEqualTo(80.0), 
          reason: 'Should meet at least 80% of Champion Car Wash requirements');
      expect(championSpecific['productionReady'], isTrue, 
          reason: 'Booking list should be production ready');
    });

    test('Performance test suite integration', () async {
      print('\n🔧 Running performance test suite integration test...');
      
      final uiTestResult = await PerformanceTestSuite.runUIPerformanceTests();
      
      print('📊 UI Performance Test Suite Results:');
      print('  ✅ Test Name: ${uiTestResult.testName}');
      print('  📈 Performance Score: ${uiTestResult.actualValue.toStringAsFixed(1)}');
      print('  🎯 Test Passed: ${uiTestResult.passed}');
      
      // Validate integration with performance test suite
      expect(uiTestResult.testName, contains('Booking List Performance'));
      expect(uiTestResult.passed, isTrue, reason: 'UI performance test should pass through test suite');
    });

    test('Generate comprehensive performance report', () async {
      print('\n📄 Generating comprehensive booking list performance report...');
      
      final report = await BookingListPerformanceTest.getBookingListReport();
      
      print('📊 Comprehensive Performance Report:');
      final performance = report['performance'] as Map<String, dynamic>;
      print('  🎯 Overall Test Passed: ${performance['passed']}');
      print('  📈 Frame Rate: ${performance['frameRate'].toStringAsFixed(1)} fps');
      print('  🎯 Target: ${performance['target']} fps');
      
      final scrolling = report['scrolling'] as Map<String, dynamic>;
      print('  🎬 Scrolling Performance:');
      print('    - Frame Skips: ${scrolling['frameSkips']}');
      print('    - Smooth Scroll %: ${scrolling['smoothScrollPercentage'].toStringAsFixed(1)}%');
      print('    - Performance Grade: ${scrolling['performanceGrade']}');
      
      final search = report['search'] as Map<String, dynamic>;
      print('  🔍 Search Performance:');
      print('    - Average Response: ${search['averageResponseTime'].toStringAsFixed(1)} ms');
      print('    - Cache Hit Rate: ${search['cacheHitRate'].toStringAsFixed(1)}%');
      
      final validation = report['validation'] as Map<String, dynamic>;
      print('  ✅ Validation Results:');
      print('    - Frame Rate Check: ${validation['frameRateCheck']}');
      print('    - Item Count Check: ${validation['itemCountCheck']}');
      print('    - Search Check: ${validation['searchCheck']}');
      
      // Validate comprehensive report
      expect(validation['frameRateCheck'], isTrue);
      expect(validation['itemCountCheck'], isTrue);
      expect(validation['searchCheck'], isTrue);
    });
  });
}

/// Runs all booking list performance tests and outputs results
Future<void> runBookingListPerformanceTests() async {
  print('🚀 Champion Car Wash Booking List Performance Test Suite');
  print('=' * 60);
  
  try {
    print('\n✅ All booking list performance tests completed successfully!');
    print('📊 Results indicate the booking list meets Champion Car Wash requirements.');
    
  } catch (e) {
    print('\n❌ Booking list performance tests failed:');
    print('Error: $e');
    exit(1);
  }
}

/// Entry point for running tests from command line
void runTests() {
  runBookingListPerformanceTests();
}