/// Champion Car Wash Performance Testing Framework
/// 
/// This library provides comprehensive performance testing capabilities
/// specifically designed for the Champion Car Wash Flutter app.
/// 
/// Features:
/// - Startup time validation (< 2 seconds with 35+ StatefulWidgets)
/// - Memory stability testing (30+ minute technician workflows)
/// - UI performance validation (60fps scrolling with 100+ booking items)
/// - API performance monitoring (Stripe NFC and caching efficiency)
/// - Device-specific testing protocols
/// - Real-time performance monitoring and alerting
/// 
/// Usage:
/// ```dart
/// import 'package:champion_car_wash_app/testing/performance/performance_testing.dart';
/// 
/// // Run all performance tests
/// final results = await PerformanceTestSuite.runAllTests();
/// 
/// // Run specific test
/// final startupResult = await PerformanceTestSuite.runStartupTests();
/// 
/// // Start monitoring
/// await PerformanceMonitor.startMonitoring();
/// final metrics = await PerformanceMonitor.getCurrentMetrics();
/// ```

library;

// Core framework exports
export 'core/performance_test_suite.dart';

// Model exports
export 'models/test_results.dart';
export 'models/performance_metrics.dart';

// Interface exports
export 'interfaces/performance_test_interface.dart';

// Base class exports
export 'base/base_performance_test.dart';

// Flutter integration exports
export 'flutter_integration/flutter_performance_binding.dart';

// Utility exports
export 'utils/test_helpers.dart';

import 'dart:async';
import 'core/performance_test_suite.dart';
import 'models/test_results.dart';
import 'models/performance_metrics.dart';
import 'flutter_integration/flutter_performance_binding.dart';
import 'utils/test_helpers.dart';

/// Main entry point for Champion Car Wash performance testing
class PerformanceTestRunner {
  static PerformanceTestRunner? _instance;
  static PerformanceTestRunner get instance => _instance ??= PerformanceTestRunner._();
  
  PerformanceTestRunner._();
  
  final FlutterPerformanceBinding _binding = FlutterPerformanceBinding.instance;
  bool _isInitialized = false;
  
  /// Initialize the performance testing framework
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _binding.startMonitoring();
    _isInitialized = true;
    
    PerformanceTestHelpers.logPerformanceInfo('Performance testing framework initialized');
  }
  
  /// Cleanup the performance testing framework
  Future<void> cleanup() async {
    if (!_isInitialized) return;
    
    await _binding.stopMonitoring();
    _isInitialized = false;
    
    PerformanceTestHelpers.logPerformanceInfo('Performance testing framework cleaned up');
  }
  
  /// Run all Champion Car Wash performance tests
  Future<List<TestResults>> runAllTests() async {
    await initialize();
    
    PerformanceTestHelpers.logPerformanceInfo('Starting comprehensive performance test suite');
    
    final results = <TestResults>[];
    
    try {
      // Run startup tests
      PerformanceTestHelpers.logPerformanceInfo('Running startup performance tests...');
      final startupResult = await PerformanceTestSuite.runStartupTests();
      results.add(startupResult);
      
      // Run memory tests
      PerformanceTestHelpers.logPerformanceInfo('Running memory stability tests...');
      final memoryResult = await PerformanceTestSuite.runMemoryTests();
      results.add(memoryResult);
      
      // Run UI performance tests
      PerformanceTestHelpers.logPerformanceInfo('Running UI performance tests...');
      final uiResult = await PerformanceTestSuite.runUIPerformanceTests();
      results.add(uiResult);
      
      // Run API performance tests
      PerformanceTestHelpers.logPerformanceInfo('Running API performance tests...');
      final apiResult = await PerformanceTestSuite.runAPITests();
      results.add(apiResult);
      
      // Calculate overall score
      final overallScore = await PerformanceTestSuite.calculatePerformanceScore(results);
      PerformanceTestHelpers.logPerformanceInfo('Overall performance score: ${overallScore.score}/10 (${overallScore.grade})');
      
    } catch (e) {
      PerformanceTestHelpers.logPerformanceInfo('Error during performance testing: $e');
      rethrow;
    }
    
    PerformanceTestHelpers.logPerformanceInfo('Performance test suite completed');
    return results;
  }
  
  /// Run Champion Car Wash specific workflow tests
  Future<List<TestResults>> runWorkflowTests() async {
    await initialize();
    
    final results = <TestResults>[];
    
    // These will be implemented in subsequent tasks
    PerformanceTestHelpers.logPerformanceInfo('Workflow-specific tests will be implemented in tasks 2.1-2.4');
    
    return results;
  }
  
  /// Get current performance metrics
  Future<PerformanceMetrics> getCurrentMetrics() async {
    await initialize();
    return await _binding.getCurrentMetrics();
  }
  
  /// Generate comprehensive performance report
  Future<String> generateReport() async {
    final results = await runAllTests();
    final metrics = await getCurrentMetrics();
    
    return PerformanceTestHelpers.generatePerformanceReport(results, metrics);
  }
  
  /// Validate Champion Car Wash performance requirements
  Future<bool> validateRequirements() async {
    final metrics = await getCurrentMetrics();
    return PerformanceTestHelpers.validateChampionCarWashRequirements(metrics);
  }
}

/// Quick access functions for common operations
class PerformanceTest {
  /// Quick startup test
  static Future<TestResults> startup() => PerformanceTestSuite.runStartupTests();
  
  /// Quick memory test
  static Future<TestResults> memory() => PerformanceTestSuite.runMemoryTests();
  
  /// Quick UI test
  static Future<TestResults> ui() => PerformanceTestSuite.runUIPerformanceTests();
  
  /// Quick API test
  static Future<TestResults> api() => PerformanceTestSuite.runAPITests();
  
  /// Run all tests
  static Future<List<TestResults>> all() => PerformanceTestRunner.instance.runAllTests();
  
  /// Get current metrics
  static Future<PerformanceMetrics> metrics() => PerformanceTestRunner.instance.getCurrentMetrics();
  
  /// Generate report
  static Future<String> report() => PerformanceTestRunner.instance.generateReport();
}