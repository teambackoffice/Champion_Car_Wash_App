import 'dart:async';
import 'package:champion_car_wash_app/controller/cancel_prebook_controller.dart';
import 'package:champion_car_wash_app/controller/confirm_prebook_controller.dart';
import 'package:champion_car_wash_app/controller/get_prebooking_controller.dart';
import 'package:champion_car_wash_app/modal/get_prebooking_list.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/create_service.dart';
import 'package:champion_car_wash_app/widgets/common/custom_back_button.dart';
import 'package:champion_car_wash_app/widgets/common/refresh_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PreBookingsScreenContainer extends StatefulWidget {
  const PreBookingsScreenContainer({super.key});

  @override
  State<PreBookingsScreenContainer> createState() =>
      _PreBookingsScreenContainerState();
}

class _PreBookingsScreenContainerState
    extends State<PreBookingsScreenContainer> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredBookings = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('📅 [PRE_BOOKINGS] Initial fetch starting...');
      
      final controller = Provider.of<GetPrebookingListController>(
        context,
        listen: false,
      );
      
      try {
        await controller.fetchPreBookingList();
        print('✅ [PRE_BOOKINGS] Initial fetch completed - ${controller.bookingData.length} bookings');
      } catch (e) {
        print('❌ [PRE_BOOKINGS] Initial fetch failed: $e');
      }
    });
  }

  void _filterBookings(String query, List<dynamic> bookings) {
    setState(() {
      _filteredBookings = query.isEmpty
          ? bookings
          : bookings
                .where(
                  (booking) =>
                      booking.regNumber.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      booking.customerName.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      booking.phone.contains(query),
                )
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Pure black-grey background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFF2A2A2A), // Dark grey-black
          elevation: 0,
          leading: const AppBarBackButton(),
          title: const Text(
            'Pre Bookings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Consumer<GetPrebookingListController>(
        builder: (context, controller, child) {
          if (controller.bookingData.isNotEmpty && _filteredBookings.isEmpty) {
            _filteredBookings = controller.bookingData;
          }

          return Column(
            children: [
              // Search Bar
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    // PERFORMANCE FIX: Debounce search to avoid filtering on every keystroke
                    _debounceTimer?.cancel();
                    _debounceTimer = Timer(
                      const Duration(milliseconds: 300),
                      () {
                        _filterBookings(value, controller.bookingData);
                      },
                    );
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Customer by Vehicle Number',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              // Content
              Expanded(child: _buildContent(controller)),
            ],
          );
        },
      ),
    );
  }
  // Add this method to your _PreBookingsScreenContainerState class:

  Future<void> _refreshBookingList() async {
    print('🔄 [PRE_BOOKINGS] Pull-to-refresh triggered - FORCING API CALL');
    
    try {
      // Add haptic feedback
      HapticFeedback.mediumImpact();

      // Fetch fresh data
      final controller = Provider.of<GetPrebookingListController>(
        context,
        listen: false,
      );

      print('📋 [PRE_BOOKINGS] Fetching fresh pre-booking list from API...');
      // FORCE REFRESH: Always call API on pull-to-refresh
      await controller.fetchPreBookingList(forceRefresh: true);
      print('✅ [PRE_BOOKINGS] Fresh pre-booking list fetched successfully - ${controller.bookingData.length} bookings');

      // Update UI with fresh data
      if (mounted) {
        setState(() {
          _filteredBookings = List.from(controller.bookingData);
        });
        print('🔄 [PRE_BOOKINGS] UI updated with ${_filteredBookings.length} fresh bookings');
        
        // Show success feedback
        RefreshFeedback.showSuccess(
          context,
          'Refreshed ${controller.bookingData.length} pre-bookings'
        );
      }
    } catch (e) {
      print('❌ [PRE_BOOKINGS] Error refreshing pre-bookings: $e');
      
      if (mounted) {
        RefreshFeedback.showError(
          context,
          'Failed to refresh booking list: $e'
        );
      }
    }
  }

  Widget _buildContent(GetPrebookingListController controller) {
    if (controller.isLoading) {
      return const ListLoadingIndicator(
        message: 'Loading pre-bookings...',
      );
    }

    if (controller.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Failed to load bookings',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.fetchPreBookingList(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              controller.bookingData.isEmpty
                  ? 'No bookings found'
                  : 'No results found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshBookingList,
      color: const Color(0xFFD32F2F),
      backgroundColor: Colors.white,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = _filteredBookings[index];
          return Column(
            children: [
              _buildBookingCard(booking: booking),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBookingCard({required dynamic booking}) {
    String formattedDate = _formatDate(booking.date);
    Color statusColor = _getStatusColor(booking.status);
    Color statusBgColor = _getStatusBgColor(booking.status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.regNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  booking.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Booking Date', formattedDate),
          _buildDetailRow('Booking Time', booking.time),
          _buildDetailRow('User Name', booking.customerName),
          _buildDetailRow('Mobile No.', booking.phone),
          _buildDetailRow('Branch', booking.branch),
          _buildDetailRow('Registration Number', booking.regNumber),

          // Updated Services Section
          Text(
            'Selected Services',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),

          // Dynamic Services List
          if (booking.services != null && booking.services.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: booking.services.map<Widget>((service) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        service.serviceName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          else
            Text(
              'No services selected',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),

          const SizedBox(height: 20),
          Row(
            children: [
              booking.status == 'Confirmed'
                  ? const SizedBox()
                  : Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showCancelDialog(booking),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Cancel Booking',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(width: 12),
              booking.status == 'Confirmed'
                  ? const SizedBox()
                  : Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showConfirmDialog(booking),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCompact(List<Service> services) {
    if (services.isEmpty) {
      return Text(
        'No services selected',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    String serviceNames = services
        .map((service) => service.serviceName)
        .join(', ');

    return Text(
      serviceNames,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Alternative: If you want to show services with chips/tags
  Widget _buildServicesChips(List<Service> services) {
    if (services.isEmpty) {
      return Text(
        'No services selected',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: services.map((service) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Text(
            service.serviceName,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day} ${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[700]!;
      case 'confirmed':
        return Colors.green[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      case 'completed':
        return Colors.blue[700]!;
      default:
        return Colors.pink[700]!;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[100]!;
      case 'confirmed':
        return Colors.green[100]!;
      case 'cancelled':
        return Colors.red[100]!;
      case 'completed':
        return Colors.blue[100]!;
      default:
        return Colors.pink[100]!;
    }
  }

  // Replace your _showCancelDialog method with this:

  void _showCancelDialog(dynamic booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Consumer<CancelPrebookController>(
              builder: (context, controller, child) {
                return AlertDialog(
                  title: const Text('Cancel Booking'),
                  content: controller.isLoading
                      ? const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text('Cancelling booking...'),
                          ],
                        )
                      : Text(
                          'Are you sure you want to cancel this booking for ${booking.customerName}?',
                        ),
                  actions: controller.isLoading
                      ? []
                      : [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                // Call API to cancel booking
                                await controller.cancelPreBooking(booking.name);

                                // Close dialog
                                if (Navigator.of(dialogContext).canPop()) {
                                  Navigator.of(dialogContext).pop();
                                }

                                // Show result
                                final message =
                                    controller.responseMessage ?? 'No response';
                                final isSuccess =
                                    !message.toLowerCase().contains('error') &&
                                    !message.toLowerCase().contains(
                                      'exception',
                                    ) &&
                                    !message.toLowerCase().contains('failed');

                                // Use the original context (this.context) for SnackBar

                                // REFRESH THE PAGE using the safe refresh method
                                if (isSuccess) {
                                  await _refreshBookingList();
                                }
                              } catch (e) {
                                // Close dialog on error
                                if (Navigator.of(dialogContext).canPop()) {
                                  Navigator.of(dialogContext).pop();
                                }

                                // Show error message
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to cancel booking: $e',
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                );
              },
            );
          },
        );
      },
    );
  }

  // Alternative simpler approach - replace the _showConfirmDialog method with this:

  void _showConfirmDialog(dynamic booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Consumer<ConfirmPrebookController>(
              builder: (context, controller, child) {
                return AlertDialog(
                  title: const Text('Confirm Booking'),
                  content: controller.isLoading
                      ? const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text('Confirming booking...'),
                          ],
                        )
                      : Text(
                          'Are you sure you want to confirm this booking for ${booking.customerName}?',
                        ),
                  actions: controller.isLoading
                      ? []
                      : [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Call API
                              await controller.confirmPreBooking(booking.name);

                              // Close dialog
                              if (Navigator.of(dialogContext).canPop()) {
                                Navigator.of(dialogContext).pop();
                              }

                              // Show result
                              final message =
                                  controller.responseMessage ?? 'No response';
                              final isSuccess =
                                  !message.toLowerCase().contains('error') &&
                                  !message.toLowerCase().contains(
                                    'exception',
                                  ) &&
                                  !message.toLowerCase().contains('failed');

                              // Use the original context (this.context) for SnackBar
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: isSuccess
                                      ? Colors.green
                                      : Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateServicePage(
                                    bookings: booking,
                                    isPrebook: true,
                                  ),
                                ),
                              );

                              // If successful, refresh the booking list
                              if (isSuccess) {
                                Provider.of<GetPrebookingListController>(
                                  this.context,
                                  listen: false,
                                ).fetchPreBookingList();
                              }
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
