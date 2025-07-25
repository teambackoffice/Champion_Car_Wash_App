import 'package:champion_car_wash_app/controller/car_wash_tech/inprogress_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/inspection_list_controller.dart';
import 'package:champion_car_wash_app/modal/car_wash_tech/inprogress_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InprogressCarWashController>(
        context,
        listen: false,
      ).fetchInProgressServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<InprogressCarWashController>(
        builder: (context, controller, child) {
          final processingBookings =
              controller.carWashInProgressModal?.message.data ?? [];
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.red[800]),
            );
          }
          if (processingBookings.isEmpty) {
            return Center(
              child: Text(
                'No processing bookings found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: processingBookings.length,
            itemBuilder: (context, index) {
              final booking = processingBookings[index];
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
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Processing',
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
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(booking.purchaseDate),
                        ),
                        _buildDetailRow(
                          'Registration No',
                          booking.registrationNumber,
                        ),
                        _buildDetailRow('User Name', booking.customerName),
                        const SizedBox(height: 8),
                        const Text(
                          'Selected Services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...booking.services.map(
                          (service) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              service.washType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showInspectionDialog(context, booking),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Vehicle Inspection',
                              style: TextStyle(fontSize: 16),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InspectionListController>(
        context,
        listen: false,
      ).fetchInspectionList('car wash');
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                                : Colors.black87,
                          ),
                        ),
                        value: item.isChecked,
                        onChanged: (bool? value) {
                          controller.toggleCheck(index, value ?? false);
                        },
                        activeColor: Colors.red[800],
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
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
                backgroundColor: Colors.red[800],
                foregroundColor: Colors.white,
              ),
              child: const Text('Complete Service'),
            ),
          ],
        );
      },
    );
  }

  void _completeInspection(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Car wash completed for ${widget.booking.serviceId}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    // ✅ TODO: Add backend completion logic if needed
  }
}
