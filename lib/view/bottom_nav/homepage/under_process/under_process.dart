import 'package:champion_car_wash_app/controller/underprocess_controller.dart';
import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/create_invoice.dart';
import 'package:champion_car_wash_app/widgets/common/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UnderProcessScreen extends StatefulWidget {
  const UnderProcessScreen({super.key});

  @override
  State<UnderProcessScreen> createState() => _UnderProcessScreenState();
}

class _UnderProcessScreenState extends State<UnderProcessScreen> {
  List<ServiceCars> _filteredBookings = [];
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      _filterBookings(_searchController.text);
    });

    // Fetch data after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<UnderProcessingController>(
        context,
        listen: false,
      );
      controller.fetchUnderProcessingBookings().then((_) {
        if (mounted) {
          setState(() {
            _filteredBookings = controller.serviceCars;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBookings(String query) {
    final controller = Provider.of<UnderProcessingController>(
      context,
      listen: false,
    );
    final allBookings = controller.serviceCars;

    if (query.isEmpty) {
      setState(() {
        _filteredBookings = allBookings;
        _isSearching = false;
      });
      return;
    }

    final filtered = allBookings.where((booking) {
      return booking.registrationNumber.toLowerCase().contains(
        query.toLowerCase(),
      );
    }).toList();

    setState(() {
      _filteredBookings = filtered;
      _isSearching = true;
    });
  }

  final List<String> _statusOptions = ['Select Status', 'Started', 'Complete'];

  // Check if all services in a booking are completed
  bool _areAllServicesCompleted(ServiceCars booking) {
    if (booking.services.isEmpty) return false;

    return booking.services.every(
      (service) =>
          service.status != null &&
          service.status!.toLowerCase() == 'completed',
    );
  }

  // Check if any service has started
  bool _hasAnyServiceStarted(ServiceCars booking) {
    return booking.services.any(
      (service) =>
          service.status != null &&
          (service.status!.toLowerCase() == 'inprogress' ||
              service.status!.toLowerCase() == 'completed'),
    );
  }

  // Calculate progress percentage
  double _calculateProgress(ServiceCars booking) {
    if (booking.services.isEmpty) return 0.0;

    int completedServices = booking.services
        .where(
          (service) =>
              service.status != null &&
              service.status!.toLowerCase() == 'completed',
        )
        .length;

    return (completedServices / booking.services.length) * 100;
  }

  // Show completion alert dialog
  void _showCompletionAlert(BuildContext context, String serviceId) {
    final controller = Provider.of<UnderProcessingController>(
      context,
      listen: false,
    );
    final booking = controller.getBookingById(serviceId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Service Complete',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: const Text('Do you want to proceed to create invoice?'),
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
        leading: const AppBarBackButton(),
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
              return Center(
                child: CircularProgressIndicator(color: Colors.red[800]),
              );
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

            final bookings = _isSearching
                ? _filteredBookings
                : controller.serviceCars;

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
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterBookings('');
                                },
                              )
                            : null,
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

                    // Use local methods to check service status
                    final hasServiceStarted = _hasAnyServiceStarted(booking);
                    final allServicesComplete = _areAllServicesCompleted(
                      booking,
                    );
                    final progress = _calculateProgress(booking);

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
                          // Header
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
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    booking.mainStatus,
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
                                  DateFormat('dd MMM yyyy').format(
                                    booking.purchaseDate.toString() == 'null'
                                        ? DateTime.now()
                                        : DateTime.parse(
                                            booking.purchaseDate.toString(),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),

                          // Services list
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
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    service.serviceType,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (service.washType != null)
                                                    Text(
                                                      'Wash Type: ${service.washType}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  if (service.oilBrand != null)
                                                    Text(
                                                      'Oil Brand: ${service.oilBrand}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey[300]!,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Colors.white,
                                              ),
                                              child: Text(
                                                service.status ?? 'Pending',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: _getStatusColor(
                                                    service.status,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 20),
                                  if (booking.extraWorkItems.isNotEmpty) ...[
                                    const Text(
                                      'Extra Work Items',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Column(
                                        children: booking.extraWorkItems.map((
                                          item,
                                        ) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.workItem,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '${item.qty} × ₹${item.rate} = ₹${(item.qty * item.rate).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 20),

                                  if (allServicesComplete) ...[
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildTotalRow(
                                            'Oil Total',
                                            booking.oilTotal,
                                          ),
                                          _buildTotalRow(
                                            'Car Wash Total',
                                            booking.carwashTotal,
                                          ),

                                          _buildTotalRow(
                                            'Extra Works Total',
                                            booking.extraWorksTotal,
                                          ),
                                          const Divider(height: 20),
                                          _buildTotalRow(
                                            'Grand Total',
                                            booking.grandTotal,
                                            isBold: true,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                  // Continue button - Only enabled when all services are completed
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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

  Widget _buildTotalRow(
    String label,
    double value, {
    bool isBold = false,
    Color? color,
  }) {
    if (value <= 0) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get status color
  Color _getStatusColor(String? status) {
    if (status == null) return Colors.black87;

    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'inprogress':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      default:
        return Colors.black87;
    }
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
