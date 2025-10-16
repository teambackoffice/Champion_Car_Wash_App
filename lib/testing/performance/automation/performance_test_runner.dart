import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../core/performance_test_suite.dart';
import '../models/test_results.dart';
import '../monitoring/performance_monitor.dart';

/// Automated performance test runner for Champion Car Wash app
/// Provides command-line interface and automated test execution capabilities
class AutomatedPerformanceTestRunner {
  static const String _version = '1.0.0';
  
  final Map<String, Function> _testSuites = {
    'startup': () => PerformanceTestSuite.runStartupTests(),
    'memory': () => PerformanceTestSuite.runMemoryTests(),
    'ui': () => PerformanceTestSuite.runUIPerformanceTests(),
    'api': () => PerformanceTestSuite.runAPITests(),
    'all': () => PerformanceTestSuite.runAllTests(),
  };
  
  /// Run performance tests based on command-line arguments
  Future<void> runFromCommandLine(List<String> args) async {
    try {
      final config = _parseArguments(args);
      
      if (config['help'] == true) {
        _printHelp();
        return;
      }
      
      if (config['version'] == true) {
        print('Champion Car Wash Performance Test Runner v$_version');
        return;
      }
      
      await _executeTests(config);
      
    } catch (e) {
      print('Error: $e');
      exit(1);
    }
  }
  
  /// Execute performance tests based on configuration
  Future<void> _executeTests(Map<String, dynamic> config) async {
    final testSuite = config['suite'] as String? ?? 'all';
    final outputFile = config['output'] as String?;
    final verbose = config['verbose'] as bool? ?? false;

    if (verbose) {
      print('Starting Champion Car Wash performance tests...');
      print('Test suite: $testSuite');
      if (outputFile != null) {
        print('Output file: $outputFile');
      }
    }
    
    final startTime = DateTime.now();
    List<TestResults> results = [];
    
    try {
      // Initialize performance monitoring
      PerformanceMonitor.instance.startMonitoring();

      if (testSuite == 'all') {
        results = await PerformanceTestSuite.runAllTests();
      } else if (_testSuites.containsKey(testSuite)) {
        final testFunction = _testSuites[testSuite]!;
        final result = await testFunction();

        if (result is TestResults) {
          results = [result];
        } else if (result is List<TestResults>) {
          results = result;
        }
      } else {
        throw ArgumentError('Unknown test suite: $testSuite');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Generate and display results
      await _processResults(results, duration, config);

    } finally {
      PerformanceMonitor.instance.stopMonitoring();
    }
  }
  
  /// Process and output test results
  Future<void> _processResults(
    List<TestResults> results,
    Duration duration,
    Map<String, dynamic> config,
  ) async {
    final verbose = config['verbose'] as bool? ?? false;
    final jsonOutput = config['json'] as bool? ?? false;
    final outputFile = config['output'] as String?;
    
    // Calculate overall score
    final overallScore = await PerformanceTestSuite.calculatePerformanceScore(results);
    
    // Generate report
    String report;
    if (jsonOutput) {
      report = _generateJsonReport(results, overallScore, duration);
    } else {
      report = _generateTextReport(results, overallScore, duration, verbose);
    }
    
    // Output results
    if (outputFile != null) {
      await File(outputFile).writeAsString(report);
      print('Results written to: $outputFile');
    } else {
      print(report);
    }
    
    // Exit with appropriate code
    final allPassed = results.every((result) => result.passed);
    exit(allPassed ? 0 : 1);
  }
  
  /// Parse command-line arguments
  Map<String, dynamic> _parseArguments(List<String> args) {
    final config = <String, dynamic>{};
    
    for (int i = 0; i < args.length; i++) {
      final arg = args[i];
      
      switch (arg) {
        case '--help':
        case '-h':
          config['help'] = true;
          break;
        case '--version':
        case '-v':
          config['version'] = true;
          break;
        case '--suite':
        case '-s':
          if (i + 1 < args.length) {
            config['suite'] = args[++i];
          } else {
            throw ArgumentError('--suite requires a value');
          }
          break;
        case '--output':
        case '-o':
          if (i + 1 < args.length) {
            config['output'] = args[++i];
          } else {
            throw ArgumentError('--output requires a value');
          }
          break;
        case '--verbose':
          config['verbose'] = true;
          break;
        case '--json':
          config['json'] = true;
          break;
        default:
          if (arg.startsWith('-')) {
            throw ArgumentError('Unknown option: $arg');
          }
      }
    }
    
    return config;
  }
  
  /// Generate JSON format report
  String _generateJsonReport(
    List<TestResults> results,
    OverallScore overallScore,
    Duration duration,
  ) {
    final report = {
      'timestamp': DateTime.now().toIso8601String(),
      'duration_ms': duration.inMilliseconds,
      'overall_score': {
        'score': overallScore.score,
        'grade': overallScore.grade,
        'breakdown': overallScore.breakdown,
      },
      'test_results': results.map((result) => {
        'test_name': result.testName,
        'passed': result.passed,
        'actual_value': result.actualValue,
        'target_value': result.targetValue,
        'unit': result.unit,
        'timestamp': result.timestamp.toIso8601String(),
        'additional_metrics': result.additionalMetrics,
      }).toList(),
    };
    
    return const JsonEncoder.withIndent('  ').convert(report);
  }
  
  /// Generate text format report
  String _generateTextReport(
    List<TestResults> results,
    OverallScore overallScore,
    Duration duration,
    bool verbose,
  ) {
    final buffer = StringBuffer();
    
    buffer.writeln('Champion Car Wash Performance Test Results');
    buffer.writeln('=' * 50);
    buffer.writeln('Test Duration: ${duration.inSeconds}s');
    buffer.writeln('Overall Score: ${overallScore.score.toStringAsFixed(1)}/10 (${overallScore.grade})');
    buffer.writeln();
    
    // Test results summary
    final passed = results.where((r) => r.passed).length;
    final total = results.length;
    buffer.writeln('Tests Passed: $passed/$total');
    buffer.writeln();
    
    // Individual test results
    for (final result in results) {
      final status = result.passed ? '✓ PASS' : '✗ FAIL';
      buffer.writeln('$status ${result.testName}');
      
      if (verbose || !result.passed) {
        buffer.writeln('  Target: ${result.targetValue} ${result.unit}');
        buffer.writeln('  Actual: ${result.actualValue} ${result.unit}');
        
        if (result.additionalMetrics.isNotEmpty) {
          buffer.writeln('  Additional metrics:');
          result.additionalMetrics.forEach((key, value) {
            buffer.writeln('    $key: $value');
          });
        }
      }
      buffer.writeln();
    }
    
    // Performance breakdown
    if (verbose && overallScore.breakdown.isNotEmpty) {
      buffer.writeln('Performance Breakdown:');
      overallScore.breakdown.forEach((test, score) {
        buffer.writeln('  $test: ${score.toStringAsFixed(1)}/10');
      });
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  /// Print help information
  void _printHelp() {
    print('''
Champion Car Wash Performance Test Runner v$_version

Usage: dart run performance_test_runner.dart [options]

Options:
  -h, --help              Show this help message
  -v, --version           Show version information
  -s, --suite <suite>     Run specific test suite (startup, memory, ui, api, all)
  -o, --output <file>     Write results to file
  --verbose               Show detailed output
  --json                  Output results in JSON format

Test Suites:
  startup                 Startup time validation (< 2 seconds)
  memory                  Memory stability tests (30+ minutes)
  ui                      UI performance tests (60fps scrolling)
  api                     API performance tests (payment processing)
  all                     Run all test suites (default)

Examples:
  dart run performance_test_runner.dart
  dart run performance_test_runner.dart --suite startup --verbose
  dart run performance_test_runner.dart --output results.json --json
  dart run performance_test_runner.dart --suite all --output report.txt --verbose
''');
  }
}

/// Entry point for automated performance testing
Future<void> main(List<String> args) async {
  final runner = AutomatedPerformanceTestRunner();
  await runner.runFromCommandLine(args);
}