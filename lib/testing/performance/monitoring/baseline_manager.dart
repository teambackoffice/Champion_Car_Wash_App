import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/performance_metrics.dart';

/// Manages performance baselines and comparisons for Champion Car Wash app
class BaselineManager {
  static BaselineManager? _instance;
  static BaselineManager get instance => _instance ??= BaselineManager._();

  BaselineManager._();

  static const String _baselineFileName = 'performance_baseline.json';
  static const String _historyFileName = 'performance_history.json';

  /// Record current metrics as baseline
  Future<void> recordBaseline(
    PerformanceMetrics metrics, {
    String? label,
  }) async {
    try {
      final baseline = PerformanceBaseline(
        metrics: metrics,
        label: label ?? 'Baseline ${DateTime.now().toIso8601String()}',
        recordedAt: DateTime.now(),
      );

      await _saveBaseline(baseline);
      developer.log(
        'BaselineManager: Recorded new baseline - ${baseline.label}',
      );
    } catch (e) {
      developer.log('BaselineManager: Error recording baseline: $e');
      rethrow;
    }
  }

  /// Get the current baseline
  Future<PerformanceBaseline?> getCurrentBaseline() async {
    try {
      final file = await _getBaselineFile();
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      return PerformanceBaseline.fromJson(json);
    } catch (e) {
      developer.log('BaselineManager: Error loading baseline: $e');
      return null;
    }
  }

  /// Compare current metrics against baseline
  Future<MetricsComparison> compareWithBaseline(
    PerformanceMetrics current,
  ) async {
    final baseline = await getCurrentBaseline();

    if (baseline == null) {
      return MetricsComparison.noBaseline(current);
    }

    return MetricsComparison.fromMetrics(
      current: current,
      baseline: baseline.metrics,
      baselineLabel: baseline.label,
    );
  }

  /// Record metrics to history for trend analysis
  Future<void> recordToHistory(PerformanceMetrics metrics) async {
    try {
      final history = await _loadHistory();
      history.add(HistoryEntry(metrics: metrics, timestamp: DateTime.now()));

      // Keep only last 1000 entries
      if (history.length > 1000) {
        history.removeRange(0, history.length - 1000);
      }

      await _saveHistory(history);
    } catch (e) {
      developer.log('BaselineManager: Error recording to history: $e');
    }
  }

  /// Get performance history
  Future<List<HistoryEntry>> getHistory({int? limit}) async {
    try {
      final history = await _loadHistory();

      if (limit != null && history.length > limit) {
        return history.sublist(history.length - limit);
      }

      return history;
    } catch (e) {
      developer.log('BaselineManager: Error loading history: $e');
      return [];
    }
  }

  /// Calculate performance trends over time
  Future<PerformanceTrends> calculateTrends({Duration? period}) async {
    final history = await getHistory();

    if (history.length < 2) {
      return PerformanceTrends.insufficient();
    }

    final cutoffTime = period != null ? DateTime.now().subtract(period) : null;

    final relevantHistory = cutoffTime != null
        ? history.where((entry) => entry.timestamp.isAfter(cutoffTime)).toList()
        : history;

    if (relevantHistory.length < 2) {
      return PerformanceTrends.insufficient();
    }

    return PerformanceTrends.calculate(relevantHistory);
  }

  /// Clear all baseline and history data
  Future<void> clearAll() async {
    try {
      final baselineFile = await _getBaselineFile();
      final historyFile = await _getHistoryFile();

      if (await baselineFile.exists()) {
        await baselineFile.delete();
      }

      if (await historyFile.exists()) {
        await historyFile.delete();
      }

      developer.log('BaselineManager: Cleared all data');
    } catch (e) {
      developer.log('BaselineManager: Error clearing data: $e');
    }
  }

  // Private methods

  Future<File> _getBaselineFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_baselineFileName');
  }

  Future<File> _getHistoryFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_historyFileName');
  }

  Future<void> _saveBaseline(PerformanceBaseline baseline) async {
    final file = await _getBaselineFile();
    await file.writeAsString(jsonEncode(baseline.toJson()));
  }

  Future<List<HistoryEntry>> _loadHistory() async {
    try {
      final file = await _getHistoryFile();
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      final jsonList = jsonDecode(content) as List<dynamic>;

      return jsonList
          .map((json) => HistoryEntry.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('BaselineManager: Error loading history: $e');
      return [];
    }
  }

  Future<void> _saveHistory(List<HistoryEntry> history) async {
    final file = await _getHistoryFile();
    final jsonList = history.map((entry) => entry.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}

/// Performance baseline record
class PerformanceBaseline {
  final PerformanceMetrics metrics;
  final String label;
  final DateTime recordedAt;

  const PerformanceBaseline({
    required this.metrics,
    required this.label,
    required this.recordedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics.toJson(),
      'label': label,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  factory PerformanceBaseline.fromJson(Map<String, dynamic> json) {
    return PerformanceBaseline(
      metrics: PerformanceMetrics.fromJson(
        json['metrics'] as Map<String, dynamic>,
      ),
      label: json['label'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }
}

/// History entry for trend analysis
class HistoryEntry {
  final PerformanceMetrics metrics;
  final DateTime timestamp;

  const HistoryEntry({required this.metrics, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      metrics: PerformanceMetrics.fromJson(
        json['metrics'] as Map<String, dynamic>,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// Comparison between current metrics and baseline
class MetricsComparison {
  final PerformanceMetrics current;
  final PerformanceMetrics? baseline;
  final String? baselineLabel;
  final bool hasBaseline;

  const MetricsComparison({
    required this.current,
    this.baseline,
    this.baselineLabel,
    required this.hasBaseline,
  });

  factory MetricsComparison.fromMetrics({
    required PerformanceMetrics current,
    required PerformanceMetrics baseline,
    required String baselineLabel,
  }) {
    return MetricsComparison(
      current: current,
      baseline: baseline,
      baselineLabel: baselineLabel,
      hasBaseline: true,
    );
  }

  factory MetricsComparison.noBaseline(PerformanceMetrics current) {
    return MetricsComparison(current: current, hasBaseline: false);
  }

  /// Startup time improvement percentage
  double? get startupTimeImprovement {
    if (!hasBaseline || baseline == null) return null;

    final baselineTime = baseline!.startupTimeMs;
    final currentTime = current.startupTimeMs;

    if (baselineTime == 0) return null;

    return ((baselineTime - currentTime) / baselineTime) * 100;
  }

  /// Frame rate improvement percentage
  double? get frameRateImprovement {
    if (!hasBaseline || baseline == null) return null;

    final baselineRate = baseline!.frameRate;
    final currentRate = current.frameRate;

    if (baselineRate == 0) return null;

    return ((currentRate - baselineRate) / baselineRate) * 100;
  }

  /// Memory usage improvement percentage (negative means more memory used)
  double? get memoryUsageImprovement {
    if (!hasBaseline || baseline == null) return null;

    final baselineMemory = baseline!.memoryUsageMB;
    final currentMemory = current.memoryUsageMB;

    if (baselineMemory == 0) return null;

    return ((baselineMemory - currentMemory) / baselineMemory) * 100;
  }

  /// API response time improvement percentage
  double? get apiResponseTimeImprovement {
    if (!hasBaseline || baseline == null) return null;

    final baselineTime = baseline!.apiResponseTimeMs;
    final currentTime = current.apiResponseTimeMs;

    if (baselineTime == 0) return null;

    return ((baselineTime - currentTime) / baselineTime) * 100;
  }

  /// Frame skip reduction percentage
  double? get frameSkipReduction {
    if (!hasBaseline || baseline == null) return null;

    final baselineSkips = baseline!.frameSkips;
    final currentSkips = current.frameSkips;

    if (baselineSkips == 0) return currentSkips == 0 ? 0.0 : -100.0;

    return ((baselineSkips - currentSkips) / baselineSkips) * 100;
  }

  /// Overall performance improvement score
  double? get overallImprovement {
    if (!hasBaseline || baseline == null) return null;

    final baselineScore = baseline!.performanceScore;
    final currentScore = current.performanceScore;

    if (baselineScore == 0) return null;

    return ((currentScore - baselineScore) / baselineScore) * 100;
  }

  /// Summary of all improvements
  Map<String, double?> get improvementSummary {
    return {
      'startupTime': startupTimeImprovement,
      'frameRate': frameRateImprovement,
      'memoryUsage': memoryUsageImprovement,
      'apiResponseTime': apiResponseTimeImprovement,
      'frameSkipReduction': frameSkipReduction,
      'overallScore': overallImprovement,
    };
  }

  /// Human-readable comparison report
  String generateReport() {
    if (!hasBaseline) {
      return 'No baseline available for comparison. Current performance score: ${current.performanceScore.toStringAsFixed(1)}/10';
    }

    final buffer = StringBuffer();
    buffer.writeln('Performance Comparison Report');
    buffer.writeln('Baseline: $baselineLabel');
    buffer.writeln('Current Time: ${current.timestamp}');
    buffer.writeln();

    // Startup time
    final startupImprovement = startupTimeImprovement;
    if (startupImprovement != null) {
      buffer.writeln(
        'Startup Time: ${current.startupTimeMs.toStringAsFixed(0)}ms '
        '(${startupImprovement >= 0 ? "+" : ""}${startupImprovement.toStringAsFixed(1)}%)',
      );
    }

    // Frame rate
    final frameRateImpr = frameRateImprovement;
    if (frameRateImpr != null) {
      buffer.writeln(
        'Frame Rate: ${current.frameRate.toStringAsFixed(1)}fps '
        '(${frameRateImpr >= 0 ? "+" : ""}${frameRateImpr.toStringAsFixed(1)}%)',
      );
    }

    // Memory usage
    final memoryImpr = memoryUsageImprovement;
    if (memoryImpr != null) {
      buffer.writeln(
        'Memory Usage: ${current.memoryUsageMB.toStringAsFixed(1)}MB '
        '(${memoryImpr >= 0 ? "+" : ""}${memoryImpr.toStringAsFixed(1)}%)',
      );
    }

    // API response time
    final apiImpr = apiResponseTimeImprovement;
    if (apiImpr != null) {
      buffer.writeln(
        'API Response: ${current.apiResponseTimeMs.toStringAsFixed(0)}ms '
        '(${apiImpr >= 0 ? "+" : ""}${apiImpr.toStringAsFixed(1)}%)',
      );
    }

    // Overall score
    final overallImpr = overallImprovement;
    if (overallImpr != null) {
      buffer.writeln();
      buffer.writeln(
        'Overall Score: ${current.performanceScore.toStringAsFixed(1)}/10 '
        '(${overallImpr >= 0 ? "+" : ""}${overallImpr.toStringAsFixed(1)}%)',
      );
    }

    return buffer.toString();
  }
}

/// Performance trends analysis
class PerformanceTrends {
  final bool hasSufficientData;
  final TrendDirection startupTimeTrend;
  final TrendDirection frameRateTrend;
  final TrendDirection memoryUsageTrend;
  final TrendDirection apiResponseTimeTrend;
  final TrendDirection overallScoreTrend;
  final Duration analysisWindow;
  final int dataPoints;

  const PerformanceTrends({
    required this.hasSufficientData,
    required this.startupTimeTrend,
    required this.frameRateTrend,
    required this.memoryUsageTrend,
    required this.apiResponseTimeTrend,
    required this.overallScoreTrend,
    required this.analysisWindow,
    required this.dataPoints,
  });

  factory PerformanceTrends.insufficient() {
    return const PerformanceTrends(
      hasSufficientData: false,
      startupTimeTrend: TrendDirection.stable,
      frameRateTrend: TrendDirection.stable,
      memoryUsageTrend: TrendDirection.stable,
      apiResponseTimeTrend: TrendDirection.stable,
      overallScoreTrend: TrendDirection.stable,
      analysisWindow: Duration.zero,
      dataPoints: 0,
    );
  }

  factory PerformanceTrends.calculate(List<HistoryEntry> history) {
    if (history.length < 2) {
      return PerformanceTrends.insufficient();
    }

    final first = history.first;
    final last = history.last;
    final window = last.timestamp.difference(first.timestamp);

    return PerformanceTrends(
      hasSufficientData: true,
      startupTimeTrend: _calculateTrend(
        history.map((e) => e.metrics.startupTimeMs).toList(),
        isLowerBetter: true,
      ),
      frameRateTrend: _calculateTrend(
        history.map((e) => e.metrics.frameRate).toList(),
        isLowerBetter: false,
      ),
      memoryUsageTrend: _calculateTrend(
        history.map((e) => e.metrics.memoryUsageMB).toList(),
        isLowerBetter: true,
      ),
      apiResponseTimeTrend: _calculateTrend(
        history.map((e) => e.metrics.apiResponseTimeMs).toList(),
        isLowerBetter: true,
      ),
      overallScoreTrend: _calculateTrend(
        history.map((e) => e.metrics.performanceScore).toList(),
        isLowerBetter: false,
      ),
      analysisWindow: window,
      dataPoints: history.length,
    );
  }

  static TrendDirection _calculateTrend(
    List<double> values, {
    required bool isLowerBetter,
  }) {
    if (values.length < 2) return TrendDirection.stable;

    final first = values.first;
    final last = values.last;
    final change = last - first;
    final changePercent = (change / first).abs() * 100;

    // Consider changes less than 5% as stable
    if (changePercent < 5.0) return TrendDirection.stable;

    if (isLowerBetter) {
      return change < 0 ? TrendDirection.improving : TrendDirection.degrading;
    } else {
      return change > 0 ? TrendDirection.improving : TrendDirection.degrading;
    }
  }
}

/// Trend direction enumeration
enum TrendDirection {
  improving,
  stable,
  degrading;

  String get description {
    switch (this) {
      case TrendDirection.improving:
        return 'Improving';
      case TrendDirection.stable:
        return 'Stable';
      case TrendDirection.degrading:
        return 'Degrading';
    }
  }

  String get emoji {
    switch (this) {
      case TrendDirection.improving:
        return '📈';
      case TrendDirection.stable:
        return '➡️';
      case TrendDirection.degrading:
        return '📉';
    }
  }
}
