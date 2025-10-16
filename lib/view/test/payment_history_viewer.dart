import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../service/payment_history_service.dart';

class PaymentHistoryViewer extends StatefulWidget {
  const PaymentHistoryViewer({Key? key}) : super(key: key);

  @override
  State<PaymentHistoryViewer> createState() => _PaymentHistoryViewerState();
}

class _PaymentHistoryViewerState extends State<PaymentHistoryViewer> {
  List<PaymentHistoryRecord> _payments = [];
  List<PaymentHistoryRecord> _filteredPayments = [];
  PaymentStats? _stats;
  String _searchQuery = '';
  PaymentStatus? _statusFilter;
  String? _methodFilter;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeHistory();
    _setupHistoryListener();
  }

  Future<void> _initializeHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await PaymentHistoryService.instance.initialize();
      await _loadPaymentHistory();
    } catch (e) {
      print('Error initializing payment history: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setupHistoryListener() {
    PaymentHistoryService.instance.historyStream.listen((payments) {
      setState(() {
        _payments = payments;
        _applyFilters();
      });
    });
  }

  Future<void> _loadPaymentHistory() async {
    try {
      final payments = PaymentHistoryService.instance.paymentHistory;
      final stats = await PaymentHistoryService.instance.getPaymentStats();
      
      setState(() {
        _payments = payments;
        _stats = stats;
        _applyFilters();
      });
    } catch (e) {
      print('Error loading payment history: $e');
    }
  }

  void _applyFilters() {
    List<PaymentHistoryRecord> filtered = _payments;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = PaymentHistoryService.instance.searchPayments(_searchQuery);
    }

    // Apply status filter
    if (_statusFilter != null) {
      filtered = filtered.where((p) => p.status == _statusFilter).toList();
    }

    // Apply method filter
    if (_methodFilter != null && _methodFilter!.isNotEmpty) {
      filtered = filtered.where((p) => p.paymentMethod == _methodFilter).toList();
    }

    setState(() {
      _filteredPayments = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _onStatusFilterChanged(PaymentStatus? status) {
    setState(() {
      _statusFilter = status;
    });
    _applyFilters();
  }

  void _onMethodFilterChanged(String? method) {
    setState(() {
      _methodFilter = method;
    });
    _applyFilters();
  }

  Future<void> _exportHistory() async {
    try {
      final jsonData = await PaymentHistoryService.instance.exportHistoryAsJson();
      await Clipboard.setData(ClipboardData(text: jsonData));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment history exported to clipboard'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Payment History'),
        content: const Text('Are you sure you want to clear all payment history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await PaymentHistoryService.instance.clearHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment history cleared'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportHistory,
            tooltip: 'Export History',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearHistory,
            tooltip: 'Clear History',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPaymentHistory,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Statistics Section
                if (_stats != null) _buildStatsSection(),
                
                // Filters Section
                _buildFiltersSection(),
                
                // Payment List
                Expanded(
                  child: _filteredPayments.isEmpty
                      ? _buildEmptyState()
                      : _buildPaymentList(),
                ),
              ],
            ),
    );
  }

  Widget _buildStatsSection() {
    final stats = _stats!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade50,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Payments',
                  stats.totalPayments.toString(),
                  Icons.payment,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Successful',
                  stats.successfulPayments.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Failed',
                  stats.failedPayments.toString(),
                  Icons.error,
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Amount',
                  '\$${stats.totalAmount.toStringAsFixed(2)}',
                  Icons.attach_money,
                  Colors.purple,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Success Rate',
                  '${stats.successRate.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    final uniqueMethods = _payments.map((p) => p.paymentMethod).toSet().toList();
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search by order ID, transaction ID, customer...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 12),
          
          // Filter chips
          Row(
            children: [
              // Status filter
              Expanded(
                child: DropdownButtonFormField<PaymentStatus?>(
                  initialValue: _statusFilter,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem<PaymentStatus?>(
                      value: null,
                      child: Text('All Statuses'),
                    ),
                    ...PaymentStatus.values.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.name.toUpperCase()),
                    )),
                  ],
                  onChanged: _onStatusFilterChanged,
                ),
              ),
              const SizedBox(width: 12),
              
              // Method filter
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: _methodFilter,
                  decoration: const InputDecoration(
                    labelText: 'Method',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All Methods'),
                    ),
                    ...uniqueMethods.map((method) => DropdownMenuItem(
                      value: method,
                      child: Text(method),
                    )),
                  ],
                  onChanged: _onMethodFilterChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _payments.isEmpty 
                ? 'No payment history yet'
                : 'No payments match your filters',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _payments.isEmpty
                ? 'Make some payments to see them here'
                : 'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList() {
    return ListView.builder(
      // OPTIMIZATION: Cache items outside viewport for smoother scrolling
      cacheExtent: 500,
      itemCount: _filteredPayments.length,
      itemBuilder: (context, index) {
        final payment = _filteredPayments[index];
        return _buildPaymentCard(payment);
      },
    );
  }

  Widget _buildPaymentCard(PaymentHistoryRecord payment) {
    final statusColor = _getStatusColor(payment.status);
    final statusIcon = _getStatusIcon(payment.status);
    
    return RepaintBoundary(
      key: ValueKey(payment.id),
      child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(
          'Order: ${payment.orderId}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${payment.amount.toStringAsFixed(2)} ${payment.currency}'),
            Text(
              payment.paymentMethod,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                payment.status.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(payment.timestamp),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Payment ID', payment.id),
                if (payment.transactionId != null)
                  _buildDetailRow('Transaction ID', payment.transactionId!),
                if (payment.cardLastFour != null)
                  _buildDetailRow('Card', '**** **** **** ${payment.cardLastFour}'),
                if (payment.authCode != null)
                  _buildDetailRow('Auth Code', payment.authCode!),
                if (payment.customerName != null)
                  _buildDetailRow('Customer', payment.customerName!),
                if (payment.customerPhone != null)
                  _buildDetailRow('Phone', payment.customerPhone!),
                if (payment.customerEmail != null)
                  _buildDetailRow('Email', payment.customerEmail!),
                if (payment.errorMessage != null)
                  _buildDetailRow('Error', payment.errorMessage!, isError: true),
                _buildDetailRow('Timestamp', payment.timestamp.toIso8601String()),
                
                // Metadata
                if (payment.metadata.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Metadata:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...payment.metadata.entries.map((entry) =>
                    _buildDetailRow(entry.key, entry.value.toString())),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isError ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.processing:
        return Colors.orange;
      case PaymentStatus.pending:
        return Colors.blue;
      case PaymentStatus.cancelled:
        return Colors.grey;
      case PaymentStatus.refunded:
        return Colors.purple;
    }
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.completed:
        return Icons.check_circle;
      case PaymentStatus.failed:
        return Icons.error;
      case PaymentStatus.processing:
        return Icons.hourglass_empty;
      case PaymentStatus.pending:
        return Icons.schedule;
      case PaymentStatus.cancelled:
        return Icons.cancel;
      case PaymentStatus.refunded:
        return Icons.undo;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}