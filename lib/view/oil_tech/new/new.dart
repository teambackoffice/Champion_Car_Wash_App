import 'package:champion_car_wash_app/controller/oil_tech/new_oiltech_controller.dart';
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
      ).getNewOilTechServices();
    });
  }
  // Sample data - replace with your actual data source

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          final bookings = controller.oilTechModalClass?.message.data ?? [];

          if (bookings.isEmpty) {
            return Center(
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

                        // Booking details
                        _buildDetailRow('Reg No', data.registrationNumber),
                        _buildDetailRow(
                          'Booking Date',
                          DateFormat('dd MM yyyy').format(data.purchaseDate),
                        ),
                        _buildDetailRow('Customer Name', data.customerName),
                        _buildDetailRow('Vehicle', data.make),

                        // _buildDetailRow('User Name', booking.userName),
                        // _buildDetailRow('Mobile No', booking.mobileNo),
                        // _buildDetailRow('Email ID', booking.email),
                        // _buildDetailRow('Vehicle Type', booking.vehicleType),
                        // _buildDetailRow('Engine Model', booking.engineModel),
                        // const SizedBox(height: 8),

                        // // View More button
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => OilViewMore(bookingData: booking),
                        //       ),
                        //     );
                        //   },
                        //   child: const Text(
                        //     'View More',
                        //     style: TextStyle(
                        //       color: Colors.red,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 16),

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
                        ...data.services.map(
                          (service) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              service.serviceType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
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
                                    title: const Text("Confirmation"),
                                    content: const Text(
                                      " Are you sure you want to start service ?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pop(); // Close the dialog
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pop(); // Close the dialog
                                          // Add your logic here
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[900],
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text("Yes"),
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
              );
            },
          );
        },
      ),
    );
  }
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
            style: const TextStyle(fontSize: 13, color: Colors.grey),
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
      final Map<String, bool> litreOptions = {
        '1.0': true,
        '1.5': false,
        '2.0': true,
        '2.5': true,
        '3.0': false,
        '3.5': true,
        '4.0': true,
        '4.5': false,
        '5.0': true,
      };

      String? selectedLitre;
      final List<String> optionalChanges = [
        'Air Filter',
        'Brake Pads',
        'Coolant',
        'Battery Check',
      ];
      final Map<String, bool> selectedOptions = {
        for (var item in optionalChanges) item: false,
      };

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Service Details - $bookingId'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mobil", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  const Text(
                    'Select Oil Quantity (Litres)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedLitre,
                    hint: const Text('Choose litres'),
                    items: litreOptions.entries.map((entry) {
                      final litre = entry.key;
                      final isAvailable = entry.value;

                      return DropdownMenuItem<String>(
                        value: isAvailable ? litre : null,
                        enabled: isAvailable,
                        child: Row(
                          children: [
                            Icon(
                              isAvailable
                                  ? Icons.local_gas_station
                                  : Icons.block,
                              color: isAvailable
                                  ? Colors.green[700]
                                  : Colors.redAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isAvailable
                                  ? '$litre Litres'
                                  : '$litre Litres - Out of Stock',
                              style: TextStyle(
                                fontSize: 14,
                                color: isAvailable
                                    ? Colors.black87
                                    : Colors.grey,
                                fontStyle: isAvailable
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                                decoration: isAvailable
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedLitre = value;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedLitre == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select oil quantity.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  List<String> changes = selectedOptions.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Started service for $bookingId\nOil: $selectedLitre L\nExtras: ${changes.isEmpty ? 'None' : changes.join(', ')}',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // TODO: Add your backend logic here
                },
                child: const Text('Start Service'),
              ),
            ],
          );
        },
      );
    },
  );
}
