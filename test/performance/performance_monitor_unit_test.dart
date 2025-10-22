import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/monitoring/performance_monitor.dart';
import 'package:champion_car_wash_app/testing/performance/models/performance_metrics.dart';

void main() {
  group('PerformanceMonitor Tests', () {
    late PerformanceMonitor monitor;

    setUp(() {
      monitor = PerformanceMonitor.instance;
      // Ensure monitor is stopped before each test
      monitor.stopMonitoring();
    });

    tearDown(() {
      monitor.stopMonitoring();
      monitor.dispose();
    });

    group('Monitoring State Management', () {
      test('should start monitoring successfully', () {
        expect(monitor.isMonitoring, isFalse);

        monitor.startMonitoring();

        expect(monitor.isMonitoring, isTrue);
      });

      test('should stop monitoring successfully', () {
        monitor.startMonitoring();
        expect(monitor.isMonitoring, isTrue);

        monitor.stopMonitoring();

        expect(monitor.isMonitoring, isFalse);
      });

      test('should not start monitoring twice', () {
        monitor.startMonitoring();
        expect(monitor.isMonitoring, isTrue);

        // Starting again should not cause issues
        monitor.startMonitoring();
        expect(monitor.isMonitoring, isTrue);
      });

      test('should handle stopping when not monitoring', () {
        expect(monitor.isMonitoring, isFalse);

        // Should not throw exception
        expect(() => monitor.stopMonitoring(), returnsNormally);
        expect(monitor.isMonitoring, isFalse);
      });
    });

    group('Metrics Collection', () {
      test('should return valid current metrics', () {
        monitor.startMonitoring();

        final metrics = monitor.getCurrentMetrics();

        expect(metrics, isA<PerformanceMetrics>());
        expect(metrics.startupTimeMs, greaterThanOrEqualTo(0));
        expect(metrics.frameRate, greaterThanOrEqualTo(0));
        expect(metrics.memoryUsageMB, greaterThanOrEqualTo(0));
        expect(metrics.apiResponseTimeMs, greaterThanOrEqualTo(0));
        expect(metrics.frameSkips, greaterThanOrEqualTo(0));
        expect(metrics.batteryDrainPerHour, greaterThanOrEqualTo(0));
        expect(metrics.timestamp, isA<DateTime>());
      });

      test('should record API response times', () {
        monitor.startMonitoring();

        monitor.recordApiResponseTime(500.0);
        monitor.recordApiResponseTime(750.0);
        monitor.recordApiResponseTime(300.0);

        final metrics = monitor.getCurrentMetrics();

        // Should have recorded the API response times
        expect(metrics.apiResponseTimeMs, greaterThan(0));
      });

      test('should record frame skips', () {
        monitor.startMonitoring();

        monitor.recordFrameSkip();
        monitor.recordFrameSkip();

        final metrics = monitor.getCurrentMetrics();

        expect(metrics.frameSkips, equals(2));
      });

      test('should update battery level', () {
        monitor.startMonitoring();

        monitor.updateBatteryLevel(85.5);

        // Battery level should be updated internally
        // This is tested indirectly through battery drain calculation
        expect(() => monitor.updateBatteryLevel(85.5), returnsNormally);
      });
    });

    group('Alert System', () {
      test('should set custom alert thresholds', () {
        final customThresholds = AlertThresholds.strict();

        monitor.setAlertThresholds(customThresholds);

        expect(monitor.thresholds, equals(customThresholds));
      });

      test('should use default Champion Car Wash thresholds', () {
        final thresholds = monitor.thresholds;

        expect(thresholds.maxStartupTimeMs, equals(2000));
        expect(thresholds.minFrameRate, equals(55.0));
        expect(thresholds.maxMemoryUsageMB, equals(120.0));
        expect(thresholds.maxApiResponseTimeMs, equals(1000));
      });

      test('should trigger API response time alert', () async {
        monitor.startMonitoring();

        final alerts = <AlertEvent>[];
        monitor.alertStream.listen((alert) => alerts.add(alert));

        // Record slow API response
        monitor.recordApiResponseTime(2000.0); // Above 1000ms threshold

        // Give some time for alert processing
        await Future.delayed(const Duration(milliseconds: 100));

        expect(alerts, isNotEmpty);
        expect(alerts.first.level, equals(AlertLevel.YELLOW));
        expect(alerts.first.metric, equals('API Response Time'));
      });

      test('should trigger frame skip alert', () async {
        monitor.startMonitoring();

        final alerts = <AlertEvent>[];
        monitor.alertStream.listen((alert) => alerts.add(alert));

        // Record excessive frame skips
        for (int i = 0; i < 15; i++) {
          monitor.recordFrameSkip();
        }

        await Future.delayed(const Duration(milliseconds: 100));

        expect(alerts, isNotEmpty);
        expect(alerts.any((alert) => alert.metric == 'Frame Skips'), isTrue);
      });
    });

    group('Metrics Stream', () {
      test('should provide metrics stream', () {
        expect(monitor.metricsStream, isA<Stream<PerformanceMetrics>>());
      });

      test('should provide alert stream', () {
        expect(monitor.alertStream, isA<Stream<AlertEvent>>());
      });

      test('should emit metrics when monitoring', () async {
        monitor.startMonitoring(interval: const Duration(milliseconds: 100));

        final metrics = <PerformanceMetrics>[];
        final subscription = monitor.metricsStream.listen((metric) {
          metrics.add(metric);
        });

        // Wait for a few metrics to be emitted
        await Future.delayed(const Duration(milliseconds: 350));

        expect(metrics.length, greaterThan(0));

        await subscription.cancel();
      });
    });
  });

  group('AlertEvent Tests', () {
    test('should create alert event correctly', () {
      final alert = AlertEvent(
        level: AlertLevel.RED,
        metric: 'Test Metric',
        currentValue: 100.0,
        threshold: 50.0,
        message: 'Test alert message',
        timestamp: DateTime.now(),
      );

      expect(alert.level, equals(AlertLevel.RED));
      expect(alert.metric, equals('Test Metric'));
      expect(alert.currentValue, equals(100.0));
      expect(alert.threshold, equals(50.0));
      expect(alert.message, equals('Test alert message'));
      expect(alert.timestamp, isA<DateTime>());
    });

    test('should have correct toString representation', () {
      final alert = AlertEvent(
        level: AlertLevel.YELLOW,
        metric: 'Memory',
        currentValue: 150.0,
        threshold: 120.0,
        message: 'High memory usage',
        timestamp: DateTime.now(),
      );

      final string = alert.toString();
      expect(string, contains('AlertEvent'));
      expect(string, contains('YELLOW'));
      expect(string, contains('High memory usage'));
    });
  });

  group('AlertLevel Tests', () {
    test('should have correct descriptions', () {
      expect(
        AlertLevel.RED.description,
        equals('Critical - Immediate action required'),
      );
      expect(
        AlertLevel.YELLOW.description,
        equals('Warning - Monitor closely'),
      );
      expect(
        AlertLevel.GREEN.description,
        equals('Good - Performance is optimal'),
      );
    });
  });

  group('AlertThresholds Tests', () {
    test('should create Champion Car Wash defaults correctly', () {
      final thresholds = AlertThresholds.championCarWashDefaults();

      expect(thresholds.maxStartupTimeMs, equals(2000));
      expect(thresholds.minFrameRate, equals(55.0));
      expect(thresholds.maxFrameSkips, equals(10));
      expect(thresholds.maxMemoryUsageMB, equals(120.0));
      expect(thresholds.maxApiResponseTimeMs, equals(1000));
      expect(thresholds.maxBatteryDrainPerHour, equals(15.0));
    });

    test('should create strict thresholds correctly', () {
      final thresholds = AlertThresholds.strict();

      expect(thresholds.maxStartupTimeMs, equals(1000));
      expect(thresholds.minFrameRate, equals(58.0));
      expect(thresholds.maxFrameSkips, equals(5));
      expect(thresholds.maxMemoryUsageMB, equals(80.0));
      expect(thresholds.maxApiResponseTimeMs, equals(500));
      expect(thresholds.maxBatteryDrainPerHour, equals(10.0));
    });

    test('should create relaxed thresholds correctly', () {
      final thresholds = AlertThresholds.relaxed();

      expect(thresholds.maxStartupTimeMs, equals(3000));
      expect(thresholds.minFrameRate, equals(45.0));
      expect(thresholds.maxFrameSkips, equals(20));
      expect(thresholds.maxMemoryUsageMB, equals(150.0));
      expect(thresholds.maxApiResponseTimeMs, equals(2000));
      expect(thresholds.maxBatteryDrainPerHour, equals(20.0));
    });
  });
}
