import 'package:champion_car_wash_app/controller/get_completed_controller.dart';
import 'package:champion_car_wash_app/controller/get_newbooking_controller.dart';
import 'package:champion_car_wash_app/controller/get_prebooking_controller.dart';
import 'package:champion_car_wash_app/controller/underprocess_controller.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/new_booking/new_bookings.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/pre_booking/pre_booking.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/service_completed.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/under_process/under_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({super.key});

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetPrebookingListController>(
        context,
        listen: false,
      ).fetchPreBookingList();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetNewbookingController>(
        context,
        listen: false,
      ).fetchBookingList();
    });
    Provider.of<UnderProcessingController>(
      context,
      listen: false,
    ).fetchUnderProcessingBookings();
    Provider.of<GetCompletedController>(
      context,
      listen: false,
    ).fetchcompletedlist();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Consumer<GetNewbookingController>(
              builder: (context, controller, child) {
                final newbook = controller.bookingList;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewBookingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "New Booking",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          controller.isLoading || newbook == null
                              ? const SpinKitThreeBounce(
                                  color: Colors.blue,
                                  size: 20,
                                )
                              : Text(
                                  newbook.count.toString(),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 15),
            Consumer<GetPrebookingListController>(
              builder: (context, controller, child) {
                final prebook = controller.preBookingList;

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreBookingsScreenContainer(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.event_available,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Pre Booking",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          controller.isLoading || prebook == null
                              ? const SpinKitThreeBounce(
                                  color: Colors.red,
                                  size: 20,
                                )
                              : Text(
                                  prebook.message.totalPreBookingCount
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Consumer<UnderProcessingController>(
              builder: (context, controller, child) {
                final count = controller.bookingCount;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UnderProcessScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFCF6F),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.hourglass_empty,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Under Processing",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          controller.isLoading
                              ? const SpinKitThreeBounce(
                                  color: Colors.yellow,
                                  size: 20,
                                )
                              : Text(
                                  count.toString(),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFCF6F),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 15),
            Consumer<GetCompletedController>(
              builder: (context, controller, child) {
                final completedcount = controller.completed?.count ?? 0;
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceCompletedScreen(),
                        ),
                      );
                    },

                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF30CDBC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.verified,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Service Completed",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          controller.isLoading
                              ? const SpinKitThreeBounce(
                                  color: Color(0xFF30CDBC),
                                  size: 20,
                                )
                              : Text(
                                  completedcount.toString(),
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF30CDBC),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
