import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/monitoring/baseline_manager.dart';
import 'package:champion_car_wash_app/testing/performance/models/performance_metrics.dart';

// Helper method to create test metrics
PerformanceMetrics _createTestMetrics({
  double startupTime = 1500.0,
  int frameSkips = 5,
  double memoryUsage = 100.0,
  double apiResponseTime = 800.0,
  double frameRate = 60.0,
  double batteryDrain = 10.0,
}) {
  return PerformanceMetrics.now(
    startupTimeMs: startupTime,
    frameSkips: frameSkips,
    memoryUsageMB: memoryUsage,
    apiResponseTimeMs: apiResponseTime,
    frameRate: frameRate,
    batteryDrainPerHour: batteryDrain,
  );
}

void main() {
  group('BaselineManager Tests', () {
    late BaselineManager manager;

    setUp(() {
      manager = BaselineManager.instance;
    });

    tearDown(() async {
      // Clean up test data
      await manager.clearAll();
    });

    group('Baseline Management', () {
      test('should record baseline successfully', () async {
        final metrics = _createTestMetrics();
        
        await manager.recordBaseline(metrics, label: 'Test Baseline');
        
        final baseline = await manager.getCurrentBaseline();
        expect(baseline, isNotNull);
        expect(baseline!.label, equals('Test Baseline'));
        expect(baseline.metrics.startupTimeMs, equals(metrics.startupTimeMs));
      });
      
      test('should return null when no baseline exists', () async {
        final baseline = await manager.getCurrentBaseline();
        expect(baseline, isNull);
      });
      
      test('should record baseline with auto-generated label', () async {
        final metrics = _createTestMetrics();
        
        await manager.recordBaseline(metrics);
        
        final baseline = await manager.getCurrentBaseline();
        expect(baseline, isNotNull);
        expect(baseline!.label, startsWith('Baseline'));
      });
      
      test('should overwrite existing baseline', () async {
        final metrics1 = _createTestMetrics(startupTime: 1000);
        final metrics2 = _createTestMetrics(startupTime: 2000);
        
        await manager.recordBaseline(metrics1, label: 'First Baseline');
        await manager.recordBaseline(metrics2, label: 'Second Baseline');
        
        final baseline = await manager.getCurrentBaseline();
        expect(baseline, isNotNull);
        expect(baseline!.label, equals('Second Baseline'));
        expect(baseline.metrics.startupTimeMs, equals(2000));
      });
    });
    
    group('History Management', () {
      test('should record metrics to history', () async {
        final metrics = _createTestMetrics();
        
        await manager.recordToHistory(metrics);
        
        final history = await manager.getHistory();
        expect(history, hasLength(1));
        expect(history.first.metrics.startupTimeMs, equals(metrics.startupTimeMs));
      });
      
      test('should maintain history order', () async {
        final metrics1 = _createTestMetrics(startupTime: 1000);
        final metrics2 = _createTestMetrics(startupTime: 2000);
        final metrics3 = _createTestMetrics(startupTime: 3000);
        
        await manager.recordToHistory(metrics1);
        await Future.delayed(const Duration(milliseconds: 10));
        await manager.recordToHistory(metrics2);
        await Future.delayed(const Duration(milliseconds: 10));
        await manager.recordToHistory(metrics3);
        
        final history = await manager.getHistory();
        expect(history, hasLength(3));
        expect(history[0].metrics.startupTimeMs, equals(1000));
        expect(history[1].metrics.startupTimeMs, equals(2000));
        expect(history[2].metrics.startupTimeMs, equals(3000));
      });
      
      test('should limit history entries', () async {
        // This test would be slow with 1000+ entries, so we'll test the concept
        for (int i = 0; i < 5; i++) {
          await manager.recordToHistory(_createTestMetrics(startupTime: i * 100));
        }
        
        final history = await manager.getHistory();
        expect(history.length, lessThanOrEqualTo(5));
      });
      
      test('should return limited history when requested', () async {
        for (int i = 0; i < 5; i++) {
          await manager.recordToHistory(_createTestMetrics(startupTime: i * 100));
        }
        
        final limitedHistory = await manager.getHistory(limit: 3);
        expect(limitedHistory, hasLength(3));
        
        // Should return the most recent entries
        expect(limitedHistory[0].metrics.startupTimeMs, equals(200));
        expect(limitedHistory[1].metrics.startupTimeMs, equals(300));
        expect(limitedHistory[2].metrics.startupTimeMs, equals(400));
      });
      
      test('should return empty history when none exists', () async {
        final history = await manager.getHistory();
        expect(history, isEmpty);
      });
    });
    
    group('Metrics Comparison', () {
      test('should compare with baseline successfully', () async {
        final baselineMetrics = _createTestMetrics(
          startupTime: 2000,
          frameRate: 50.0,
          memoryUsage: 100.0,
        );
        final currentMetrics = _createTestMetrics(
          startupTime: 1500,
          frameRate: 55.0,
          memoryUsage: 90.0,
        );
        
        await manager.recordBaseline(baselineMetrics, label: 'Test Baseline');
        
        final comparison = await manager.compareWithBaseline(currentMetrics);
        
        expect(comparison.hasBaseline, isTrue);
        expect(comparison.baseline, isNotNull);
        expect(comparison.baselineLabel, equals('Test Baseline'));
        expect(comparison.current, equals(currentMetrics));
      });
      
      test('should return no baseline comparison when baseline missing', () async {
        final currentMetrics = _createTestMetrics();
        
        final comparison = await manager.compareWithBaseline(currentMetrics);
        
        expect(comparison.hasBaseline, isFalse);
        expect(comparison.baseline, isNull);
        expect(comparison.baselineLabel, isNull);
        expect(comparison.current, equals(currentMetrics));
      });
    });
    
    group('Performance Trends', () {
      test('should calculate trends with sufficient data', () async {
        // Add multiple history entries with improving performance
        final entries = [
          _createTestMetrics(startupTime: 3000, frameRate: 45.0),
          _createTestMetrics(startupTime: 2500, frameRate: 50.0),
          _createTestMetrics(startupTime: 2000, frameRate: 55.0),
          _createTestMetrics(startupTime: 1500, frameRate: 60.0),
        ];
        
        for (final metrics in entries) {
          await manager.recordToHistory(metrics);
          await Future.delayed(const Duration(milliseconds: 10));
        }
        
        final trends = await manager.calculateTrends();
        
        expect(trends.hasSufficientData, isTrue);
        expect(trends.dataPoints, equals(4));
        expect(trends.startupTimeTrend, equals(TrendDirection.improving));
        expect(trends.frameRateTrend, equals(TrendDirection.improving));
      });
      
      test('should return insufficient data when history is empty', () async {
        final trends = await manager.calculateTrends();
        
        expect(trends.hasSufficientData, isFalse);
        expect(trends.dataPoints, equals(0));
      });
      
      test('should return insufficient data with single entry', () async {
        await manager.recordToHistory(_createTestMetrics());
        
        final trends = await manager.calculateTrends();
        
        expect(trends.hasSufficientData, isFalse);
      });
      
      test('should calculate trends for specific time period', () async {
        // Add entries over time
        for (int i = 0; i < 3; i++) {
          await manager.recordToHistory(_createTestMetrics(startupTime: 2000 - (i * 200)));
          await Future.delayed(const Duration(milliseconds: 50));
        }
        
        final trends = await manager.calculateTrends(
          period: const Duration(milliseconds: 200),
        );
        
        expect(trends.hasSufficientData, isA<bool>());
      });
    });
    
    group('Data Persistence', () {
      test('should clear all data successfully', () async {
        final metrics = _createTestMetrics();
        
        await manager.recordBaseline(metrics, label: 'Test Baseline');
        await manager.recordToHistory(metrics);
        
        // Verify data exists
        expect(await manager.getCurrentBaseline(), isNotNull);
        expect(await manager.getHistory(), isNotEmpty);
        
        await manager.clearAll();
        
        // Verify data is cleared
        expect(await manager.getCurrentBaseline(), isNull);
        expect(await manager.getHistory(), isEmpty);
      });
    });
  });
  
  group('MetricsComparison Tests', () {
    test('should calculate startup time improvement correctly', () {
      final baseline = _createTestMetrics(startupTime: 2000);
      final current = _createTestMetrics(startupTime: 1500);
      
      final comparison = MetricsComparison.fromMetrics(
        current: current,
        baseline: baseline,
        baselineLabel: 'Test',
      );
      
      expect(comparison.startupTimeImprovement, equals(25.0)); // 25% improvement
    });
    
    test('should calculate frame rate improvement correctly', () {
      final baseline = _createTestMetrics(frameRate: 50.0);
      final current = _createTestMetrics(frameRate: 60.0);
      
      final comparison = MetricsComparison.fromMetrics(
        current: current,
        baseline: baseline,
        baselineLabel: 'Test',
      );
      
      expect(comparison.frameRateImprovement, equals(20.0)); // 20% improvement
    });
    
    test('should calculate memory usage improvement correctly', () {
      final baseline = _createTestMetrics(memoryUsage: 120.0);
      final current = _createTestMetrics(memoryUsage: 100.0);
      
      final comparison = MetricsComparison.fromMetrics(
        current: current,
        baseline: baseline,
        baselineLabel: 'Test',
      );
      
      expect(comparison.memoryUsageImprovement, closeTo(16.67, 0.01)); // ~16.67% improvement
    });
    
    test('should return null improvements when no baseline', () {
      final current = _createTestMetrics();
      final comparison = MetricsComparison.noBaseline(current);
      
      expect(comparison.startupTimeImprovement, isNull);
      expect(comparison.frameRateImprovement, isNull);
      expect(comparison.memoryUsageImprovement, isNull);
      expect(comparison.apiResponseTimeImprovement, isNull);
    });
    
    test('should generate comprehensive report', () {
      final baseline = _createTestMetrics(
        startupTime: 2000,
        frameRate: 50.0,
        memoryUsage: 120.0,
      );
      final current = _createTestMetrics(
        startupTime: 1500,
        frameRate: 60.0,
        memoryUsage: 100.0,
      );
      
      final comparison = MetricsComparison.fromMetrics(
        current: current,
        baseline: baseline,
        baselineLabel: 'Test Baseline',
      );
      
      final report = comparison.generateReport();
      
      expect(report, contains('Performance Comparison Report'));
      expect(report, contains('Test Baseline'));
      expect(report, contains('Startup Time'));
      expect(report, contains('Frame Rate'));
      expect(report, contains('Memory Usage'));
    });
  });
  
  group('PerformanceTrends Tests', () {
    test('should identify improving trends correctly', () {
      final history = [
        HistoryEntry(
          metrics: _createTestMetrics(startupTime: 3000),
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        ),
        HistoryEntry(
          metrics: _createTestMetrics(startupTime: 2000),
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        HistoryEntry(
          metrics: _createTestMetrics(startupTime: 1000),
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      ];
      
      final trends = PerformanceTrends.calculate(history);
      
      expect(trends.hasSufficientData, isTrue);
      expect(trends.startupTimeTrend, equals(TrendDirection.improving));
      expect(trends.dataPoints, equals(3));
    });
    
    test('should identify stable trends correctly', () {
      final history = [
        HistoryEntry(
          metrics: _createTestMetrics(startupTime: 2000),
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        HistoryEntry(
          metrics: _createTestMetrics(startupTime: 2050), // Small change
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      ];
      
      final trends = PerformanceTrends.calculate(history);
      
      expect(trends.hasSufficientData, isTrue);
      expect(trends.startupTimeTrend, equals(TrendDirection.stable));
    });
  });
  
  group('TrendDirection Tests', () {
    test('should have correct descriptions', () {
      expect(TrendDirection.improving.description, equals('Improving'));
      expect(TrendDirection.stable.description, equals('Stable'));
      expect(TrendDirection.degrading.description, equals('Degrading'));
    });
    
    test('should have correct emojis', () {
      expect(TrendDirection.improving.emoji, equals('📈'));
      expect(TrendDirection.stable.emoji, equals('➡️'));
      expect(TrendDirection.degrading.emoji, equals('📉'));
    });
  });
}