import 'package:champion_car_wash_app/controller/service_counts_controller.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/new_booking/new_bookings.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/pre_booking/pre_booking.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/service_completed.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/under_process/under_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({super.key});

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus>
    with AutomaticKeepAliveClientMixin {
  // OPTIMIZATION: Keep widget alive to prevent unnecessary rebuilds
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    // PERFORMANCE FIX: Delay API calls to prevent main thread blocking
    // Use multiple frame delays to spread the work
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () async {
        if (mounted) {
          debugPrint('📊 [BOOKING_STATUS] Initial fetch starting...');

          final controller = Provider.of<ServiceCountsController>(
            context,
            listen: false,
          );

          try {
            await controller.fetchServiceCounts();
            debugPrint('✅ [BOOKING_STATUS] Initial fetch completed');
          } catch (e) {
            debugPrint('❌ [BOOKING_STATUS] Initial fetch failed: $e');
          }
        }
      });
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
                    icon: Icons.event_note,
                    color: const Color(0xFF1565C0), // Darker blue shade
                    isLoading: countsController.isLoading,
                    onTap: () {
                      // Add haptic feedback
                      HapticFeedback.lightImpact();
                      // OPTIMIZED NAVIGATION: Custom transition for better performance
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const NewBookingsScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 250),
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
                    icon: Icons.schedule,
                    color: const Color(0xFFD32F2F), // Darker red shade
                    isLoading: countsController.isLoading,
                    onTap: () {
                      // Add haptic feedback
                      HapticFeedback.lightImpact();
                      // OPTIMIZED NAVIGATION: Custom transition for better performance
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const PreBookingsScreenContainer(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 250),
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
                    icon: Icons.sync,
                    color: const Color(0xFFFF8F00), // Darker orange shade
                    isLoading: countsController.isLoading,
                    onTap: () {
                      // Add haptic feedback
                      HapticFeedback.lightImpact();
                      // OPTIMIZED NAVIGATION: Custom transition for better performance
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const UnderProcessScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 250),
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
                    icon: Icons.check_circle,
                    color: const Color(0xFF00796B), // Darker teal shade
                    isLoading: countsController.isLoading,
                    onTap: () {
                      // Add haptic feedback
                      HapticFeedback.lightImpact();
                      // OPTIMIZED NAVIGATION: Custom transition for better performance
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const ServiceCompletedScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 250),
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
  /// Reusable widget for displaying count cards in compact layout
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
            BoxShadow(
              color: color.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title at the top with background shade
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black87
                      : Colors.black87,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Icon and count in a row
            Row(
              children: [
                RepaintBoundary(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: isLoading
                      ? Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: color.withAlpha(26),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                color.withAlpha(77),
                              ),
                              minHeight: 32,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            count.toString(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: color,
                              shadows: [
                                Shadow(
                                  color: color.withAlpha(40),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
