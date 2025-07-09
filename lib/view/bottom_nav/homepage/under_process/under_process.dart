import 'package:champion_car_wash_app/controller/underprocess_controller.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/create_invoice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnderProcessScreen extends StatefulWidget {
  const UnderProcessScreen({super.key});

  @override
  State<UnderProcessScreen> createState() => _UnderProcessScreenState();
}

class _UnderProcessScreenState extends State<UnderProcessScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<UnderProcessingController>(
      context,
      listen: false,
    ).fetchUnderProcessingBookings();
  }

  final List<String> _statusOptions = ['Select Status', 'Started', 'Complete'];

  // Show completion alert dialog
  void _showCompletionAlert(BuildContext context, String serviceId) {
    final controller = Provider.of<UnderProcessingController>(
      context,
      listen: false,
    );
    final booking = controller.getBookingById(serviceId);
    final bookings = controller.serviceCars;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Service Complete',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: Text('Do you want to proceed to create invoice?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // You can pass booking data to CreateInvoicePage if needed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateInvoicePage(booking: booking),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: Container(
          margin: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 16,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        title: const Text(
          'Under Processing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<UnderProcessingController>(
          builder: (context, controller, _) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${controller.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          controller.fetchUnderProcessingBookings(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final bookings = controller.serviceCars;

            if (bookings.isEmpty) {
              return const Center(
                child: Text(
                  'No bookings under processing',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Customer by Vehicle Number',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...bookings.map((booking) {
                    // Use serviceId as the unique identifier
                    final bookingId = booking.serviceId;

                    final hasServiceStarted = controller.hasAnyServiceStarted(
                      bookingId,
                    );
                    final allServicesComplete = controller
                        .areAllServicesComplete(bookingId);
                    final progress = controller.getBookingProgress(bookingId);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header - Only show "Under Processing" if service has started
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        booking.registrationNumber,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (hasServiceStarted &&
                                          !allServicesComplete)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            '${progress.toStringAsFixed(0)}% Complete',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (hasServiceStarted)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: allServicesComplete
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      allServicesComplete
                                          ? 'Complete'
                                          : 'Under Processing',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Progress bar (only show if service has started)
                          if (hasServiceStarted && !allServicesComplete)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: LinearProgressIndicator(
                                value: progress / 100,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress == 100 ? Colors.green : Colors.red,
                                ),
                              ),
                            ),

                          // Details
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildRow(
                                  'Customer Name',
                                  booking.customerName,
                                ),
                                _buildRow('Phone', booking.phone),
                                _buildRow(
                                  'Car Model',
                                  '${booking.make} ${booking.model}',
                                ),
                                _buildRow('Car Type', booking.carType),
                                _buildRow(
                                  'Odometer',
                                  '${booking.currentOdometerReading.toStringAsFixed(0)} KM',
                                ),
                                _buildRow(
                                  'Purchase Date',
                                  booking.purchaseDate,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),

                          // Services & dropdown
                          if (booking.services.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selected Services',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ...booking.services.map((service) {
                                    final currentStatus = controller
                                        .getServiceStatus(
                                          bookingId,
                                          service.serviceType,
                                        );

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        service.serviceType,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      if (service.washType !=
                                                          null)
                                                        Text(
                                                          'Wash Type: ${service.washType}',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      if (service.oilBrand !=
                                                          null)
                                                        Text(
                                                          'Oil Brand: ${service.oilBrand}',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                      Text(
                                                        'Price: ₹${service.price.toStringAsFixed(0)}',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey[300]!,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    color: Colors.white,
                                                  ),
                                                  child: DropdownButton<String>(
                                                    value: currentStatus,
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        controller
                                                            .setServiceStatus(
                                                              bookingId,
                                                              service
                                                                  .serviceType,
                                                              value,
                                                            );
                                                      }
                                                    },
                                                    underline: const SizedBox(),
                                                    items: _statusOptions.map((
                                                      status,
                                                    ) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: status,
                                                        child: Text(
                                                          status,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                status ==
                                                                    'Select Status'
                                                                ? Colors
                                                                      .grey[600]
                                                                : status ==
                                                                      'Complete'
                                                                ? Colors.green
                                                                : status ==
                                                                      'Started'
                                                                ? Colors.orange
                                                                : Colors
                                                                      .black87,
                                                            fontWeight:
                                                                status !=
                                                                    'Select Status'
                                                                ? FontWeight
                                                                      .w600
                                                                : FontWeight
                                                                      .normal,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    icon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.grey[600],
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),

                          // Continue button - Only enabled when all services are complete
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: allServicesComplete
                                    ? () => _showCompletionAlert(
                                        context,
                                        bookingId,
                                      )
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: allServicesComplete
                                      ? Colors.red
                                      : Colors.grey[300],
                                  foregroundColor: allServicesComplete
                                      ? Colors.white
                                      : Colors.grey[600],
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  allServicesComplete
                                      ? 'Continue to Invoice'
                                      : hasServiceStarted
                                      ? 'Complete all services first'
                                      : 'Start Services to Continue',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
