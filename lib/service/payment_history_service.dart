import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

// Top-level function for decoding JSON in a separate isolate
List<dynamic> _decodeHistory(String jsonString) {
  return jsonDecode(jsonString) as List<dynamic>;
}

/// Payment History Service
/// Stores and manages all payment transactions across different payment methods
class PaymentHistoryService {
  static final PaymentHistoryService _instance = PaymentHistoryService._internal();
  factory PaymentHistoryService() => _instance;
  PaymentHistoryService._internal();

  static PaymentHistoryService get instance => _instance;

  final List<PaymentHistoryRecord> _paymentHistory = [];
  final StreamController<List<PaymentHistoryRecord>> _historyController = 
      StreamController<List<PaymentHistoryRecord>>.broadcast();

  // Storage keys
  static const String _historyFilename = 'payment_history.json';

  /// Get payment history stream
  Stream<List<PaymentHistoryRecord>> get historyStream => _historyController.stream;

  /// Get current payment history
  List<PaymentHistoryRecord> get paymentHistory => List.unmodifiable(_paymentHistory);

  /// Initialize payment history service
  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        print('PaymentHistory: Initializing service...');
      }
      await _loadPaymentHistory();
      if (kDebugMode) {
        print('PaymentHistory: Service initialized with ${_paymentHistory.length} records');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PaymentHistory: Error initializing: $e');
      }
    }
  }

  /// Add a new payment record
  Future<void> addPaymentRecord({
    required String orderId,
    required double amount,
    required String currency,
    required String paymentMethod,
    required PaymentStatus status,
    String? transactionId,
    String? cardLastFour,
    String? authCode,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final record = PaymentHistoryRecord(
        id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
        orderId: orderId,
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
        status: status,
        timestamp: DateTime.now(),
        transactionId: transactionId,
        cardLastFour: cardLastFour,
        authCode: authCode,
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        errorMessage: errorMessage,
        metadata: metadata ?? {},
      );

      _paymentHistory.insert(0, record); // Add to beginning (newest first)
      await _savePaymentHistory();

      // Notify listeners
      _historyController.add(_paymentHistory);

      if (kDebugMode) {
        print('PaymentHistory: Added record ${record.id} - ${record.paymentMethod} - ${record.status.name}');
        print('PaymentHistory: Total records: ${_paymentHistory.length}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PaymentHistory: Error adding record: $e');
      }
    }
  }

  /// Get payment statistics
  Future<PaymentStats> getPaymentStats() async {
    try {
      final totalPayments = _paymentHistory.length;
      final successfulPayments = _paymentHistory.where((p) => p.status == PaymentStatus.completed).length;
      final failedPayments = _paymentHistory.where((p) => p.status == PaymentStatus.failed).length;
      final totalAmount = _paymentHistory
          .where((p) => p.status == PaymentStatus.completed)
          .fold(0.0, (sum, p) => sum + p.amount);

      // Group by payment method
      final methodStats = <String, int>{};
      for (final payment in _paymentHistory) {
        methodStats[payment.paymentMethod] = (methodStats[payment.paymentMethod] ?? 0) + 1;
      }

      // Group by date (last 7 days)
      final now = DateTime.now();
      final dailyStats = <String, int>{};
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        dailyStats[dateKey] = 0;
      }

      for (final payment in _paymentHistory) {
        final dateKey = '${payment.timestamp.year}-${payment.timestamp.month.toString().padLeft(2, '0')}-${payment.timestamp.day.toString().padLeft(2, '0')}';
        if (dailyStats.containsKey(dateKey)) {
          dailyStats[dateKey] = dailyStats[dateKey]! + 1;
        }
      }

      return PaymentStats(
        totalPayments: totalPayments,
        successfulPayments: successfulPayments,
        failedPayments: failedPayments,
        totalAmount: totalAmount,
        successRate: totalPayments > 0 ? (successfulPayments / totalPayments * 100) : 0.0,
        methodStats: methodStats,
        dailyStats: dailyStats,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('PaymentHistory: Error getting stats: $e');
      }
      return PaymentStats.empty();
    }
  }

  /// Get payments by status
  List<PaymentHistoryRecord> getPaymentsByStatus(PaymentStatus status) {
    return _paymentHistory.where((p) => p.status == status).toList();
  }

  /// Get payments by method
  List<PaymentHistoryRecord> getPaymentsByMethod(String method) {
    return _paymentHistory.where((p) => p.paymentMethod == method).toList();
  }

  /// Get payments by date range
  List<PaymentHistoryRecord> getPaymentsByDateRange(DateTime start, DateTime end) {
    return _paymentHistory.where((p) => 
        p.timestamp.isAfter(start) && p.timestamp.isBefore(end)).toList();
  }

  /// Search payments
  List<PaymentHistoryRecord> searchPayments(String query) {
    final lowerQuery = query.toLowerCase();
    return _paymentHistory.where((p) => 
        p.orderId.toLowerCase().contains(lowerQuery) ||
        (p.transactionId?.toLowerCase().contains(lowerQuery) ?? false) ||
        (p.customerName?.toLowerCase().contains(lowerQuery) ?? false) ||
        (p.customerPhone?.toLowerCase().contains(lowerQuery) ?? false) ||
        p.paymentMethod.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  /// Clear all payment history
  Future<void> clearHistory() async {
    try {
      _paymentHistory.clear();
      final file = await _getHistoryFile();
      if (await file.exists()) {
        await file.delete();
      }
      _historyController.add(_paymentHistory);
      if (kDebugMode) {
        print('PaymentHistory: History cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PaymentHistory: Error clearing history: $e');
      }
    }
  }

  /// Export payment history as JSON
  Future<String> exportHistoryAsJson() async {
    try {
      final data = {
        'export_date': DateTime.now().toIso8601String(),
        'total_records': _paymentHistory.length,
        'payments': _paymentHistory.map((p) => p.toJson()).toList(),
      };
      return jsonEncode(data);
    } catch (e) {
      if (kDebugMode) {
        print('PaymentHistory: Error exporting: $e');
      }
      return '{}';
    }
  }

  Future<File> _getHistoryFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_historyFilename');
  }

  /// Load payment history from storage
  Future<void> _loadPaymentHistory() async {
    try {
      final file = await _getHistoryFile();
      if (await file.exists()) {
        final historyJson = await file.readAsString();
        if (historyJson.isNotEmpty) {
          final List<dynamic> historyList = await compute(_decodeHistory, historyJson);
          _paymentHistory.clear();
          _paymentHistory.addAll(
            historyList.map((json) => PaymentHistoryRecord.fromJson(json)).toList()
          );
          if (kDebugMode) {
            print('PaymentHistory: Loaded ${_paymentHistory.length} records from storage');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('PaymentHistory: Error loading history: $e');
      }
    }
  }

  /// Save payment history to storage
  Future<void> _savePaymentHistory() async {
    try {
      if (_paymentHistory.length > 1000) {
        _paymentHistory.removeRange(1000, _paymentHistory.length);
      }

      final historyJson = await compute(jsonEncode, _paymentHistory.map((p) => p.toJson()).toList());
      final file = await _getHistoryFile();
      await file.writeAsString(historyJson);
    } catch (e) {
      if (kDebugMode) {
        print('PaymentHistory: Error saving history: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _historyController.close();
  }
}

/// Payment History Record Model
class PaymentHistoryRecord {
  final String id;
  final String orderId;
  final double amount;
  final String currency;
  final String paymentMethod;
  final PaymentStatus status;
  final DateTime timestamp;
  final String? transactionId;
  final String? cardLastFour;
  final String? authCode;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? errorMessage;
  final Map<String, dynamic> metadata;

  PaymentHistoryRecord({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    required this.timestamp,
    this.transactionId,
    this.cardLastFour,
    this.authCode,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.errorMessage,
    this.metadata = const {},
  });

  factory PaymentHistoryRecord.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryRecord(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      status: PaymentStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => PaymentStatus.failed,
      ),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      transactionId: json['transactionId'],
      cardLastFour: json['cardLastFour'],
      authCode: json['authCode'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerEmail: json['customerEmail'],
      errorMessage: json['errorMessage'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'paymentMethod': paymentMethod,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'transactionId': transactionId,
      'cardLastFour': cardLastFour,
      'authCode': authCode,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'errorMessage': errorMessage,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return 'PaymentHistoryRecord(id: $id, orderId: $orderId, amount: $amount $currency, method: $paymentMethod, status: ${status.name})';
  }
}

/// Payment Statistics Model
class PaymentStats {
  final int totalPayments;
  final int successfulPayments;
  final int failedPayments;
  final double totalAmount;
  final double successRate;
  final Map<String, int> methodStats;
  final Map<String, int> dailyStats;
  final DateTime lastUpdated;

  PaymentStats({
    required this.totalPayments,
    required this.successfulPayments,
    required this.failedPayments,
    required this.totalAmount,
    required this.successRate,
    required this.methodStats,
    required this.dailyStats,
    required this.lastUpdated,
  });

  factory PaymentStats.empty() {
    return PaymentStats(
      totalPayments: 0,
      successfulPayments: 0,
      failedPayments: 0,
      totalAmount: 0.0,
      successRate: 0.0,
      methodStats: {},
      dailyStats: {},
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPayments': totalPayments,
      'successfulPayments': successfulPayments,
      'failedPayments': failedPayments,
      'totalAmount': totalAmount,
      'successRate': successRate,
      'methodStats': methodStats,
      'dailyStats': dailyStats,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

/// Payment Status Enum
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
}