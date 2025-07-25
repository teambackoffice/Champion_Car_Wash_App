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
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with booking ID and Completed badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.serviceId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Car details
              _buildDetailRow(
                'Booking Date',
                DateFormat('dd MMM YYYY').format(booking.purchaseDate),
              ),
              _buildDetailRow('User Name', booking.customerName),
              // _buildDetailRow('Mobile No', booking.mobileNo),
              // _buildDetailRow('Email ID', booking.email),
              _buildDetailRow('Vehicle', booking.model),
              // _buildDetailRow('Engine Model', booking.engineModel),
              // _buildDetailRow('Completed By', booking.completedBy),
              // _buildDetailRow(
              //   'Completed On',
              //   _formatCompletedDate(booking.completedDate),
              // ),

              // const SizedBox(height: 16),

              // Selected Services
              const Text(
                'Selected Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Services list
              ...booking.services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    service.oilBrand,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
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
