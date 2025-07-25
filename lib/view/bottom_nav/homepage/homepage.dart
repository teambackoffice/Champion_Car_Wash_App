import 'package:champion_car_wash_app/controller/get_prebooking_controller.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/booking_status.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/create_service.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/pre_booking_now/pre_book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

// Extract your existing HomePage content into this widget
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String fullname = '';
  final storage = const FlutterSecureStorage();
  String branch = '';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetPrebookingListController>(
        context,
        listen: false,
      ).fetchPreBookingList();
    });
    _loadFullname();
    loadbranch();
  }

  Future<void> _loadFullname() async {
    final storedName = await storage.read(key: "full_name");
    setState(() {
      fullname = storedName ?? '';
    });
  }

  Future<void> loadbranch() async {
    final storedBranch = await storage.read(key: "branch");
    setState(() {
      branch = storedBranch ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 100,
          ),
          child: Column(
            children: [
              // User Profile Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7DB3A8),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          "assets/person.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullname.isNotEmpty
                                ? fullname[0].toUpperCase() +
                                      fullname.substring(1)
                                : '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 5),
                          // const Text(
                          //   "+966 87523 7236",
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: Colors.black54,
                          //   ),
                          // ),
                          const SizedBox(height: 3),
                          Text(
                            branch.isNotEmpty
                                ? branch[0].toUpperCase() + branch.substring(1)
                                : '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Booking Statistics
              BookingStatus(),

              const SizedBox(height: 30),

              // Create Service Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateServicePage(isPrebook: false),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Create Service",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Pre Book Now Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreBookingButton(),
                      ),
                    );
                    print("Pre Book Now tapped");
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD32F2F),
                    side: const BorderSide(color: Color(0xFFD32F2F), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Pre Book Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
