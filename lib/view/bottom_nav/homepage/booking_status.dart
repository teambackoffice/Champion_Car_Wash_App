import 'package:champion_car_wash_app/controller/service_counts_controller.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/new_booking/new_bookings.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/pre_booking/pre_booking.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/service_completed.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/under_process/under_process.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({super.key});

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> with AutomaticKeepAliveClientMixin {
  // OPTIMIZATION: Keep widget alive to prevent unnecessary rebuilds
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    // OPTIMIZATION: Single API call to fetch all counts at once
    // This replaces 4 separate API calls with 1 unified call
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceCountsController>(
        context,
        listen: false,
      ).fetchServiceCounts();
    });
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: No controllers to dispose, but good practice to implement
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // OPTIMIZATION: Call super.build for AutomaticKeepAliveClientMixin
    super.build(context);
    return Consumer<ServiceCountsController>(
      builder: (context, countsController, child) {
        return Column(
          children: [
            Row(
              children: [
                // New Booking Card
                Expanded(
                  child: _buildStatusCard(
                    context: context,
                    title: 'New Booking',
                    count: countsController.openServiceCount,
                    icon: Icons.calendar_month,
                    color: Colors.blue,
                    isLoading: countsController.isLoading,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewBookingsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Pre Booking Card
                Expanded(
                  child: _buildStatusCard(
                    context: context,
                    title: 'Pre Booking',
                    count: countsController.prebookingCount,
                    icon: Icons.event_available,
                    color: Colors.red,
                    isLoading: countsController.isLoading,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreBookingsScreenContainer(),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Under Processing Card
                Expanded(
                  child: _buildStatusCard(
                    context: context,
                    title: 'Under Processing',
                    count: countsController.inprogressServiceCount,
                    icon: Icons.hourglass_empty,
                    color: const Color(0xFFFFCF6F),
                    isLoading: countsController.isLoading,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UnderProcessScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Service Completed Card
                Expanded(
                  child: _buildStatusCard(
                    context: context,
                    title: 'Service Completed',
                    count: countsController.completedServiceCount,
                    icon: Icons.verified,
                    color: const Color(0xFF30CDBC),
                    isLoading: countsController.isLoading,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ServiceCompletedScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Build a status card widget
  /// Reusable widget for displaying count cards
  Widget _buildStatusCard({
    required BuildContext context,
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            RepaintBoundary(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            isLoading
                ? Column(
                    children: [
                      Container(
                        height: 32,
                        width: 60,
                        decoration: BoxDecoration(
                          color: color.withAlpha(26),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(color.withAlpha(77)),
                            minHeight: 32,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
