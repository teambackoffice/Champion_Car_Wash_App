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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompletedCarController>(
        context,
        listen: false,
      ).fetchCompletedCarServiceData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<CompletedCarController>(
        builder: (context, completedCarController, child) {
          if (completedCarController.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.red[800]),
            );
          }

          if (completedCarController.error != null) {
            return Center(
              child: Text('Error: ${completedCarController.error}'),
            );
          }

          final completedBookings =
              completedCarController.completedCarModal?.message.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: completedBookings.length,
            itemBuilder: (context, index) {
              final booking = completedBookings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              booking.serviceId,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
                        _buildDetailRow(
                          'Booking Date',
                          DateFormat('dd MMM yyyy').format(
                            DateTime.parse(booking.purchaseDate.toString()),
                          ),
                        ),
                        _buildDetailRow('User Name', booking.customerName),
                        // _buildDetailRow('Mobile No', booking.mobileNo),
                        // _buildDetailRow('Email ID', booking.email),
                        _buildDetailRow('Vehicle', booking.model),

                        // _buildDetailRow('Engine Model', booking.engineModel),
                        const SizedBox(height: 12),
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
                              service.washType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
