/// Comprehensive performance metrics for Champion Car Wash app
class PerformanceMetrics {
  /// App startup time in milliseconds
  final double startupTimeMs;
  
  /// Number of frame skips detected
  final int frameSkips;
  
  /// Memory usage in megabytes
  final double memoryUsageMB;
  
  /// API response time in milliseconds
  final double apiResponseTimeMs;
  
  /// Current frame rate in frames per second
  final double frameRate;
  
  /// Battery drain per hour as percentage
  final double batteryDrainPerHour;
  
  /// When these metrics were captured
  final DateTime timestamp;
  
  /// Additional device-specific metrics
  final Map<String, dynamic> deviceMetrics;
  
  const PerformanceMetrics({
    required this.startupTimeMs,
    required this.frameSkips,
    required this.memoryUsageMB,
    required this.apiResponseTimeMs,
    required this.frameRate,
    required this.batteryDrainPerHour,
    required this.timestamp,
    this.deviceMetrics = const {},
  });
  
  /// Calculate overall performance score from 1-10
  double get performanceScore => _calculateScore();
  
  /// Whether startup time meets Champion Car Wash requirements (< 2 seconds)
  bool get meetsStartupRequirement => startupTimeMs < 2000;
  
  /// Whether frame rate meets 60fps requirement
  bool get meetsFrameRateRequirement => frameRate >= 60.0;
  
  /// Whether memory usage is within acceptable limits (< 120MB)
  bool get meetsMemoryRequirement => memoryUsageMB < 120.0;
  
  /// Whether API response time is acceptable (< 1 second)
  bool get meetsAPIRequirement => apiResponseTimeMs < 1000;
  
  /// Overall health status based on all requirements
  PerformanceHealth get healthStatus {
    final requirementsMet = [
      meetsStartupRequirement,
      meetsFrameRateRequirement,
      meetsMemoryRequirement,
      meetsAPIRequirement,
    ];
    
    final metCount = requirementsMet.where((met) => met).length;
    
    if (metCount == 4) return PerformanceHealth.excellent;
    if (metCount >= 3) return PerformanceHealth.good;
    if (metCount >= 2) return PerformanceHealth.fair;
    return PerformanceHealth.poor;
  }
  
  /// Calculate weighted performance score
  double _calculateScore() {
    double score = 0.0;
    
    // Startup time score (25% weight)
    final startupScore = startupTimeMs < 1000 ? 10.0 : 
                        startupTimeMs < 2000 ? 8.0 :
                        startupTimeMs < 3000 ? 6.0 : 3.0;
    score += startupScore * 0.25;
    
    // Frame rate score (25% weight)
    final frameRateScore = frameRate >= 60 ? 10.0 :
                          frameRate >= 50 ? 8.0 :
                          frameRate >= 40 ? 6.0 : 3.0;
    score += frameRateScore * 0.25;
    
    // Memory usage score (25% weight)
    final memoryScore = memoryUsageMB < 80 ? 10.0 :
                       memoryUsageMB < 120 ? 8.0 :
                       memoryUsageMB < 160 ? 6.0 : 3.0;
    score += memoryScore * 0.25;
    
    // API response time score (25% weight)
    final apiScore = apiResponseTimeMs < 500 ? 10.0 :
                    apiResponseTimeMs < 1000 ? 8.0 :
                    apiResponseTimeMs < 2000 ? 6.0 : 3.0;
    score += apiScore * 0.25;
    
    return score.clamp(0.0, 10.0);
  }
  
  /// Create metrics with current timestamp
  factory PerformanceMetrics.now({
    required double startupTimeMs,
    required int frameSkips,
    required double memoryUsageMB,
    required double apiResponseTimeMs,
    required double frameRate,
    required double batteryDrainPerHour,
    Map<String, dynamic> deviceMetrics = const {},
  }) {
    return PerformanceMetrics(
      startupTimeMs: startupTimeMs,
      frameSkips: frameSkips,
      memoryUsageMB: memoryUsageMB,
      apiResponseTimeMs: apiResponseTimeMs,
      frameRate: frameRate,
      batteryDrainPerHour: batteryDrainPerHour,
      timestamp: DateTime.now(),
      deviceMetrics: deviceMetrics,
    );
  }
  
  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'startupTimeMs': startupTimeMs,
      'frameSkips': frameSkips,
      'memoryUsageMB': memoryUsageMB,
      'apiResponseTimeMs': apiResponseTimeMs,
      'frameRate': frameRate,
      'batteryDrainPerHour': batteryDrainPerHour,
      'timestamp': timestamp.toIso8601String(),
      'deviceMetrics': deviceMetrics,
      'performanceScore': performanceScore,
      'healthStatus': healthStatus.toString(),
    };
  }
  
  /// Create from JSON
  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      startupTimeMs: (json['startupTimeMs'] as num).toDouble(),
      frameSkips: json['frameSkips'] as int,
      memoryUsageMB: (json['memoryUsageMB'] as num).toDouble(),
      apiResponseTimeMs: (json['apiResponseTimeMs'] as num).toDouble(),
      frameRate: (json['frameRate'] as num).toDouble(),
      batteryDrainPerHour: (json['batteryDrainPerHour'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      deviceMetrics: json['deviceMetrics'] as Map<String, dynamic>? ?? {},
    );
  }
  
  @override
  String toString() {
    return 'PerformanceMetrics('
           'startup: ${startupTimeMs}ms, '
           'fps: $frameRate, '
           'memory: ${memoryUsageMB}MB, '
           'api: ${apiResponseTimeMs}ms, '
           'score: ${performanceScore.toStringAsFixed(1)}/10'
           ')';
  }
}

/// Performance health status enumeration
enum PerformanceHealth {
  excellent,
  good,
  fair,
  poor;
  
  /// Human-readable description
  String get description {
    switch (this) {
      case PerformanceHealth.excellent:
        return 'Excellent - All performance requirements met';
      case PerformanceHealth.good:
        return 'Good - Most performance requirements met';
      case PerformanceHealth.fair:
        return 'Fair - Some performance issues detected';
      case PerformanceHealth.poor:
        return 'Poor - Significant performance issues';
    }
  }
  
  /// Color indicator for UI display
  String get colorIndicator {
    switch (this) {
      case PerformanceHealth.excellent:
        return 'GREEN';
      case PerformanceHealth.good:
        return 'LIGHT_GREEN';
      case PerformanceHealth.fair:
        return 'YELLOW';
      case PerformanceHealth.poor:
        return 'RED';
    }
  }
}