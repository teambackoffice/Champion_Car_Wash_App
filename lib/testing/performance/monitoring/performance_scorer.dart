import '../models/performance_metrics.dart';

/// Advanced performance scoring system for Champion Car Wash app
class PerformanceScorer {
  static PerformanceScorer? _instance;
  static PerformanceScorer get instance => _instance ??= PerformanceScorer._();

  PerformanceScorer._();

  /// Calculate comprehensive performance score (1-10 scale)
  PerformanceScore calculateScore(
    PerformanceMetrics metrics, {
    ScoringProfile profile = ScoringProfile.championCarWash,
  }) {
    final weights = _getWeights(profile);
    final thresholds = _getThresholds(profile);

    // Calculate individual component scores
    final startupScore = _calculateStartupScore(
      metrics.startupTimeMs,
      thresholds,
    );
    final frameRateScore = _calculateFrameRateScore(
      metrics.frameRate,
      thresholds,
    );
    final memoryScore = _calculateMemoryScore(
      metrics.memoryUsageMB,
      thresholds,
    );
    final apiScore = _calculateApiScore(metrics.apiResponseTimeMs, thresholds);
    final stabilityScore = _calculateStabilityScore(
      metrics.frameSkips,
      thresholds,
    );
    final batteryScore = _calculateBatteryScore(
      metrics.batteryDrainPerHour,
      thresholds,
    );

    // Calculate weighted overall score
    final overallScore =
        (startupScore * weights.startup +
                frameRateScore * weights.frameRate +
                memoryScore * weights.memory +
                apiScore * weights.api +
                stabilityScore * weights.stability +
                batteryScore * weights.battery)
            .clamp(0.0, 10.0);

    return PerformanceScore(
      overall: overallScore,
      startup: startupScore,
      frameRate: frameRateScore,
      memory: memoryScore,
      api: apiScore,
      stability: stabilityScore,
      battery: batteryScore,
      profile: profile,
      metrics: metrics,
    );
  }

  /// Calculate Champion Car Wash workflow-specific scores
  ChampionCarWashScore calculateWorkflowScore(PerformanceMetrics metrics) {
    // Technician workflow scoring (booking management, service updates)
    final technicianScore = _calculateTechnicianWorkflowScore(metrics);

    // Supervisor workflow scoring (dashboard, reporting)
    final supervisorScore = _calculateSupervisorWorkflowScore(metrics);

    // Payment processing scoring (Stripe NFC, invoice generation)
    final paymentScore = _calculatePaymentWorkflowScore(metrics);

    // Customer interaction scoring (booking creation, status updates)
    final customerScore = _calculateCustomerWorkflowScore(metrics);

    // Overall workflow score (weighted average)
    final overallWorkflowScore =
        (technicianScore * 0.35 + // Technicians are primary users
                supervisorScore * 0.25 + // Supervisors use dashboard frequently
                paymentScore * 0.25 + // Payment is critical workflow
                customerScore *
                    0.15 // Customer interactions are important but less frequent
                    )
            .clamp(0.0, 10.0);

    return ChampionCarWashScore(
      overall: overallWorkflowScore,
      technician: technicianScore,
      supervisor: supervisorScore,
      payment: paymentScore,
      customer: customerScore,
      metrics: metrics,
    );
  }

  /// Calculate device-specific performance score
  DevicePerformanceScore calculateDeviceScore(
    PerformanceMetrics metrics,
    DeviceCategory category,
  ) {
    final thresholds = _getDeviceThresholds(category);
    final weights = _getDeviceWeights(category);

    final scores = _calculateAllComponentScores(metrics, thresholds);

    final overallScore =
        (scores['startup']! * weights.startup +
                scores['frameRate']! * weights.frameRate +
                scores['memory']! * weights.memory +
                scores['api']! * weights.api +
                scores['stability']! * weights.stability +
                scores['battery']! * weights.battery)
            .clamp(0.0, 10.0);

    return DevicePerformanceScore(
      overall: overallScore,
      category: category,
      meetsExpectations: _meetsDeviceExpectations(overallScore, category),
      componentScores: scores,
      metrics: metrics,
    );
  }

  // Private scoring methods

  double _calculateStartupScore(
    double startupTimeMs,
    ScoringThresholds thresholds,
  ) {
    if (startupTimeMs <= thresholds.excellentStartup) return 10.0;
    if (startupTimeMs <= thresholds.goodStartup) return 8.0;
    if (startupTimeMs <= thresholds.acceptableStartup) return 6.0;
    if (startupTimeMs <= thresholds.poorStartup) return 4.0;
    return 2.0;
  }

  double _calculateFrameRateScore(
    double frameRate,
    ScoringThresholds thresholds,
  ) {
    if (frameRate >= thresholds.excellentFrameRate) return 10.0;
    if (frameRate >= thresholds.goodFrameRate) return 8.0;
    if (frameRate >= thresholds.acceptableFrameRate) return 6.0;
    if (frameRate >= thresholds.poorFrameRate) return 4.0;
    return 2.0;
  }

  double _calculateMemoryScore(
    double memoryUsageMB,
    ScoringThresholds thresholds,
  ) {
    if (memoryUsageMB <= thresholds.excellentMemory) return 10.0;
    if (memoryUsageMB <= thresholds.goodMemory) return 8.0;
    if (memoryUsageMB <= thresholds.acceptableMemory) return 6.0;
    if (memoryUsageMB <= thresholds.poorMemory) return 4.0;
    return 2.0;
  }

  double _calculateApiScore(
    double apiResponseTimeMs,
    ScoringThresholds thresholds,
  ) {
    if (apiResponseTimeMs <= thresholds.excellentApi) return 10.0;
    if (apiResponseTimeMs <= thresholds.goodApi) return 8.0;
    if (apiResponseTimeMs <= thresholds.acceptableApi) return 6.0;
    if (apiResponseTimeMs <= thresholds.poorApi) return 4.0;
    return 2.0;
  }

  double _calculateStabilityScore(
    int frameSkips,
    ScoringThresholds thresholds,
  ) {
    if (frameSkips <= thresholds.excellentStability) return 10.0;
    if (frameSkips <= thresholds.goodStability) return 8.0;
    if (frameSkips <= thresholds.acceptableStability) return 6.0;
    if (frameSkips <= thresholds.poorStability) return 4.0;
    return 2.0;
  }

  double _calculateBatteryScore(
    double batteryDrainPerHour,
    ScoringThresholds thresholds,
  ) {
    if (batteryDrainPerHour <= thresholds.excellentBattery) return 10.0;
    if (batteryDrainPerHour <= thresholds.goodBattery) return 8.0;
    if (batteryDrainPerHour <= thresholds.acceptableBattery) return 6.0;
    if (batteryDrainPerHour <= thresholds.poorBattery) return 4.0;
    return 2.0;
  }

  double _calculateTechnicianWorkflowScore(PerformanceMetrics metrics) {
    // Technician workflow prioritizes:
    // - Fast startup (they switch between apps frequently)
    // - Smooth scrolling (booking lists)
    // - Quick API responses (status updates)

    const startupWeight = 0.4;
    const frameRateWeight = 0.3;
    const apiWeight = 0.3;

    final startupScore = _calculateStartupScore(
      metrics.startupTimeMs,
      ScoringThresholds.championCarWash(),
    );
    final frameRateScore = _calculateFrameRateScore(
      metrics.frameRate,
      ScoringThresholds.championCarWash(),
    );
    final apiScore = _calculateApiScore(
      metrics.apiResponseTimeMs,
      ScoringThresholds.championCarWash(),
    );

    return (startupScore * startupWeight +
            frameRateScore * frameRateWeight +
            apiScore * apiWeight)
        .clamp(0.0, 10.0);
  }

  double _calculateSupervisorWorkflowScore(PerformanceMetrics metrics) {
    // Supervisor workflow prioritizes:
    // - Memory efficiency (dashboard with lots of data)
    // - API performance (reports and analytics)
    // - Overall stability

    const memoryWeight = 0.4;
    const apiWeight = 0.35;
    const stabilityWeight = 0.25;

    final memoryScore = _calculateMemoryScore(
      metrics.memoryUsageMB,
      ScoringThresholds.championCarWash(),
    );
    final apiScore = _calculateApiScore(
      metrics.apiResponseTimeMs,
      ScoringThresholds.championCarWash(),
    );
    final stabilityScore = _calculateStabilityScore(
      metrics.frameSkips,
      ScoringThresholds.championCarWash(),
    );

    return (memoryScore * memoryWeight +
            apiScore * apiWeight +
            stabilityScore * stabilityWeight)
        .clamp(0.0, 10.0);
  }

  double _calculatePaymentWorkflowScore(PerformanceMetrics metrics) {
    // Payment workflow prioritizes:
    // - API responsiveness (Stripe operations)
    // - UI stability (NFC interactions)
    // - Memory efficiency (payment processing)

    const apiWeight = 0.5;
    const stabilityWeight = 0.3;
    const memoryWeight = 0.2;

    final apiScore = _calculateApiScore(
      metrics.apiResponseTimeMs,
      ScoringThresholds.championCarWash(),
    );
    final stabilityScore = _calculateStabilityScore(
      metrics.frameSkips,
      ScoringThresholds.championCarWash(),
    );
    final memoryScore = _calculateMemoryScore(
      metrics.memoryUsageMB,
      ScoringThresholds.championCarWash(),
    );

    return (apiScore * apiWeight +
            stabilityScore * stabilityWeight +
            memoryScore * memoryWeight)
        .clamp(0.0, 10.0);
  }

  double _calculateCustomerWorkflowScore(PerformanceMetrics metrics) {
    // Customer workflow prioritizes:
    // - Fast startup (quick interactions)
    // - Smooth UI (booking creation)
    // - Battery efficiency (mobile usage)

    const startupWeight = 0.4;
    const frameRateWeight = 0.35;
    const batteryWeight = 0.25;

    final startupScore = _calculateStartupScore(
      metrics.startupTimeMs,
      ScoringThresholds.championCarWash(),
    );
    final frameRateScore = _calculateFrameRateScore(
      metrics.frameRate,
      ScoringThresholds.championCarWash(),
    );
    final batteryScore = _calculateBatteryScore(
      metrics.batteryDrainPerHour,
      ScoringThresholds.championCarWash(),
    );

    return (startupScore * startupWeight +
            frameRateScore * frameRateWeight +
            batteryScore * batteryWeight)
        .clamp(0.0, 10.0);
  }

  Map<String, double> _calculateAllComponentScores(
    PerformanceMetrics metrics,
    ScoringThresholds thresholds,
  ) {
    return {
      'startup': _calculateStartupScore(metrics.startupTimeMs, thresholds),
      'frameRate': _calculateFrameRateScore(metrics.frameRate, thresholds),
      'memory': _calculateMemoryScore(metrics.memoryUsageMB, thresholds),
      'api': _calculateApiScore(metrics.apiResponseTimeMs, thresholds),
      'stability': _calculateStabilityScore(metrics.frameSkips, thresholds),
      'battery': _calculateBatteryScore(
        metrics.batteryDrainPerHour,
        thresholds,
      ),
    };
  }

  bool _meetsDeviceExpectations(double score, DeviceCategory category) {
    switch (category) {
      case DeviceCategory.highEnd:
        return score >= 8.0;
      case DeviceCategory.midRange:
        return score >= 6.5;
      case DeviceCategory.lowEnd:
        return score >= 5.0;
    }
  }

  ScoringWeights _getWeights(ScoringProfile profile) {
    switch (profile) {
      case ScoringProfile.championCarWash:
        return const ScoringWeights(
          startup: 0.25,
          frameRate: 0.20,
          memory: 0.20,
          api: 0.20,
          stability: 0.10,
          battery: 0.05,
        );
      case ScoringProfile.balanced:
        return const ScoringWeights(
          startup: 0.20,
          frameRate: 0.20,
          memory: 0.20,
          api: 0.20,
          stability: 0.10,
          battery: 0.10,
        );
      case ScoringProfile.performanceFocused:
        return const ScoringWeights(
          startup: 0.30,
          frameRate: 0.30,
          memory: 0.15,
          api: 0.15,
          stability: 0.05,
          battery: 0.05,
        );
    }
  }

  ScoringThresholds _getThresholds(ScoringProfile profile) {
    switch (profile) {
      case ScoringProfile.championCarWash:
        return ScoringThresholds.championCarWash();
      case ScoringProfile.balanced:
        return ScoringThresholds.balanced();
      case ScoringProfile.performanceFocused:
        return ScoringThresholds.strict();
    }
  }

  ScoringThresholds _getDeviceThresholds(DeviceCategory category) {
    switch (category) {
      case DeviceCategory.highEnd:
        return ScoringThresholds.strict();
      case DeviceCategory.midRange:
        return ScoringThresholds.balanced();
      case DeviceCategory.lowEnd:
        return ScoringThresholds.relaxed();
    }
  }

  ScoringWeights _getDeviceWeights(DeviceCategory category) {
    switch (category) {
      case DeviceCategory.highEnd:
        return const ScoringWeights(
          startup: 0.25,
          frameRate: 0.25,
          memory: 0.15,
          api: 0.20,
          stability: 0.10,
          battery: 0.05,
        );
      case DeviceCategory.midRange:
        return const ScoringWeights(
          startup: 0.20,
          frameRate: 0.20,
          memory: 0.25,
          api: 0.20,
          stability: 0.10,
          battery: 0.05,
        );
      case DeviceCategory.lowEnd:
        return const ScoringWeights(
          startup: 0.15,
          frameRate: 0.15,
          memory: 0.30,
          api: 0.20,
          stability: 0.15,
          battery: 0.05,
        );
    }
  }
}

/// Performance score result
class PerformanceScore {
  final double overall;
  final double startup;
  final double frameRate;
  final double memory;
  final double api;
  final double stability;
  final double battery;
  final ScoringProfile profile;
  final PerformanceMetrics metrics;

  const PerformanceScore({
    required this.overall,
    required this.startup,
    required this.frameRate,
    required this.memory,
    required this.api,
    required this.stability,
    required this.battery,
    required this.profile,
    required this.metrics,
  });

  /// Performance grade based on overall score
  PerformanceGrade get grade {
    if (overall >= 9.0) return PerformanceGrade.excellent;
    if (overall >= 7.5) return PerformanceGrade.good;
    if (overall >= 6.0) return PerformanceGrade.fair;
    if (overall >= 4.0) return PerformanceGrade.poor;
    return PerformanceGrade.critical;
  }

  /// Detailed score breakdown
  Map<String, double> get breakdown {
    return {
      'overall': overall,
      'startup': startup,
      'frameRate': frameRate,
      'memory': memory,
      'api': api,
      'stability': stability,
      'battery': battery,
    };
  }

  /// Areas that need improvement (scores < 6.0)
  List<String> get improvementAreas {
    final areas = <String>[];
    if (startup < 6.0) areas.add('Startup Time');
    if (frameRate < 6.0) areas.add('Frame Rate');
    if (memory < 6.0) areas.add('Memory Usage');
    if (api < 6.0) areas.add('API Performance');
    if (stability < 6.0) areas.add('UI Stability');
    if (battery < 6.0) areas.add('Battery Efficiency');
    return areas;
  }

  /// Generate detailed report
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('Performance Score Report');
    buffer.writeln('Profile: ${profile.name}');
    buffer.writeln(
      'Overall Score: ${overall.toStringAsFixed(1)}/10 (${grade.description})',
    );
    buffer.writeln();

    buffer.writeln('Component Scores:');
    buffer.writeln('  Startup Time: ${startup.toStringAsFixed(1)}/10');
    buffer.writeln('  Frame Rate: ${frameRate.toStringAsFixed(1)}/10');
    buffer.writeln('  Memory Usage: ${memory.toStringAsFixed(1)}/10');
    buffer.writeln('  API Performance: ${api.toStringAsFixed(1)}/10');
    buffer.writeln('  UI Stability: ${stability.toStringAsFixed(1)}/10');
    buffer.writeln('  Battery Efficiency: ${battery.toStringAsFixed(1)}/10');

    if (improvementAreas.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Areas for Improvement:');
      for (final area in improvementAreas) {
        buffer.writeln('  - $area');
      }
    }

    return buffer.toString();
  }
}

/// Champion Car Wash workflow-specific score
class ChampionCarWashScore {
  final double overall;
  final double technician;
  final double supervisor;
  final double payment;
  final double customer;
  final PerformanceMetrics metrics;

  const ChampionCarWashScore({
    required this.overall,
    required this.technician,
    required this.supervisor,
    required this.payment,
    required this.customer,
    required this.metrics,
  });

  /// Workflow scores breakdown
  Map<String, double> get workflowScores {
    return {
      'overall': overall,
      'technician': technician,
      'supervisor': supervisor,
      'payment': payment,
      'customer': customer,
    };
  }

  /// Critical workflows (scores < 6.0)
  List<String> get criticalWorkflows {
    final workflows = <String>[];
    if (technician < 6.0) workflows.add('Technician Workflow');
    if (supervisor < 6.0) workflows.add('Supervisor Workflow');
    if (payment < 6.0) workflows.add('Payment Workflow');
    if (customer < 6.0) workflows.add('Customer Workflow');
    return workflows;
  }
}

/// Device-specific performance score
class DevicePerformanceScore {
  final double overall;
  final DeviceCategory category;
  final bool meetsExpectations;
  final Map<String, double> componentScores;
  final PerformanceMetrics metrics;

  const DevicePerformanceScore({
    required this.overall,
    required this.category,
    required this.meetsExpectations,
    required this.componentScores,
    required this.metrics,
  });
}

/// Scoring profile enumeration
enum ScoringProfile {
  championCarWash,
  balanced,
  performanceFocused;

  String get description {
    switch (this) {
      case ScoringProfile.championCarWash:
        return 'Champion Car Wash optimized scoring';
      case ScoringProfile.balanced:
        return 'Balanced performance scoring';
      case ScoringProfile.performanceFocused:
        return 'Performance-focused scoring';
    }
  }
}

/// Device category enumeration
enum DeviceCategory {
  highEnd,
  midRange,
  lowEnd;

  String get description {
    switch (this) {
      case DeviceCategory.highEnd:
        return 'High-end device (8GB+ RAM, flagship processor)';
      case DeviceCategory.midRange:
        return 'Mid-range device (4-6GB RAM, mid-tier processor)';
      case DeviceCategory.lowEnd:
        return 'Low-end device (2-3GB RAM, budget processor)';
    }
  }
}

/// Performance grade enumeration
enum PerformanceGrade {
  excellent,
  good,
  fair,
  poor,
  critical;

  String get description {
    switch (this) {
      case PerformanceGrade.excellent:
        return 'Excellent Performance';
      case PerformanceGrade.good:
        return 'Good Performance';
      case PerformanceGrade.fair:
        return 'Fair Performance';
      case PerformanceGrade.poor:
        return 'Poor Performance';
      case PerformanceGrade.critical:
        return 'Critical Performance Issues';
    }
  }
}

/// Scoring weights configuration
class ScoringWeights {
  final double startup;
  final double frameRate;
  final double memory;
  final double api;
  final double stability;
  final double battery;

  const ScoringWeights({
    required this.startup,
    required this.frameRate,
    required this.memory,
    required this.api,
    required this.stability,
    required this.battery,
  });
}

/// Scoring thresholds configuration
class ScoringThresholds {
  final double excellentStartup;
  final double goodStartup;
  final double acceptableStartup;
  final double poorStartup;

  final double excellentFrameRate;
  final double goodFrameRate;
  final double acceptableFrameRate;
  final double poorFrameRate;

  final double excellentMemory;
  final double goodMemory;
  final double acceptableMemory;
  final double poorMemory;

  final double excellentApi;
  final double goodApi;
  final double acceptableApi;
  final double poorApi;

  final int excellentStability;
  final int goodStability;
  final int acceptableStability;
  final int poorStability;

  final double excellentBattery;
  final double goodBattery;
  final double acceptableBattery;
  final double poorBattery;

  const ScoringThresholds({
    required this.excellentStartup,
    required this.goodStartup,
    required this.acceptableStartup,
    required this.poorStartup,
    required this.excellentFrameRate,
    required this.goodFrameRate,
    required this.acceptableFrameRate,
    required this.poorFrameRate,
    required this.excellentMemory,
    required this.goodMemory,
    required this.acceptableMemory,
    required this.poorMemory,
    required this.excellentApi,
    required this.goodApi,
    required this.acceptableApi,
    required this.poorApi,
    required this.excellentStability,
    required this.goodStability,
    required this.acceptableStability,
    required this.poorStability,
    required this.excellentBattery,
    required this.goodBattery,
    required this.acceptableBattery,
    required this.poorBattery,
  });

  factory ScoringThresholds.championCarWash() {
    return const ScoringThresholds(
      excellentStartup: 1000, // 1 second
      goodStartup: 2000, // 2 seconds
      acceptableStartup: 3000, // 3 seconds
      poorStartup: 5000, // 5 seconds

      excellentFrameRate: 58.0,
      goodFrameRate: 55.0,
      acceptableFrameRate: 50.0,
      poorFrameRate: 40.0,

      excellentMemory: 80.0, // 80MB
      goodMemory: 120.0, // 120MB
      acceptableMemory: 160.0, // 160MB
      poorMemory: 200.0, // 200MB

      excellentApi: 500, // 500ms
      goodApi: 1000, // 1 second
      acceptableApi: 2000, // 2 seconds
      poorApi: 3000, // 3 seconds

      excellentStability: 2,
      goodStability: 5,
      acceptableStability: 10,
      poorStability: 20,

      excellentBattery: 8.0, // 8% per hour
      goodBattery: 12.0, // 12% per hour
      acceptableBattery: 18.0, // 18% per hour
      poorBattery: 25.0, // 25% per hour
    );
  }

  factory ScoringThresholds.balanced() {
    return const ScoringThresholds(
      excellentStartup: 1500,
      goodStartup: 2500,
      acceptableStartup: 4000,
      poorStartup: 6000,

      excellentFrameRate: 55.0,
      goodFrameRate: 50.0,
      acceptableFrameRate: 45.0,
      poorFrameRate: 35.0,

      excellentMemory: 100.0,
      goodMemory: 150.0,
      acceptableMemory: 200.0,
      poorMemory: 250.0,

      excellentApi: 750,
      goodApi: 1500,
      acceptableApi: 2500,
      poorApi: 4000,

      excellentStability: 3,
      goodStability: 8,
      acceptableStability: 15,
      poorStability: 25,

      excellentBattery: 10.0,
      goodBattery: 15.0,
      acceptableBattery: 22.0,
      poorBattery: 30.0,
    );
  }

  factory ScoringThresholds.strict() {
    return const ScoringThresholds(
      excellentStartup: 800,
      goodStartup: 1500,
      acceptableStartup: 2500,
      poorStartup: 4000,

      excellentFrameRate: 59.0,
      goodFrameRate: 57.0,
      acceptableFrameRate: 53.0,
      poorFrameRate: 45.0,

      excellentMemory: 60.0,
      goodMemory: 100.0,
      acceptableMemory: 140.0,
      poorMemory: 180.0,

      excellentApi: 300,
      goodApi: 700,
      acceptableApi: 1500,
      poorApi: 2500,

      excellentStability: 1,
      goodStability: 3,
      acceptableStability: 7,
      poorStability: 15,

      excellentBattery: 6.0,
      goodBattery: 10.0,
      acceptableBattery: 15.0,
      poorBattery: 20.0,
    );
  }

  factory ScoringThresholds.relaxed() {
    return const ScoringThresholds(
      excellentStartup: 2000,
      goodStartup: 3500,
      acceptableStartup: 5000,
      poorStartup: 7000,

      excellentFrameRate: 50.0,
      goodFrameRate: 45.0,
      acceptableFrameRate: 40.0,
      poorFrameRate: 30.0,

      excellentMemory: 120.0,
      goodMemory: 180.0,
      acceptableMemory: 240.0,
      poorMemory: 300.0,

      excellentApi: 1000,
      goodApi: 2000,
      acceptableApi: 3500,
      poorApi: 5000,

      excellentStability: 5,
      goodStability: 12,
      acceptableStability: 20,
      poorStability: 35,

      excellentBattery: 12.0,
      goodBattery: 18.0,
      acceptableBattery: 25.0,
      poorBattery: 35.0,
    );
  }
}
