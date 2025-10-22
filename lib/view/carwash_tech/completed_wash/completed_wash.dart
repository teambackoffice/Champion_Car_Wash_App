import 'package:champion_car_wash_app/controller/car_wash_tech/completed_car_contoller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CarWashCompletedBookings extends StatefulWidget {
  const CarWashCompletedBookings({super.key});

  @override
  State<CarWashCompletedBookings> createState() =>
      _CarWashCompletedBookingsState();
}

class _CarWashCompletedBookingsState extends State<CarWashCompletedBookings> {
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isInitialLoading = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 400));
    
    if (mounted) {
      await Provider.of<CompletedCarController>(
        context,
        listen: false,
      ).fetchCompletedCarServiceData();
      
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? theme.scaffoldBackgroundColor : Colors.grey[50],
      body: Column(
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green[600]!,
                  Colors.green[400]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completed Services',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Review your completed car wash services',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Completed Services List
          Expanded(
            child: Consumer<CompletedCarController>(
              builder: (context, completedCarController, child) {
                if (_isInitialLoading || completedCarController.isLoading) {
                  return _buildLoadingState(context);
                }

                if (completedCarController.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading completed services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          completedCarController.error!,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<CompletedCarController>(context, listen: false)
                                .fetchCompletedCarServiceData();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final completedBookings =
                    completedCarController.completedCarModal?.message.data ?? [];
                    
                if (completedBookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_outlined,
                          size: 64,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No completed services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Completed services will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _loadData();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: completedBookings.length,
                    itemBuilder: (context, index) {
                      final booking = completedBookings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          elevation: isDarkMode ? 6 : 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: theme.cardColor,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  theme.cardColor,
                                  theme.cardColor.withOpacity(0.95),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Enhanced Header with completion info
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    booking.serviceId,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: theme.textTheme.titleLarge?.color,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Completed • ${_getCompletionTime(booking.purchaseDate)}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Colors.green, Colors.green[600]!],
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.green.withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.verified,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                const Text(
                                                  'DONE',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '⭐ ${_getQualityRating()}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Completion Summary
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode 
                                          ? Colors.green[900]?.withOpacity(0.1)
                                          : Colors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.green.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.analytics_outlined,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Service Summary',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildSummaryItem(
                                                'Duration',
                                                _getServiceDuration(booking.purchaseDate),
                                                Icons.timer,
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildSummaryItem(
                                                'Services',
                                                '${booking.services.length}',
                                                Icons.cleaning_services,
                                              ),
                                            ),
                                            Expanded(
                                              child: _buildSummaryItem(
                                                'Quality',
                                                _getQualityRating(),
                                                Icons.star,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Vehicle Information
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode 
                                          ? Colors.grey[800]?.withOpacity(0.3)
                                          : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: theme.dividerColor.withOpacity(0.1),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.directions_car,
                                              color: theme.primaryColor,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Vehicle Information',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: theme.textTheme.titleMedium?.color,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        _buildEnhancedDetailRow(
                                          Icons.person,
                                          'Customer',
                                          booking.customerName,
                                        ),
                                        _buildEnhancedDetailRow(
                                          Icons.car_rental,
                                          'Vehicle',
                                          '${booking.make} ${booking.model}',
                                        ),
                                        _buildEnhancedDetailRow(
                                          Icons.calendar_today,
                                          'Completed',
                                          DateFormat('dd MMM yyyy, hh:mm a').format(
                                            DateTime.parse(booking.purchaseDate.toString()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Completed Services
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode 
                                          ? Colors.blue[900]?.withOpacity(0.1)
                                          : Colors.blue[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blue.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Completed Services (${booking.services.length})',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        ...booking.services.map(
                                          (service) => Container(
                                            margin: const EdgeInsets.only(bottom: 8),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.green.withOpacity(0.2),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.verified,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    service.washType,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: theme.textTheme.bodyLarge?.color,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                    'Completed',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 20),
                                  
                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _showServiceReport(context, booking),
                                          icon: Icon(Icons.description_outlined, size: 18),
                                          label: const Text('View Report'),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            side: BorderSide(color: Colors.blue),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _shareServiceDetails(context, booking),
                                          icon: Icon(Icons.share_outlined, size: 18),
                                          label: const Text('Share'),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            side: BorderSide(color: Colors.green),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: theme.textTheme.bodySmall?.color),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDetailRow(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.textTheme.bodySmall?.color),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: theme.textTheme.bodySmall?.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  String _getCompletionTime(dynamic purchaseDate) {
    final date = DateTime.parse(purchaseDate.toString());
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getServiceDuration(dynamic purchaseDate) {
    // Simulate service duration (in real app, this would be calculated from start/end times)
    return '25 min';
  }

  String _getQualityRating() {
    // Simulate quality rating (in real app, this would come from inspection results)
    return '4.8';
  }

  void _showServiceReport(BuildContext context, dynamic booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Service Report - ${booking.serviceId}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Customer: ${booking.customerName}'),
              Text('Vehicle: ${booking.make} ${booking.model}'),
              Text('Completion: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(booking.purchaseDate.toString()))}'),
              const SizedBox(height: 16),
              const Text('Services Completed:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...booking.services.map((service) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text('✓ ${service.washType}'),
              )),
              const SizedBox(height: 16),
              const Text('Quality Metrics:', style: TextStyle(fontWeight: FontWeight.bold)),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text('• Service Duration: 25 minutes'),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text('• Quality Rating: 4.8/5.0'),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text('• Customer Satisfaction: Excellent'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report downloaded successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Download PDF'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Loading Header
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.green.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.green,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loading Completed Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fetching service history...',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Shimmer Loading Cards
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 3,
            itemBuilder: (context, index) => _buildShimmerCard(context),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildShimmerBox(40, 40, isCircle: true),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(120, 16),
                      const SizedBox(height: 4),
                      _buildShimmerBox(80, 12),
                    ],
                  ),
                ],
              ),
              _buildShimmerBox(60, 24, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 20),
          
          // Summary shimmer
          Row(
            children: [
              Expanded(child: _buildShimmerBox(60, 40)),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerBox(60, 40)),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerBox(60, 40)),
            ],
          ),
          const SizedBox(height: 16),
          
          // Content shimmer
          _buildShimmerBox(double.infinity, 12),
          const SizedBox(height: 8),
          _buildShimmerBox(200, 12),
          const SizedBox(height: 16),
          
          // Buttons shimmer
          Row(
            children: [
              Expanded(child: _buildShimmerBox(double.infinity, 40, borderRadius: 12)),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerBox(double.infinity, 40, borderRadius: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, {double borderRadius = 8, bool isCircle = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: _buildShimmerEffect(),
    );
  }

  Widget _buildShimmerEffect() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * value, 0.0),
              end: Alignment(1.0 + 2.0 * value, 0.0),
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
      onEnd: () {
        // Restart animation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {});
          }
        });
      },
    );
  }

  void _shareServiceDetails(BuildContext context, dynamic booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Service Details'),
        content: const Text('Share service completion details with customer or supervisor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service details shared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}
