import 'package:champion_car_wash_app/controller/car_wash_tech/new_car_wash_contoller.dart';
import 'package:champion_car_wash_app/controller/service_underproccessing_controller.dart';
import 'package:champion_car_wash_app/widgets/loading/technician_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CarWashNewBookings extends StatefulWidget {
  const CarWashNewBookings({super.key});

  @override
  State<CarWashNewBookings> createState() => _CarWashNewBookingsState();
}

class _CarWashNewBookingsState extends State<CarWashNewBookings> {
  bool _isInitialLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isInitialLoading = true;
    });
    
    // Add a small delay to show the loading animation
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      await Provider.of<GetNewCarWashController>(
        context,
        listen: false,
      ).getNewCarWashServices(serviceType: 'car wash');
      
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });
    
    if (mounted) {
      await Provider.of<GetNewCarWashController>(
        context,
        listen: false,
      ).getNewCarWashServices(serviceType: 'car wash');
      
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryRed = isDarkMode ? Colors.red[700]! : Colors.red[800]!;

    return QuickLoadingOverlay(
      isLoading: _isRefreshing,
      message: 'Refreshing Bookings',
      color: primaryRed,
      child: Scaffold(
        backgroundColor: isDarkMode ? theme.scaffoldBackgroundColor : Colors.grey[50],
        body: Column(
        children: [
          // Enhanced Header with Search and Filter
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: theme.textTheme.bodySmall?.color),
                        const SizedBox(width: 8),
                        Text(
                          'Search bookings...',
                          style: TextStyle(color: theme.textTheme.bodySmall?.color),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => _showFilterOptions(context),
                  icon: Icon(Icons.filter_list, color: theme.primaryColor),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
          
          // Bookings List
          Expanded(
            child: Consumer<GetNewCarWashController>(
              builder: (context, controller, child) {
                final booking = controller.carWashNewModalClass?.data ?? [];
                
                if (_isInitialLoading || controller.isLoading) {
                  return _buildLoadingState(context);
                }
                
                if (booking.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No new bookings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'New car wash bookings will appear here',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.error != null) {
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
                          'Error loading bookings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.error!,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<GetNewCarWashController>(context, listen: false)
                                .getNewCarWashServices(serviceType: 'car wash');
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _refreshData();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: booking.length,
                    itemBuilder: (context, index) {
                      final data = booking[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        child: Card(
                          elevation: isDarkMode ? 6 : 3,
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
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Enhanced Header with priority indicator
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.local_car_wash,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.serviceId,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: theme.textTheme.titleLarge?.color,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Priority: ${_getPriority(index)}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: _getPriorityColor(index),
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
                                            child: const Text(
                                              'NEW',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _getTimeAgo(data.purchaseDate),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: theme.textTheme.bodySmall?.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  // Enhanced Vehicle Info Section
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
                                          Icons.confirmation_number,
                                          'Registration',
                                          data.registrationNumber,
                                        ),
                                        _buildEnhancedDetailRow(
                                          Icons.person,
                                          'Customer',
                                          data.customerName,
                                        ),
                                        _buildEnhancedDetailRow(
                                          Icons.car_rental,
                                          'Vehicle',
                                          '${data.make} ${data.model ?? ''}',
                                        ),
                                        _buildEnhancedDetailRow(
                                          Icons.calendar_today,
                                          'Booking Date',
                                          DateFormat('dd MMM yyyy, hh:mm a').format(data.purchaseDate),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),
                                  
                                  // Enhanced Services Section
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
                                              Icons.cleaning_services,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Selected Services (${data.services.length})',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        ...data.services.map(
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
                                                color: Colors.blue.withOpacity(0.2),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    service.washType!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: theme.textTheme.bodyLarge?.color,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '~${_getEstimatedTime(service.washType!)}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: theme.textTheme.bodySmall?.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Enhanced Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _showServiceDetails(context, data),
                                          icon: Icon(Icons.info_outline, size: 18),
                                          label: const Text('Details'),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            side: BorderSide(color: theme.primaryColor),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _showStartServiceDialog(context, data),
                                          icon: Icon(Icons.play_arrow, size: 20),
                                          label: const Text('Start Service'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isDarkMode 
                                                ? theme.primaryColor 
                                                : const Color(0xFFD32F2F),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            elevation: 4,
                                            shadowColor: Colors.red.withOpacity(0.3),
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyMedium?.color,
              ),
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

  String _getPriority(int index) {
    if (index == 0) return 'High';
    if (index == 1) return 'Medium';
    return 'Normal';
  }

  Color _getPriorityColor(int index) {
    if (index == 0) return Colors.red;
    if (index == 1) return Colors.orange;
    return Colors.green;
  }

  String _getTimeAgo(DateTime date) {
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

  String _getEstimatedTime(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'basic wash':
        return '15 min';
      case 'premium wash':
        return '30 min';
      case 'deluxe wash':
        return '45 min';
      default:
        return '20 min';
    }
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Options',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.priority_high, color: Colors.red),
              title: const Text('High Priority'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.access_time, color: Colors.orange),
              title: const Text('By Time'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.car_rental, color: Colors.blue),
              title: const Text('By Vehicle Type'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showServiceDetails(BuildContext context, dynamic data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Service Details - ${data.serviceId}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Customer', data.customerName),
              _buildDetailRow('Vehicle', '${data.make} ${data.model ?? ''}'),
              _buildDetailRow('Registration', data.registrationNumber),
              _buildDetailRow('Booking Date', 
                DateFormat('dd MMM yyyy, hh:mm a').format(data.purchaseDate)),
              const SizedBox(height: 16),
              const Text('Services:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...data.services.map((service) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text('• ${service.washType}'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryRed = isDarkMode ? Colors.red[700]! : Colors.red[800]!;

    return Column(
      children: [
        // Loading Header
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryRed.withOpacity(0.1), primaryRed.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryRed.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: primaryRed,
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
                      'Loading New Bookings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryRed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fetching latest car wash bookings...',
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
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          
          // Content shimmer
          _buildShimmerBox(double.infinity, 12),
          const SizedBox(height: 8),
          _buildShimmerBox(200, 12),
          const SizedBox(height: 8),
          _buildShimmerBox(150, 12),
          const SizedBox(height: 16),
          
          // Services shimmer
          Row(
            children: [
              _buildShimmerBox(80, 12),
              const SizedBox(width: 8),
              _buildShimmerBox(60, 12),
            ],
          ),
          const SizedBox(height: 12),
          _buildShimmerBox(100, 12),
          const SizedBox(height: 20),
          
          // Button shimmer
          _buildShimmerBox(double.infinity, 48, borderRadius: 12),
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

  void _showStartServiceDialog(BuildContext context, dynamic data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.play_circle_filled, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              const Text('Start Service'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you ready to start the car wash service for:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service ID: ${data.serviceId}', 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Vehicle: ${data.make} ${data.model ?? ''}'),
                    Text('Customer: ${data.customerName}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This will move the booking to "Under Process" status.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            Consumer<ServiceUnderproccessingController>(
              builder: (context, controller, child) {
                return ElevatedButton.icon(
                  onPressed: controller.isLoading
                      ? null
                      : () async {
                          await controller.markServiceInProgress(
                            data.serviceId,
                            'Car Wash',
                          );
                          Navigator.of(context).pop();
                          Provider.of<GetNewCarWashController>(
                            context,
                            listen: false,
                          ).getNewCarWashServices(serviceType: 'car wash');
                        },
                  icon: controller.isLoading
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(Icons.play_arrow),
                  label: Text(controller.isLoading ? 'Starting...' : 'Start Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _startService(BuildContext context, String bookingId) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(' $bookingId'),
              content: const Text(
                'Are You Sure You Want To Start Service ?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Started car wash for $bookingId'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // TODO: Call backend API to mark car wash service started
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? theme.primaryColor : Colors.red[800],
                    foregroundColor: isDarkMode ? Colors.white : Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  child: const Text('Start Service'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
