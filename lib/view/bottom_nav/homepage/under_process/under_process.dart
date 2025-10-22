import 'dart:async';
import 'package:champion_car_wash_app/controller/underprocess_controller.dart';
import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/create_invoice.dart';
import 'package:champion_car_wash_app/widgets/common/custom_back_button.dart';
import 'package:champion_car_wash_app/widgets/common/refresh_loading_overlay.dart';
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
  bool _isInitialLoading = true;
  Timer? _debounceTimer;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // PERFORMANCE FIX: Use named method for listener to properly remove it later
    _searchController.addListener(_onSearchChanged);

    // Load data with proper loading state management
    _loadData();
  }

  Future<void> _loadData() async {
    debugPrint(
      '⏳ [UNDER_PROCESS] _loadData called - setting _isInitialLoading = true',
    );
    setState(() {
      _isInitialLoading = true;
    });

    // Add a small delay to ensure loading indicator is visible
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      debugPrint('⏳ [UNDER_PROCESS] Initial fetch starting...');

      final controller = Provider.of<UnderProcessingController>(
        context,
        listen: false,
      );

      try {
        await controller.fetchUnderProcessingBookings();
        debugPrint(
          '✅ [UNDER_PROCESS] Initial fetch completed - ${controller.serviceCars.length} bookings',
        );

        if (mounted) {
          setState(() {
            _filteredBookings = controller.serviceCars;
            _isInitialLoading = false;
          });
        }
      } catch (e) {
        debugPrint('❌ [UNDER_PROCESS] Initial fetch failed: $e');
        if (mounted) {
          setState(() {
            _isInitialLoading = false;
          });
        }
      }
    }
  }

  void _onSearchChanged() {
    _filterBookings(_searchController.text);
  }

  Future<void> _refreshData() async {
    debugPrint('🔄 [UNDER_PROCESS] Pull-to-refresh triggered - FORCING API CALL');

    final controller = Provider.of<UnderProcessingController>(
      context,
      listen: false,
    );

    try {
      debugPrint(
        '📋 [UNDER_PROCESS] Fetching fresh under processing bookings from API...',
      );
      // FORCE REFRESH: Always call API on pull-to-refresh
      await controller.fetchUnderProcessingBookings(forceRefresh: true);
      debugPrint(
        '✅ [UNDER_PROCESS] Fresh under processing bookings fetched successfully - ${controller.serviceCars.length} bookings',
      );

      if (mounted) {
        setState(() {
          _filteredBookings = controller.serviceCars;
        });
        debugPrint(
          '🔄 [UNDER_PROCESS] UI updated with ${_filteredBookings.length} fresh bookings',
        );

        // Show success feedback
        RefreshFeedback.showSuccess(
          context,
          'Refreshed ${controller.serviceCars.length} under processing bookings',
        );
      }
    } catch (e) {
      debugPrint('❌ [UNDER_PROCESS] Error refreshing under processing bookings: $e');

      if (mounted) {
        RefreshFeedback.showError(
          context,
          'Failed to refresh under processing bookings: $e',
        );
      }
    }
  }

  @override
  void dispose() {
    // PERFORMANCE FIX: Remove listener before disposing to prevent memory leak
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
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
      backgroundColor: const Color(0xFF1A1A1A), // Pure black-grey background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFF2A2A2A), // Dark grey-black
          elevation: 2,
          leading: const AppBarBackButton(),
          title: const Text(
            'Under Processing',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Consumer<UnderProcessingController>(
          builder: (context, controller, _) {
            // Debug print to help track loading state
            print(
              '⏳ [UNDER_PROCESS] Build - _isInitialLoading: $_isInitialLoading, controller.isLoading: ${controller.isLoading}',
            );

            if (_isInitialLoading || controller.isLoading) {
              print('⏳ [UNDER_PROCESS] Showing loading indicator');
              return const ListLoadingIndicator(
                message: 'Loading under processing bookings...',
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                      ),
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
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshData,
              color: const Color(0xFFD32F2F),
              backgroundColor: Colors.white,
              child: Column(
                children: [
                  // Enhanced Search Container
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        // PERFORMANCE FIX: Debounce search to avoid filtering on every keystroke
                        _debounceTimer?.cancel();
                        _debounceTimer = Timer(
                          const Duration(milliseconds: 300),
                          () {
                            _filterBookings(value);
                          },
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by vehicle number...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: 22,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey[500],
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _filterBookings('');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        // Use serviceId as the unique identifier
                        final bookingId = booking.serviceId;

                        // Use local methods to check service status
                        final hasServiceStarted = _hasAnyServiceStarted(
                          booking,
                        );
                        final allServicesComplete = _areAllServicesCompleted(
                          booking,
                        );
                        final progress = _calculateProgress(booking);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey[200]!,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Enhanced Header
                              Container(
                                padding: const EdgeInsets.all(20),
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
                                            booking.registrationNumber,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.orange[600]!,
                                            Colors.orange[500]!,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        booking.mainStatus,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
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
                                      progress == 100
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ),

                              // Enhanced Details Section
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  16,
                                  20,
                                  20,
                                ),
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
                                        booking.purchaseDate.toString() ==
                                                'null'
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

                              // Enhanced Services Section
                              if (booking.services.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    0,
                                    20,
                                    20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selected Services (${booking.services.length})',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ...booking.services.map((service) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey[300]!,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.04),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
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
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      if (service.washType !=
                                                          null)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 4,
                                                              ),
                                                          child: Text(
                                                            'Wash Type: ${service.washType}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[700],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      if (service.oilBrand !=
                                                          null)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 4,
                                                              ),
                                                          child: Text(
                                                            'Oil Brand: ${service.oilBrand}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[700],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
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
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Text(
                                                    service.status ?? 'Pending',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                      const SizedBox(height: 24),
                                      if (booking
                                          .extraWorkItems
                                          .isNotEmpty) ...[
                                        Text(
                                          'Extra Work Items (${booking.extraWorkItems.length})',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey[200]!,
                                            ),
                                          ),
                                          child: Column(
                                            children: booking.extraWorkItems.map((
                                              item,
                                            ) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${item.qty} × ₹${item.rate} = ₹${(item.qty * item.rate).toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black87,
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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

                                      // Enhanced Continue Button
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: allServicesComplete
                                                ? () => _showCompletionAlert(
                                                    context,
                                                    bookingId,
                                                  )
                                                : null,
                                            icon: Icon(
                                              allServicesComplete
                                                  ? Icons.check_circle
                                                  : Icons.hourglass_empty,
                                              size: 20,
                                            ),
                                            label: Text(
                                              allServicesComplete
                                                  ? 'Continue to Invoice'
                                                  : 'Waiting for Service Completion',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  allServicesComplete
                                                  ? const Color(0xFFD32F2F)
                                                  : Colors.grey[400],
                                              foregroundColor:
                                                  allServicesComplete
                                                  ? Colors.white
                                                  : Colors.grey[700],
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 18,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: allServicesComplete
                                                  ? 4
                                                  : 0,
                                              shadowColor: allServicesComplete
                                                  ? Colors.red.withOpacity(0.3)
                                                  : null,
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
                      },
                    ),
                  ),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
