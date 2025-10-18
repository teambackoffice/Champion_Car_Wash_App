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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? theme.scaffoldBackgroundColor : Colors.grey[100],
      body: Consumer<InprogressCarWashController>(
        builder: (context, controller, child) {
          final processingBookings =
              controller.carWashInProgressModal?.message.data ?? [];
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          }
          if (processingBookings.isEmpty) {
            return Center(
              child: Text(
                'No processing bookings found',
                style: TextStyle(fontSize: 18, color: theme.textTheme.bodySmall?.color),
              ),
            );
          }

          if (controller.error != null) {
            return Center(child: Text('Error: ${controller.error}', style: TextStyle(color: theme.colorScheme.error)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: processingBookings.length,
            itemBuilder: (context, index) {
              final booking = processingBookings[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  elevation: isDarkMode ? 4 : 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: theme.cardColor,
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color,
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
                        Text(
                          'Selected Services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...booking.services.map(
                              (service) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              service.washType,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.textTheme.bodyLarge?.color,
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
                              backgroundColor: isDarkMode ? theme.primaryColor : Colors.red[700],
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
                  style: TextStyle(fontSize: 14, color: theme.textTheme.bodySmall?.color),
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
                        contentPadding: const EdgeInsets.symmetric(
                          
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
    final inspectionController = Provider.of<InspectionListController>(
      context,
      listen: false,
    );
    final completeController =
    Provider.of<CarWashInProgressToCompleteController>(
      context,
      listen: false,
    );

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

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Call the API
      await completeController.submitCarwash(
        serviceId: widget.booking.serviceId,
        price: 200, // Adjust as needed
        carwashTotal: widget.booking.services.length,
        inspectionType: 'car wash',
        answers: answers,
      );

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Close inspection dialog
      if (context.mounted) Navigator.of(context).pop();

      if (completeController.errorMessage != null) {
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
        if (context.mounted) {
          Provider.of<InprogressCarWashController>(
            context,
            listen: false,
          ).fetchInProgressServices();
        }
      }
    } catch (e) {
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

