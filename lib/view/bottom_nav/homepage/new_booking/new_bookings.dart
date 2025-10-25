import 'dart:async';

import 'package:champion_car_wash_app/controller/get_newbooking_controller.dart';
import 'package:champion_car_wash_app/modal/get_newbooking_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/new_booking/view_More.dart';
import 'package:champion_car_wash_app/widgets/common/custom_back_button.dart';
import 'package:champion_car_wash_app/widgets/common/refresh_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewBookingsScreen extends StatefulWidget {
  const NewBookingsScreen({super.key});

  @override
  State<NewBookingsScreen> createState() => _NewBookingsScreenState();
}

class _NewBookingsScreenState extends State<NewBookingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ServiceData> _filteredBookings = [];
  bool _isLoading = true;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    // Set initial loading state
    _isLoading = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // PERFORMANCE FIX: Early exit if widget is already disposed
      if (!mounted) return;

      debugPrint('📋 [NEW_BOOKINGS] Initial fetch starting...');

      final controller = Provider.of<GetNewbookingController>(
        context,
        listen: false,
      );

      try {
        await controller.fetchBookingList();
        debugPrint(
          '✅ [NEW_BOOKINGS] Initial fetch completed - ${controller.bookingData.length} bookings',
        );

        // PERFORMANCE FIX: Check mounted again after async operation
        if (!mounted) return;

        setState(() {
          _filteredBookings = controller.bookingData;
          _isLoading = false;
        });
      } catch (e) {
        debugPrint('❌ [NEW_BOOKINGS] Initial fetch failed: $e');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  void _filterBookings(String query, List<ServiceData> allBookings) {
    // PERFORMANCE FIX: Check mounted before setState to prevent errors
    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _filteredBookings = allBookings;
      } else {
        _filteredBookings = allBookings
            .where(
              (booking) => booking.registrationNumber.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  // Pull to refresh functionality
  Future<void> _handleRefresh() async {
    debugPrint('🔄 [NEW_BOOKINGS] Pull-to-refresh triggered - FORCING API CALL');

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Show loading state
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      final controller = Provider.of<GetNewbookingController>(
        context,
        listen: false,
      );

      debugPrint('📋 [NEW_BOOKINGS] Fetching fresh booking list from API...');
      // FORCE REFRESH: Always call API on pull-to-refresh
      await controller.fetchBookingList(forceRefresh: true);

      debugPrint(
        '✅ [NEW_BOOKINGS] Fresh booking list fetched successfully - ${controller.bookingData.length} bookings',
      );

      if (mounted) {
        setState(() {
          _filteredBookings = controller.bookingData;
          _isLoading = false;
        });
        debugPrint(
          '🔄 [NEW_BOOKINGS] UI updated with ${_filteredBookings.length} fresh bookings',
        );

        // Show success feedback
        RefreshFeedback.showSuccess(
          context,
          'Refreshed ${controller.bookingData.length} bookings',
        );
      }
    } catch (e) {
      debugPrint('❌ [NEW_BOOKINGS] Error refreshing bookings: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        RefreshFeedback.showError(context, 'Failed to refresh bookings: $e');
      }
    }
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: Dispose TextEditingController and debounce timer
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Pure black-grey background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFF2A2A2A), // Dark grey-black
          leading: const AppBarBackButton(),
          title: const Text(
            'New Bookings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF2A2A2A), // Dark grey-black
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                // PERFORMANCE FIX: Debounce search to avoid filtering on every keystroke
                _debounceTimer?.cancel();
                _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                  final allBookings = Provider.of<GetNewbookingController>(
                    context,
                    listen: false,
                  ).bookingData;
                  _filterBookings(value, allBookings);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Customer by Vehicle Number',
                hintStyle: TextStyle(color: Colors.grey[400]),
                suffixIcon: Icon(Icons.search, color: Colors.grey[300]),
                filled: true,
                fillColor: const Color(0xFF3D3D3D), // Lighter grey-black
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<GetNewbookingController>(
              builder: (context, controller, child) {
                // Show loading indicator during initial data fetch
                if (_isLoading || controller.isLoading) {
                  return const ListLoadingIndicator(
                    message: 'Loading bookings...',
                  );
                }

                if (controller.error != null) {
                  return Center(
                    child: Text(
                      controller.error!,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final bookings = _filteredBookings;
                // PERFORMANCE FIX: Single empty check with context-aware message
                if (bookings.isEmpty) {
                  return Center(
                    child: Text(
                      controller.bookingData.isEmpty
                          ? 'No new bookings found.'
                          : 'No matching registration number.',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: const Color(0xFFD32F2F),
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    booking.registrationNumber,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
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
                            _buildInfoRow(
                              'Customer Name',
                              booking.customerName,
                            ),
                            _buildInfoRow('Mobile No', booking.phone),
                            _buildInfoRow('Email ID', booking.email),
                            _buildInfoRow('Make', booking.make),
                            _buildInfoRow('Vehicle Type', booking.carType),
                            _buildInfoRow('Vehicle Model', booking.model),
                            _buildInfoRow('Engine No', booking.engineNumber),
                            _buildInfoRow('Chasis No', booking.chasisNumber),
                            _buildInfoRow(
                              'Fuel Level',
                              '${booking.fuelLevel}%',
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewMorePage(booking: booking),
                                  ),
                                );
                              },
                              child: const Text(
                                'View More',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Selected Services',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...booking.services.map(
                              (service) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  service.serviceType +
                                      (service.washType != null
                                          ? ' - ${service.washType}'
                                          : '') +
                                      (service.oilBrand != null
                                          ? ' - ${service.oilBrand}'
                                          : ''),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // SizedBox(
                            //   width: double.infinity,
                            //   child: ElevatedButton(
                            //     onPressed: () async {
                            //       final confirm = await showDialog<bool>(
                            //         context: context,
                            //         builder: (context) => AlertDialog(
                            //           title: Text('Confirm'),
                            //           content: Text(
                            //             'Are you sure you want to start the service?',
                            //           ),
                            //           actions: [
                            //             TextButton(
                            //               onPressed: () =>
                            //                   Navigator.of(context).pop(false),
                            //               child: Text('Cancel'),
                            //             ),
                            //             ElevatedButton(
                            //               onPressed: () =>
                            //                   Navigator.of(context).pop(true),
                            //               style: ElevatedButton.styleFrom(
                            //                 backgroundColor: Colors.red,
                            //                 foregroundColor: Colors.white,
                            //                 shape: RoundedRectangleBorder(
                            //                   borderRadius: BorderRadius.circular(
                            //                     12,
                            //                   ),
                            //                 ),
                            //               ),
                            //               child: Text('Start'),
                            //             ),
                            //           ],
                            //         ),
                            //       );

                            //       if (confirm == true) {
                            //         await Provider.of<
                            //               ServiceUnderproccessingController
                            //             >(context, listen: false)
                            //             .markServiceInProgress(booking.serviceId);
                            //         await Provider.of<GetNewbookingController>(
                            //           context,
                            //           listen: false,
                            //         ).fetchBookingList();
                            //       }
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: Colors.red,
                            //       foregroundColor: Colors.white,
                            //       padding: EdgeInsets.symmetric(vertical: 16),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(12),
                            //       ),
                            //       elevation: 0,
                            //     ),
                            //     child: Text(
                            //       'Start Service',
                            //       style: TextStyle(
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
