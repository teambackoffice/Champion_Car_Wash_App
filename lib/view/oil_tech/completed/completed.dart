import 'package:champion_car_wash_app/controller/oil_tech/completed_oil_controller.dart';
import 'package:champion_car_wash_app/modal/oil_tech/completed_oil_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CompletedBookingsTab extends StatefulWidget {
  const CompletedBookingsTab({super.key});

  @override
  State<CompletedBookingsTab> createState() => _CompletedBookingsTabState();
}

class _CompletedBookingsTabState extends State<CompletedBookingsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompletedOilController>(
        context,
        listen: false,
      ).fetchCompletedOilData();
    });
  }

  // Sample data - replace with your actual data source
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<CompletedOilController>(
        builder: (context, completedOilController, child) {
          if (completedOilController.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.red[800]),
            );
          }

          if (completedOilController.error != null) {
            return Center(
              child: Text('Error: ${completedOilController.error}'),
            );
          }

          final completedBookings =
              completedOilController.oilCompletedModal?.message.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: completedBookings.length,
            itemBuilder: (context, index) {
              return CompletedBookingCard(booking: completedBookings[index]);
            },
          );
        },
      ),
    );
  }
}

class CompletedBookingCard extends StatelessWidget {
  final Datum booking;

  const CompletedBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: isDarkMode ? 6 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: theme.cardColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.green.withOpacity(0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Header with icon
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
                              color: isDarkMode
                                  ? Colors.green[300]
                                  : Colors.green[700],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              booking.serviceId,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color,
                              ),
                            ),
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
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'DONE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                      if (booking.purchaseDate != null)
                        _buildDetailRow(
                          context,
                          'Booking Date',
                          DateFormat('dd MMM yyyy').format(booking.purchaseDate!),
                        ),
                      if (booking.customerName != null)
                        _buildDetailRow(context, 'Customer', booking.customerName!),
                      if (booking.model != null)
                        _buildDetailRow(context, 'Vehicle', booking.model!),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Enhanced Services Section
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
                            Icons.verified,
                            color: isDarkMode
                                ? Colors.green[300]
                                : Colors.green[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Completed Services (${booking.services.where((s) => s.oilBrand != null).length})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.green[300]
                                  : Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...booking.services
                          .where((service) => service.oilBrand != null)
                          .map(
                            (service) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: isDarkMode
                                        ? Colors.green[300]
                                        : Colors.green[700],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      service.oilBrand!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: theme.textTheme.bodyMedium?.color,
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
                const SizedBox(height: 16),

              // Tap to view details hint
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(Icons.touch_app, size: 16, color: Colors.grey[600]),
              //     const SizedBox(width: 4),
              //     Text(
              //       'Tap to view full details',
              //       style: TextStyle(
              //         fontSize: 12,
              //         color: Colors.grey[600],
              //         fontStyle: FontStyle.italic,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
                color: isDarkMode ? Colors.grey[300] : Colors.grey,
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

  String _formatCompletedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
