/// Represents the results of a performance test execution
class TestResults {
  /// Name of the test that was executed
  final String testName;

  /// Whether the test passed or failed
  final bool passed;

  /// The actual measured value
  final double actualValue;

  /// The target/expected value
  final double targetValue;

  /// Unit of measurement (ms, fps, MB, etc.)
  final String unit;

  /// When the test was executed
  final DateTime timestamp;

  /// Additional metrics and metadata
  final Map<String, dynamic> additionalMetrics;

  const TestResults({
    required this.testName,
    required this.passed,
    required this.actualValue,
    required this.targetValue,
    required this.unit,
    required this.timestamp,
    required this.additionalMetrics,
  });

  /// Performance improvement percentage compared to target
  double get improvementPercentage {
    if (targetValue == 0) return 0.0;

    // For metrics where lower is better (startup time, response time)
    if (unit == 'ms' || unit.contains('time')) {
      return ((targetValue - actualValue) / targetValue) * 100;
    }

    // For metrics where higher is better (fps, success rate)
    return ((actualValue - targetValue) / targetValue) * 100;
  }

  /// Whether the test result shows improvement over target
  bool get showsImprovement => improvementPercentage > 0;

  /// Formatted string representation of the test result
  String get formattedResult {
    final status = passed ? 'PASS' : 'FAIL';
    final improvement = showsImprovement
        ? ' (+${improvementPercentage.toStringAsFixed(1)}%)'
        : '';

    return '$testName: $status - $actualValue$unit (target: $targetValue$unit)$improvement';
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'testName': testName,
      'passed': passed,
      'actualValue': actualValue,
      'targetValue': targetValue,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'additionalMetrics': additionalMetrics,
      'improvementPercentage': improvementPercentage,
    };
  }

  /// Create from JSON
  factory TestResults.fromJson(Map<String, dynamic> json) {
    return TestResults(
      testName: json['testName'] as String,
      passed: json['passed'] as bool,
      actualValue: (json['actualValue'] as num).toDouble(),
      targetValue: (json['targetValue'] as num).toDouble(),
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      additionalMetrics: json['additionalMetrics'] as Map<String, dynamic>,
    );
  }

  @override
  String toString() => formattedResult;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestResults &&
        other.testName == testName &&
        other.passed == passed &&
        other.actualValue == actualValue &&
        other.targetValue == targetValue &&
        other.unit == unit &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      testName,
      passed,
      actualValue,
      targetValue,
      unit,
      timestamp,
    );
  }
}
