import 'package:champion_car_wash_app/controller/car_wash_tech/inprogress_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/inspection_list_controller.dart';
import 'package:champion_car_wash_app/modal/car_wash_tech/inprogress_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../service/car_wash_tech/inprogress_to_complete_service.dart';

class InspectionItem {
  final String title;
  bool isChecked;

  InspectionItem({required this.title, this.isChecked = false});
}

class CarWashUnderProcessing extends StatefulWidget {
  const CarWashUnderProcessing({super.key});

  @override
  State<CarWashUnderProcessing> createState() => _CarWashUnderProcessingState();
}

class _CarWashUnderProcessingState extends State<CarWashUnderProcessing> {
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

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      await Provider.of<InprogressCarWashController>(
        context,
        listen: false,
      ).fetchInProgressServices();

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
      await Provider.of<InprogressCarWashController>(
        context,
        listen: false,
      ).fetchInProgressServices();

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

    return Scaffold(
      backgroundColor: isDarkMode
          ? theme.scaffoldBackgroundColor
          : Colors.grey[50],
      body: Column(
        children: [
          // Enhanced Header with Timer and Status
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[600]!, Colors.orange[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.hourglass_empty, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Services in Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Monitor and complete ongoing services',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Active',
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

          // Processing List
          Expanded(
            child: Consumer<InprogressCarWashController>(
              builder: (context, controller, child) {
                final processingBookings =
                    controller.carWashInProgressModal?.message.data ?? [];

                if (_isInitialLoading || controller.isLoading) {
                  return _buildLoadingState(context);
                }

                if (processingBookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 64,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No services in progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Started services will appear here',
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
                          'Error loading services',
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
                            Provider.of<InprogressCarWashController>(
                              context,
                              listen: false,
                            ).fetchInProgressServices();
                          },
                          child: const Text('Retry'),
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
                    itemCount: processingBookings.length,
                    itemBuilder: (context, index) {
                      final booking = processingBookings[index];
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
                                color: Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Enhanced Header with Timer
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.orange
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.build,
                                                color: Colors.orange,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    booking.serviceId,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme
                                                          .textTheme
                                                          .titleLarge
                                                          ?.color,
                                                    ),
                                                  ),
                                                  Text(
                                                    'In Progress • ${_getElapsedTime(booking.purchaseDate)}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                colors: [
                                                  Colors.orange,
                                                  Colors.orange[600]!,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.orange
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.timer,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  'ACTIVE',
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
                                              color: Colors.green.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '${_getProgressPercentage(booking)}%',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Progress Bar
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.grey[800]?.withOpacity(0.3)
                                          : Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Service Progress',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color,
                                              ),
                                            ),
                                            Text(
                                              '${_getProgressPercentage(booking)}%',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        LinearProgressIndicator(
                                          value:
                                              _getProgressPercentage(booking) /
                                              100,
                                          backgroundColor: Colors.grey[300],
                                          valueColor:
                                              const AlwaysStoppedAnimation<Color>(
                                                Colors.orange,
                                              ),
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
                                          ? Colors.blue[900]?.withOpacity(0.1)
                                          : Colors.blue[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blue.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(
                                              Icons.directions_car,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Vehicle Details',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        _buildEnhancedDetailRow(
                                          Icons.confirmation_number,
                                          'Registration',
                                          booking.registrationNumber,
                                        ),
                                        _buildEnhancedDetailRow(
                                          Icons.person,
                                          'Customer',
                                          booking.customerName,
                                        ),
                                        _buildEnhancedDetailRow(
                                          Icons.car_rental,
                                          'Vehicle',
                                          '${booking.make} ${booking.model ?? ''}',
                                        ),
                                        _buildEnhancedDetailRow(
                                          Icons.calendar_today,
                                          'Started',
                                          DateFormat(
                                            'dd MMM yyyy, hh:mm a',
                                          ).format(booking.purchaseDate),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Services Section
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.cleaning_services,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Services in Progress (${booking.services.length})',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        ...booking.services.map(
                                          (service) => Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.green.withOpacity(
                                                  0.2,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.build,
                                                  color: Colors.orange,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    service.washType,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: theme
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'Active',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  const SizedBox(height: 24),

                                  // Action Buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _showServiceNotes(
                                            context,
                                            booking,
                                          ),
                                          icon: const Icon(
                                            Icons.note_add_outlined,
                                            size: 18,
                                          ),
                                          label: const Text('Add Notes'),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            side: const BorderSide(
                                              color: Colors.blue,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton.icon(
                                          onPressed: () =>
                                              _showInspectionDialog(
                                                context,
                                                booking,
                                              ),
                                          icon: const Icon(Icons.checklist, size: 20),
                                          label: const Text(
                                            'Complete Inspection',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isDarkMode
                                                ? theme.primaryColor
                                                : Colors.green[600],
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 4,
                                            shadowColor: Colors.green
                                                .withOpacity(0.3),
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
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodySmall?.color,
              ),
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

  String _getElapsedTime(DateTime startTime) {
    final now = DateTime.now();
    final difference = now.difference(startTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    }
  }

  int _getProgressPercentage(Datum booking) {
    // Calculate progress based on elapsed time and estimated completion time
    final elapsed = DateTime.now().difference(booking.purchaseDate).inMinutes;
    final estimatedTotal =
        booking.services.length * 20; // 20 minutes per service
    final progress = (elapsed / estimatedTotal * 100).clamp(0, 95).toInt();
    return progress;
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
              colors: [
                Colors.orange.withOpacity(0.1),
                Colors.orange.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loading Active Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fetching services in progress...',
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
            itemCount: 2,
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
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
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
              _buildShimmerBox(80, 24, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 20),

          // Progress bar shimmer
          _buildShimmerBox(double.infinity, 8, borderRadius: 4),
          const SizedBox(height: 16),

          // Content shimmer
          _buildShimmerBox(double.infinity, 12),
          const SizedBox(height: 8),
          _buildShimmerBox(200, 12),
          const SizedBox(height: 16),

          // Button shimmer
          _buildShimmerBox(double.infinity, 48, borderRadius: 12),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(
    double width,
    double height, {
    double borderRadius = 8,
    bool isCircle = false,
  }) {
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

  void _showServiceNotes(BuildContext context, Datum booking) {
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Service Notes - ${booking.serviceId}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add notes about the service progress or any observations:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your notes here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
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
                const SnackBar(
                  content: Text('Notes saved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Save Notes'),
          ),
        ],
      ),
    );
  }

  void _showInspectionDialog(BuildContext context, Datum booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InspectionDialog(booking: booking);
      },
    );
  }
}

class InspectionDialog extends StatefulWidget {
  const InspectionDialog({super.key, required this.booking});

  final Datum booking;

  @override
  State<InspectionDialog> createState() => _InspectionDialogState();
}

class _InspectionDialogState extends State<InspectionDialog> {
  @override
  void initState() {
    super.initState();
    print('🚗 [CAR_WASH_INSPECTION] Initializing car wash inspection dialog for booking: ${widget.booking.serviceId}');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🚗 [CAR_WASH_INSPECTION] Fetching inspection list for car wash...');
      Provider.of<InspectionListController>(
        context,
        listen: false,
      ).fetchInspectionList('car wash');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Consumer<InspectionListController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error != null) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(controller.error!),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        }
        final inspectionItems = controller.inspectionItems;

        return AlertDialog(
          title: Text('Car Wash Checklist - ${widget.booking.serviceId}'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Vehicle: ${widget.booking.make} - ${widget.booking.model}',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: inspectionItems.length,
                    itemBuilder: (context, index) {
                      final item = inspectionItems[index];
                      return CheckboxListTile(
                        title: Text(
                          item.questions,
                          style: TextStyle(
                            fontSize: 14,
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.isChecked
                                ? Colors.grey
                                : theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        value: item.isChecked,
                        onChanged: (bool? value) {
                          controller.toggleCheck(index, value ?? false);
                        },
                        activeColor: theme.primaryColor,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: controller.allItemsChecked
                  ? () => _completeInspection(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Complete Service'),
            ),
          ],
        );
      },
    );
  }

  void _completeInspection(BuildContext context) async {
    print('🚗 [CAR_WASH_INSPECTION] Starting _completeInspection for booking: ${widget.booking.serviceId}');
    
    final inspectionController = Provider.of<InspectionListController>(
      context,
      listen: false,
    );
    final completeController =
        Provider.of<CarWashInProgressToCompleteController>(
          context,
          listen: false,
        );

    print('🚗 [CAR_WASH_INSPECTION] Inspection items count: ${inspectionController.inspectionItems.length}');

    // Prepare answers from inspection items
    List<Map<String, dynamic>> answers = inspectionController.inspectionItems
        .map(
          (item) => {
            'question': item.questions,
            'answer': item.isChecked ? 'Yes' : 'No',
            'is_checked': item.isChecked,
          },
        )
        .toList();

    print('🚗 [CAR_WASH_INSPECTION] Prepared answers: ${answers.length} items');
    for (int i = 0; i < answers.length; i++) {
      print('🚗 [CAR_WASH_INSPECTION] Answer $i: ${answers[i]}');
    }

    try {
      print('🚗 [CAR_WASH_INSPECTION] Starting API submission process...');
      
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      print('🚗 [CAR_WASH_INSPECTION] Calling submitCarwash with parameters:');
      print('🚗 [CAR_WASH_INSPECTION] - Service ID: ${widget.booking.serviceId}');
      print('🚗 [CAR_WASH_INSPECTION] - Price: 200');
      print('🚗 [CAR_WASH_INSPECTION] - Car wash total: ${widget.booking.services.length}');
      print('🚗 [CAR_WASH_INSPECTION] - Inspection type: car wash');

      // Call the API
      await completeController.submitCarwash(
        serviceId: widget.booking.serviceId,
        price: 200, // Adjust as needed
        carwashTotal: widget.booking.services.length,
        inspectionType: 'car wash',
        answers: answers,
      );

      print('🚗 [CAR_WASH_INSPECTION] API call completed');

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Close inspection dialog
      if (context.mounted) Navigator.of(context).pop();

      if (completeController.errorMessage != null) {
        print('❌ [CAR_WASH_INSPECTION] Error from controller: ${completeController.errorMessage}');
        
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${completeController.errorMessage}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        print('✅ [CAR_WASH_INSPECTION] Car wash completed successfully');
        
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Car wash completed for ${widget.booking.serviceId}',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Refresh the list
        print('🚗 [CAR_WASH_INSPECTION] Refreshing in-progress services list...');
        if (context.mounted) {
          Provider.of<InprogressCarWashController>(
            context,
            listen: false,
          ).fetchInProgressServices();
        }
      }
    } catch (e) {
      print('❌ [CAR_WASH_INSPECTION] Exception during service completion: $e');
      
      // Close loading dialog if still open
      if (context.mounted) Navigator.of(context).pop();

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing service: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
