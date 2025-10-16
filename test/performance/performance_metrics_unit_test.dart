import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/models/performance_metrics.dart';

/// Unit tests for PerformanceMetrics calculations and validation
void main() {
  group('PerformanceMetrics Unit Tests', () {
    group('Constructor and Factory Methods', () {
      test('should create PerformanceMetrics with all required fields', () {
        final timestamp = DateTime.now();
        final deviceMetrics = {'processor': 'Snapdragon 888', 'ram': 8};
        
        final metrics = PerformanceMetrics(
          startupTimeMs: 1500.0,
          frameSkips: 5,
          memoryUsageMB: 95.0,
          apiResponseTimeMs: 800.0,
          frameRate: 58.5,
          batteryDrainPerHour: 4.2,
          timestamp: timestamp,
          deviceMetrics: deviceMetrics,
        );
        
        expect(metrics.startupTimeMs, equals(1500.0));
        expect(metrics.frameSkips, equals(5));
        expect(metrics.memoryUsageMB, equals(95.0));
        expect(metrics.apiResponseTimeMs, equals(800.0));
        expect(metrics.frameRate, equals(58.5));
        expect(metrics.batteryDrainPerHour, equals(4.2));
        expect(metrics.timestamp, equals(timestamp));
        expect(metrics.deviceMetrics, equals(deviceMetrics));
      });
      
      test('should create PerformanceMetrics.now with current timestamp', () {
        final beforeCreation = DateTime.now();
        
        final metrics = PerformanceMetrics.now(
          startupTimeMs: 1200.0,
          frameSkips: 2,
          memoryUsageMB: 80.0,
          apiResponseTimeMs: 600.0,
          frameRate: 60.0,
          batteryDrainPerHour: 3.5,
        );
        
        final afterCreation = DateTime.now();
        
        expect(metrics.startupTimeMs, equals(1200.0));
        expect(metrics.timestamp.isAfter(beforeCreation) || 
               metrics.timestamp.isAtSameMomentAs(beforeCreation), isTrue);
        expect(metrics.timestamp.isBefore(afterCreation) || 
               metrics.timestamp.isAtSameMomentAs(afterCreation), isTrue);
        expect(metrics.deviceMetrics, isEmpty);
      });
    });
    
    group('Requirement Validation', () {
      test('meetsStartupRequirement should validate < 2000ms', () {
        final fastStartup = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 0,
          memoryUsageMB: 80.0,
          apiResponseTimeMs: 500.0,
          frameRate: 60.0,
          batteryDrainPerHour: 3.0,
        );
        
        final slowStartup = PerformanceMetrics.now(
          startupTimeMs: 2500.0,
          frameSkips: 0,
          memoryUsageMB: 80.0,
          apiResponseTimeMs: 500.0,
          frameRate: 60.0,
          batteryDrainPerHour: 3.0,
        );
        
        expect(fastStartup.meetsStartupRequirement, isTrue);
        expect(slowStartup.meetsStartupRequirement, isFalse);
      });
      
      test('meetsFrameRateRequirement should validate >= 60fps', () {
        final goodFrameRate = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 0,
          memoryUsageMB: 80.0,
          apiResponseTimeMs: 500.0,
          frameRate: 60.0,
          batteryDrainPerHour: 3.0,
        );
        
        final poorFrameRate = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 0,
          memoryUsageMB: 80.0,
          apiResponseTimeMs: 500.0,
          frameRate: 45.0,
          batteryDrainPerHour: 3.0,
        );
        
        expect(goodFrameRate.meetsFrameRateRequirement, isTrue);
        expect(poorFrameRate.meetsFrameRateRequirement, isFalse);
      });
      
      test('meetsMemoryRequirement should validate < 120MB', () {
        final lowMemory = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 0,
          memoryUsageMB: 95.0,
          apiResponseTimeMs: 500.0,
          frameRate: 60.0,
          batteryDrainPerHour: 3.0,
        );
        
        final highMemory = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 0,
          memoryUsageMB: 150.0,
          apiResponseTimeMs: 500.0,
          frameRate: 60.0,
          batteryDrainPerHour: 3.0,
        );
        
        expect(lowMemory.meetsMemoryRequirement, isTrue);
        expect(highMemory.meetsMemoryRequirement, isFalse);
      });
      
      test('meetsAPIRequirement should validate < 1000ms', () {
        final fastAPI = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 0,
          memoryUsageMB: 80.0,
          apiResponseTimeMs: 800.0,
          frameRate: 60.0,
          batteryDrainPerHour: 3.0,
        );
        
        final slowAPI = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 0,
          memoryUsageMB: 80.0,
          apiResponseTimeMs: 1500.0,
          frameRate: 60.0,
          batteryDrainPerHour: 3.0,
        );
        
        expect(fastAPI.meetsAPIRequirement, isTrue);
        expect(slowAPI.meetsAPIRequirement, isFalse);
      });
    });
    
    group('Health Status Calculation', () {
      test('should return excellent for all requirements met', () {
        final excellentMetrics = PerformanceMetrics.now(
          startupTimeMs: 1000.0,  // < 2000 ✓
          frameSkips: 0,
          memoryUsageMB: 80.0,    // < 120 ✓
          apiResponseTimeMs: 500.0, // < 1000 ✓
          frameRate: 60.0,        // >= 60 ✓
          batteryDrainPerHour: 3.0,
        );
        
        expect(excellentMetrics.healthStatus, equals(PerformanceHealth.excellent));
      });
      
      test('should return good for 3 requirements met', () {
        final goodMetrics = PerformanceMetrics.now(
          startupTimeMs: 1000.0,  // < 2000 ✓
          frameSkips: 0,
          memoryUsageMB: 80.0,    // < 120 ✓
          apiResponseTimeMs: 500.0, // < 1000 ✓
          frameRate: 45.0,        // >= 60 ✗
          batteryDrainPerHour: 3.0,
        );
        
        expect(goodMetrics.healthStatus, equals(PerformanceHealth.good));
      });
      
      test('should return fair for 2 requirements met', () {
        final fairMetrics = PerformanceMetrics.now(
          startupTimeMs: 1000.0,  // < 2000 ✓
          frameSkips: 0,
          memoryUsageMB: 150.0,   // < 120 ✗
          apiResponseTimeMs: 500.0, // < 1000 ✓
          frameRate: 45.0,        // >= 60 ✗
          batteryDrainPerHour: 3.0,
        );
        
        expect(fairMetrics.healthStatus, equals(PerformanceHealth.fair));
      });
      
      test('should return poor for 1 or fewer requirements met', () {
        final poorMetrics = PerformanceMetrics.now(
          startupTimeMs: 3000.0,  // < 2000 ✗
          frameSkips: 0,
          memoryUsageMB: 150.0,   // < 120 ✗
          apiResponseTimeMs: 1500.0, // < 1000 ✗
          frameRate: 45.0,        // >= 60 ✗
          batteryDrainPerHour: 3.0,
        );
        
        expect(poorMetrics.healthStatus, equals(PerformanceHealth.poor));
      });
    });
    
    group('Performance Score Calculation', () {
      test('should calculate perfect score for optimal metrics', () {
        final perfectMetrics = PerformanceMetrics.now(
          startupTimeMs: 500.0,   // Excellent (< 1000)
          frameSkips: 0,
          memoryUsageMB: 60.0,    // Excellent (< 80)
          apiResponseTimeMs: 300.0, // Excellent (< 500)
          frameRate: 60.0,        // Perfect (>= 60)
          batteryDrainPerHour: 2.0,
        );
        
        expect(perfectMetrics.performanceScore, equals(10.0));
      });
      
      test('should calculate weighted score correctly', () {
        final metrics = PerformanceMetrics.now(
          startupTimeMs: 1500.0,  // Good (1000-2000) = 8.0 * 0.25 = 2.0
          frameSkips: 0,
          memoryUsageMB: 100.0,   // Good (80-120) = 8.0 * 0.25 = 2.0
          apiResponseTimeMs: 750.0, // Good (500-1000) = 8.0 * 0.25 = 2.0
          frameRate: 55.0,        // Good (50-60) = 8.0 * 0.25 = 2.0
          batteryDrainPerHour: 4.0,
        );
        
        // Total should be 8.0 (all components score 8.0)
        expect(metrics.performanceScore, equals(8.0));
      });
      
      test('should handle poor performance metrics', () {
        final poorMetrics = PerformanceMetrics.now(
          startupTimeMs: 4000.0,  // Poor (> 3000) = 3.0 * 0.25 = 0.75
          frameSkips: 0,
          memoryUsageMB: 200.0,   // Poor (> 160) = 3.0 * 0.25 = 0.75
          apiResponseTimeMs: 3000.0, // Poor (> 2000) = 3.0 * 0.25 = 0.75
          frameRate: 30.0,        // Poor (< 40) = 3.0 * 0.25 = 0.75
          batteryDrainPerHour: 10.0,
        );
        
        // Total should be 3.0 (all components score 3.0)
        expect(poorMetrics.performanceScore, equals(3.0));
      });
      
      test('should clamp score between 0 and 10', () {
        // Test with extreme values that might cause score to go outside bounds
        final extremeMetrics = PerformanceMetrics.now(
          startupTimeMs: 0.1,     // Extremely fast
          frameSkips: 0,
          memoryUsageMB: 1.0,     // Extremely low memory
          apiResponseTimeMs: 1.0, // Extremely fast API
          frameRate: 120.0,       // Extremely high frame rate
          batteryDrainPerHour: 0.1,
        );
        
        expect(extremeMetrics.performanceScore, lessThanOrEqualTo(10.0));
        expect(extremeMetrics.performanceScore, greaterThanOrEqualTo(0.0));
      });
    });
    
    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        final timestamp = DateTime.parse('2023-10-15T10:30:00.000Z');
        final deviceMetrics = {'processor': 'Snapdragon 888', 'ram': 8};
        
        final metrics = PerformanceMetrics(
          startupTimeMs: 1500.0,
          frameSkips: 5,
          memoryUsageMB: 95.0,
          apiResponseTimeMs: 800.0,
          frameRate: 58.5,
          batteryDrainPerHour: 4.2,
          timestamp: timestamp,
          deviceMetrics: deviceMetrics,
        );
        
        final json = metrics.toJson();
        
        expect(json['startupTimeMs'], equals(1500.0));
        expect(json['frameSkips'], equals(5));
        expect(json['memoryUsageMB'], equals(95.0));
        expect(json['apiResponseTimeMs'], equals(800.0));
        expect(json['frameRate'], equals(58.5));
        expect(json['batteryDrainPerHour'], equals(4.2));
        expect(json['timestamp'], equals('2023-10-15T10:30:00.000Z'));
        expect(json['deviceMetrics'], equals(deviceMetrics));
        expect(json['performanceScore'], isA<double>());
        expect(json['healthStatus'], isA<String>());
      });
      
      test('should deserialize from JSON correctly', () {
        final json = {
          'startupTimeMs': 1500.0,
          'frameSkips': 5,
          'memoryUsageMB': 95.0,
          'apiResponseTimeMs': 800.0,
          'frameRate': 58.5,
          'batteryDrainPerHour': 4.2,
          'timestamp': '2023-10-15T10:30:00.000Z',
          'deviceMetrics': {'processor': 'Snapdragon 888', 'ram': 8},
        };
        
        final metrics = PerformanceMetrics.fromJson(json);
        
        expect(metrics.startupTimeMs, equals(1500.0));
        expect(metrics.frameSkips, equals(5));
        expect(metrics.memoryUsageMB, equals(95.0));
        expect(metrics.apiResponseTimeMs, equals(800.0));
        expect(metrics.frameRate, equals(58.5));
        expect(metrics.batteryDrainPerHour, equals(4.2));
        expect(metrics.timestamp, equals(DateTime.parse('2023-10-15T10:30:00.000Z')));
        expect(metrics.deviceMetrics, equals({'processor': 'Snapdragon 888', 'ram': 8}));
      });
      
      test('should handle missing deviceMetrics in JSON', () {
        final json = {
          'startupTimeMs': 1500.0,
          'frameSkips': 5,
          'memoryUsageMB': 95.0,
          'apiResponseTimeMs': 800.0,
          'frameRate': 58.5,
          'batteryDrainPerHour': 4.2,
          'timestamp': '2023-10-15T10:30:00.000Z',
        };
        
        final metrics = PerformanceMetrics.fromJson(json);
        expect(metrics.deviceMetrics, isEmpty);
      });
    });
    
    group('toString Method', () {
      test('should format toString correctly', () {
        final metrics = PerformanceMetrics.now(
          startupTimeMs: 1500.0,
          frameSkips: 5,
          memoryUsageMB: 95.0,
          apiResponseTimeMs: 800.0,
          frameRate: 58.5,
          batteryDrainPerHour: 4.2,
        );
        
        final string = metrics.toString();
        
        expect(string, contains('PerformanceMetrics('));
        expect(string, contains('startup: 1500.0ms'));
        expect(string, contains('fps: 58.5'));
        expect(string, contains('memory: 95.0MB'));
        expect(string, contains('api: 800.0ms'));
        expect(string, contains('score:'));
        expect(string, contains('/10'));
      });
    });
  });
  
  group('PerformanceHealth Enum', () {
    test('should have correct descriptions', () {
      expect(PerformanceHealth.excellent.description, 
             equals('Excellent - All performance requirements met'));
      expect(PerformanceHealth.good.description, 
             equals('Good - Most performance requirements met'));
      expect(PerformanceHealth.fair.description, 
             equals('Fair - Some performance issues detected'));
      expect(PerformanceHealth.poor.description, 
             equals('Poor - Significant performance issues'));
    });
    
    test('should have correct color indicators', () {
      expect(PerformanceHealth.excellent.colorIndicator, equals('GREEN'));
      expect(PerformanceHealth.good.colorIndicator, equals('LIGHT_GREEN'));
      expect(PerformanceHealth.fair.colorIndicator, equals('YELLOW'));
      expect(PerformanceHealth.poor.colorIndicator, equals('RED'));
    });
  });
}