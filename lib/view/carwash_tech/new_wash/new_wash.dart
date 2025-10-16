import 'package:champion_car_wash_app/controller/car_wash_tech/new_car_wash_contoller.dart';
import 'package:champion_car_wash_app/controller/service_underproccessing_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CarWashNewBookings extends StatefulWidget {
  const CarWashNewBookings({super.key});

  @override
  State<CarWashNewBookings> createState() => _CarWashNewBookingsState();
}

class _CarWashNewBookingsState extends State<CarWashNewBookings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetNewCarWashController>(
        context,
        listen: false,
      ).getNewCarWashServices(serviceType: 'car wash');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<GetNewCarWashController>(
        builder: (context, controller, child) {
          final booking =
              controller.carWashNewModalClass?.data ??
              []; // ✅ Proper initialization
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.red[800]),
            );
          }
          if (booking.isEmpty) {
            return Center(
              child: Text(
                'No new bookings found',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Text(
                'Error: ${controller.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: booking.length,
            itemBuilder: (context, index) {
              final data = booking[index]; // ✅ Proper initialization
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
                        // Header with booking ID and New badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.serviceId,
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
                                'New',
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
                        _buildDetailRow('Reg No', data.registrationNumber),
                        _buildDetailRow(
                          'Booking Date',
                          DateFormat('dd MMM yyyy').format(data.purchaseDate),
                        ),
                        _buildDetailRow('User Name', data.customerName),
                        _buildDetailRow('Vehicle', data.make),

                        const SizedBox(height: 8),

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
                        ...data.services.map(
                          (service) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              service.washType!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirmation'),
                                    content: const Text(
                                      ' Are you sure you want to start service ?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pop(); // Close the dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      Consumer<
                                        ServiceUnderproccessingController
                                      >(
                                        builder: (context, controller, child) {
                                          return ElevatedButton(
                                            onPressed: controller.isLoading
                                                ? null
                                                : () async {
                                                    await controller
                                                        .markServiceInProgress(
                                                          data.serviceId,
                                                          'Car Wash',
                                                        );
                                                    Navigator.of(context).pop();
                                                    Provider.of<
                                                          GetNewCarWashController
                                                        >(
                                                          context,
                                                          listen: false,
                                                        )
                                                        .getNewCarWashServices(
                                                          serviceType:
                                                              'car wash',
                                                        );
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red[900],
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 12,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: controller.isLoading
                                                ? const SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : const Text('Yes'),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            // _startService(context, booking.bookingId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Start Service',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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

  void _startService(BuildContext context, String bookingId) {
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
                    backgroundColor: Colors.red[800],
                    foregroundColor: Colors.white,
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
