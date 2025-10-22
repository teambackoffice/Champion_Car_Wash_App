import 'package:champion_car_wash_app/controller/oil_tech/new_oiltech_controller.dart';
import 'package:champion_car_wash_app/controller/service_underproccessing_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewBookingsTab extends StatefulWidget {
  const NewBookingsTab({super.key});

  @override
  State<NewBookingsTab> createState() => _NewBookingsTabState();
}

class _NewBookingsTabState extends State<NewBookingsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewOilTechController>(
        context,
        listen: false,
      ).getNewOilTechServices(serviceType: 'Oil Change');
    });
  }
  // Sample data - replace with your actual data source

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? theme.scaffoldBackgroundColor : Colors.grey[100],
      body: Consumer<NewOilTechController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.red[800]),
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
          final bookings = controller.innerMessage?.data ?? [];

          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                'No new bookings available',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final data = bookings[index];
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
                                        Icons.oil_barrel,
                                        color: isDarkMode
                                            ? Colors.green[300]
                                            : Colors.green[700],
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        data.serviceId,
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
                                  'NEW',
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
                                _buildDetailRow('Reg No', data.registrationNumber, context),
                                _buildDetailRow(
                                  'Booking Date',
                                  DateFormat('dd MMM yyyy').format(data.purchaseDate),
                                  context,
                                ),
                                _buildDetailRow('Customer', data.customerName, context),
                                _buildDetailRow('Vehicle', data.make, context),
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
                                      Icons.build_circle,
                                      color: isDarkMode
                                          ? Colors.green[300]
                                          : Colors.green[700],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Selected Services (${data.services.length})',
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
                                ...data.services.map(
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
                                          Icons.check_circle,
                                          color: isDarkMode
                                              ? Colors.green[300]
                                              : Colors.green[700],
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            service.serviceType,
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

                        const SizedBox(height: 20),

                        // Start Service button
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
                                                          'Oil Change',
                                                        );
                                                    Navigator.of(context).pop();
                                                    Provider.of<
                                                          NewOilTechController
                                                        >(
                                                          context,
                                                          listen: false,
                                                        )
                                                        .getNewOilTechServices(
                                                          serviceType:
                                                              'Oil Change',
                                                        );
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red[900],
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                ));
            },
          );
        },
      ),
    );
  }
}

Widget _buildDetailRow(String label, String value, BuildContext context) {
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
            style: TextStyle(fontSize: 13, color: theme.textTheme.bodySmall?.color),
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
