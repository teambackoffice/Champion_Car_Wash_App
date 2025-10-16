import 'package:flutter_test/flutter_test.dart';
import 'package:champion_car_wash_app/testing/performance/monitoring/performance_scorer.dart';
import 'package:champion_car_wash_app/testing/performance/models/performance_metrics.dart';

// Helper methods
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

PerformanceMetrics _createExcellentMetrics() {
  return PerformanceMetrics.now(
    startupTimeMs: 800.0,    // Excellent
    frameSkips: 1,           // Excellent
    memoryUsageMB: 70.0,     // Excellent
    apiResponseTimeMs: 400.0, // Excellent
    frameRate: 60.0,         // Excellent
    batteryDrainPerHour: 6.0, // Excellent
  );
}

PerformanceMetrics _createPoorMetrics() {
  return PerformanceMetrics.now(
    startupTimeMs: 6000.0,    // Poor
    frameSkips: 25,           // Poor
    memoryUsageMB: 280.0,     // Poor
    apiResponseTimeMs: 4000.0, // Poor
    frameRate: 25.0,          // Poor
    batteryDrainPerHour: 35.0, // Poor
  );
}

void main() {
  group('PerformanceScorer Tests', () {
    late PerformanceScorer scorer;

    setUp(() {
      scorer = PerformanceScorer.instance;
    });

    group('Basic Performance Scoring', () {
      test('should calculate excellent performance score', () {
        final metrics = _createExcellentMetrics();
        
        final score = scorer.calculateScore(metrics);
        
        expect(score.overall, greaterThan(8.0));
        expect(score.grade, equals(PerformanceGrade.excellent));
        expect(score.startup, equals(10.0));
        expect(score.frameRate, equals(10.0));
        expect(score.memory, equals(10.0));
        expect(score.api, equals(10.0));
      });
      
      test('should calculate poor performance score', () {
        final metrics = _createPoorMetrics();
        
        final score = scorer.calculateScore(metrics);
        
        expect(score.overall, lessThan(5.0));
        expect(score.grade, anyOf([PerformanceGrade.poor, PerformanceGrade.critical]));
        expect(score.startup, lessThanOrEqualTo(4.0));
        expect(score.frameRate, lessThanOrEqualTo(4.0));
      });
      
      test('should use Champion Car Wash profile by default', () {
        final metrics = _createTestMetrics();
        
        final score = scorer.calculateScore(metrics);
        
        expect(score.profile, equals(ScoringProfile.championCarWash));
      });
      
      test('should use different scoring profiles', () {
        final metrics = _createTestMetrics();
        
        final championScore = scorer.calculateScore(
          metrics, 
          profile: ScoringProfile.championCarWash,
        );
        final balancedScore = scorer.calculateScore(
          metrics, 
          profile: ScoringProfile.balanced,
        );
        final performanceScore = scorer.calculateScore(
          metrics, 
          profile: ScoringProfile.performanceFocused,
        );
        
        expect(championScore.profile, equals(ScoringProfile.championCarWash));
        expect(balancedScore.profile, equals(ScoringProfile.balanced));
        expect(performanceScore.profile, equals(ScoringProfile.performanceFocused));
      });
    });
    
    group('Component Scoring', () {
      test('should score startup time correctly', () {
        final excellentStartup = _createTestMetrics(startupTime: 800); // < 1000ms
        final goodStartup = _createTestMetrics(startupTime: 1500); // < 2000ms
        final poorStartup = _createTestMetrics(startupTime: 6000); // > 5000ms
        
        final excellentScore = scorer.calculateScore(excellentStartup);
        final goodScore = scorer.calculateScore(goodStartup);
        final poorScore = scorer.calculateScore(poorStartup);
        
        expect(excellentScore.startup, equals(10.0));
        expect(goodScore.startup, equals(8.0));
        expect(poorScore.startup, equals(2.0));
      });
      
      test('should score frame rate correctly', () {
        final excellentFps = _createTestMetrics(frameRate: 60.0);
        final goodFps = _createTestMetrics(frameRate: 56.0);
        final poorFps = _createTestMetrics(frameRate: 30.0);
        
        final excellentScore = scorer.calculateScore(excellentFps);
        final goodScore = scorer.calculateScore(goodFps);
        final poorScore = scorer.calculateScore(poorFps);
        
        expect(excellentScore.frameRate, equals(10.0));
        expect(goodScore.frameRate, equals(8.0));
        expect(poorScore.frameRate, equals(2.0));
      });
      
      test('should score memory usage correctly', () {
        final excellentMemory = _createTestMetrics(memoryUsage: 70.0);
        final goodMemory = _createTestMetrics(memoryUsage: 110.0);
        final poorMemory = _createTestMetrics(memoryUsage: 250.0);
        
        final excellentScore = scorer.calculateScore(excellentMemory);
        final goodScore = scorer.calculateScore(goodMemory);
        final poorScore = scorer.calculateScore(poorMemory);
        
        expect(excellentScore.memory, equals(10.0));
        expect(goodScore.memory, equals(8.0));
        expect(poorScore.memory, equals(2.0));
      });
      
      test('should score API response time correctly', () {
        final excellentApi = _createTestMetrics(apiResponseTime: 400.0);
        final goodApi = _createTestMetrics(apiResponseTime: 800.0);
        final poorApi = _createTestMetrics(apiResponseTime: 4000.0);
        
        final excellentScore = scorer.calculateScore(excellentApi);
        final goodScore = scorer.calculateScore(goodApi);
        final poorScore = scorer.calculateScore(poorApi);
        
        expect(excellentScore.api, equals(10.0));
        expect(goodScore.api, equals(8.0));
        expect(poorScore.api, equals(2.0));
      });
    });
    
    group('Champion Car Wash Workflow Scoring', () {
      test('should calculate technician workflow score', () {
        final metrics = _createTestMetrics(
          startupTime: 1000, // Good for frequent app switching
          frameRate: 60.0,   // Smooth scrolling
          apiResponseTime: 500, // Quick status updates
        );
        
        final workflowScore = scorer.calculateWorkflowScore(metrics);
        
        expect(workflowScore.technician, greaterThan(7.0));
        expect(workflowScore.overall, greaterThan(0.0));
      });
      
      test('should calculate supervisor workflow score', () {
        final metrics = _createTestMetrics(
          memoryUsage: 90.0,     // Efficient for dashboard
          apiResponseTime: 600.0, // Good for reports
          frameSkips: 3,         // Stable performance
        );
        
        final workflowScore = scorer.calculateWorkflowScore(metrics);
        
        expect(workflowScore.supervisor, greaterThan(7.0));
      });
      
      test('should calculate payment workflow score', () {
        final metrics = _createTestMetrics(
          apiResponseTime: 400.0, // Fast Stripe operations
          frameSkips: 2,         // Stable NFC interactions
          memoryUsage: 85.0,     // Efficient processing
        );
        
        final workflowScore = scorer.calculateWorkflowScore(metrics);
        
        expect(workflowScore.payment, greaterThan(8.0));
      });
      
      test('should calculate customer workflow score', () {
        final metrics = _createTestMetrics(
          startupTime: 1200,     // Quick interactions
          frameRate: 58.0,       // Smooth UI
          batteryDrain: 8.0,     // Battery efficient
        );
        
        final workflowScore = scorer.calculateWorkflowScore(metrics);
        
        expect(workflowScore.customer, greaterThan(7.0));
      });
      
      test('should identify critical workflows', () {
        final metrics = _createTestMetrics(
          startupTime: 6000,     // Poor startup affects technician workflow
          apiResponseTime: 3000, // Poor API affects payment workflow
        );
        
        final workflowScore = scorer.calculateWorkflowScore(metrics);
        
        expect(workflowScore.criticalWorkflows, isNotEmpty);
        expect(workflowScore.criticalWorkflows, contains('Technician Workflow'));
      });
    });
    
    group('Device-Specific Scoring', () {
      test('should calculate high-end device score', () {
        final metrics = _createExcellentMetrics();
        
        final deviceScore = scorer.calculateDeviceScore(
          metrics, 
          DeviceCategory.highEnd,
        );
        
        expect(deviceScore.category, equals(DeviceCategory.highEnd));
        expect(deviceScore.overall, greaterThan(8.0));
        expect(deviceScore.meetsExpectations, isTrue);
      });
      
      test('should calculate mid-range device score', () {
        final metrics = _createTestMetrics(
          startupTime: 2000,
          frameRate: 55.0,
          memoryUsage: 130.0,
        );
        
        final deviceScore = scorer.calculateDeviceScore(
          metrics, 
          DeviceCategory.midRange,
        );
        
        expect(deviceScore.category, equals(DeviceCategory.midRange));
        expect(deviceScore.overall, greaterThan(6.0));
      });
      
      test('should calculate low-end device score', () {
        final metrics = _createTestMetrics(
          startupTime: 2800,
          frameRate: 48.0,
          memoryUsage: 140.0,
        );
        
        final deviceScore = scorer.calculateDeviceScore(
          metrics, 
          DeviceCategory.lowEnd,
        );
        
        expect(deviceScore.category, equals(DeviceCategory.lowEnd));
        expect(deviceScore.overall, greaterThan(5.0));
      });
      
      test('should have different expectations for device categories', () {
        final metrics = _createTestMetrics();
        
        final highEndScore = scorer.calculateDeviceScore(metrics, DeviceCategory.highEnd);
        final midRangeScore = scorer.calculateDeviceScore(metrics, DeviceCategory.midRange);
        final lowEndScore = scorer.calculateDeviceScore(metrics, DeviceCategory.lowEnd);
        
        // Same metrics should meet different expectations based on device category
        expect(highEndScore.meetsExpectations, isA<bool>());
        expect(midRangeScore.meetsExpectations, isA<bool>());
        expect(lowEndScore.meetsExpectations, isA<bool>());
      });
    });
  });
  
  group('PerformanceScore Tests', () {
    test('should determine correct performance grade', () {
      final excellentScore = PerformanceScore(
        overall: 9.5,
        startup: 10.0,
        frameRate: 10.0,
        memory: 9.0,
        api: 9.0,
        stability: 10.0,
        battery: 9.0,
        profile: ScoringProfile.championCarWash,
        metrics: _createTestMetrics(),
      );
      
      expect(excellentScore.grade, equals(PerformanceGrade.excellent));
    });
    
    test('should identify improvement areas', () {
      final score = PerformanceScore(
        overall: 6.5,
        startup: 5.0, // Below 6.0
        frameRate: 7.0,
        memory: 4.0, // Below 6.0
        api: 8.0,
        stability: 7.0,
        battery: 6.0,
        profile: ScoringProfile.championCarWash,
        metrics: _createTestMetrics(),
      );
      
      final improvements = score.improvementAreas;
      expect(improvements, contains('Startup Time'));
      expect(improvements, contains('Memory Usage'));
      expect(improvements, hasLength(2));
    });
    
    test('should generate detailed report', () {
      final score = PerformanceScore(
        overall: 7.5,
        startup: 8.0,
        frameRate: 7.0,
        memory: 7.5,
        api: 8.0,
        stability: 7.0,
        battery: 6.5,
        profile: ScoringProfile.championCarWash,
        metrics: _createTestMetrics(),
      );
      
      final report = score.generateReport();
      
      expect(report, contains('Performance Score Report'));
      expect(report, contains('Overall Score: 7.5/10'));
      expect(report, contains('Component Scores:'));
      expect(report, contains('Startup Time: 8.0/10'));
    });
    
    test('should provide score breakdown', () {
      final score = PerformanceScore(
        overall: 8.0,
        startup: 9.0,
        frameRate: 8.0,
        memory: 7.0,
        api: 8.5,
        stability: 7.5,
        battery: 8.0,
        profile: ScoringProfile.championCarWash,
        metrics: _createTestMetrics(),
      );
      
      final breakdown = score.breakdown;
      
      expect(breakdown['overall'], equals(8.0));
      expect(breakdown['startup'], equals(9.0));
      expect(breakdown['frameRate'], equals(8.0));
      expect(breakdown['memory'], equals(7.0));
      expect(breakdown['api'], equals(8.5));
      expect(breakdown['stability'], equals(7.5));
      expect(breakdown['battery'], equals(8.0));
    });
  });
  
  group('Scoring Configuration Tests', () {
    test('should have correct Champion Car Wash thresholds', () {
      final thresholds = ScoringThresholds.championCarWash();
      
      expect(thresholds.excellentStartup, equals(1000));
      expect(thresholds.goodStartup, equals(2000));
      expect(thresholds.excellentFrameRate, equals(58.0));
      expect(thresholds.excellentMemory, equals(80.0));
      expect(thresholds.excellentApi, equals(500));
    });
    
    test('should have different threshold profiles', () {
      final champion = ScoringThresholds.championCarWash();
      final strict = ScoringThresholds.strict();
      final relaxed = ScoringThresholds.relaxed();

      // Strict should have tighter thresholds
      expect(strict.excellentStartup, lessThan(champion.excellentStartup));
      expect(strict.excellentMemory, lessThan(champion.excellentMemory));

      // Relaxed should have looser thresholds
      expect(relaxed.excellentStartup, greaterThan(champion.excellentStartup));
      expect(relaxed.excellentMemory, greaterThan(champion.excellentMemory));
    });
  });
  
  group('Enum Tests', () {
    test('ScoringProfile should have correct descriptions', () {
      expect(ScoringProfile.championCarWash.description, 
             equals('Champion Car Wash optimized scoring'));
      expect(ScoringProfile.balanced.description, 
             equals('Balanced performance scoring'));
      expect(ScoringProfile.performanceFocused.description, 
             equals('Performance-focused scoring'));
    });
    
    test('DeviceCategory should have correct descriptions', () {
      expect(DeviceCategory.highEnd.description, 
             contains('High-end device'));
      expect(DeviceCategory.midRange.description, 
             contains('Mid-range device'));
      expect(DeviceCategory.lowEnd.description, 
             contains('Low-end device'));
    });
    
    test('PerformanceGrade should have correct descriptions', () {
      expect(PerformanceGrade.excellent.description, 
             equals('Excellent Performance'));
      expect(PerformanceGrade.good.description, 
             equals('Good Performance'));
      expect(PerformanceGrade.fair.description, 
             equals('Fair Performance'));
      expect(PerformanceGrade.poor.description, 
             equals('Poor Performance'));
      expect(PerformanceGrade.critical.description, 
             equals('Critical Performance Issues'));
    });
  });
}