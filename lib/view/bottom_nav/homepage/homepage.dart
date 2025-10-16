import 'package:champion_car_wash_app/view/bottom_nav/homepage/booking_status.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/create_service.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/pre_booking_now/pre_book.dart';
import 'package:champion_car_wash_app/view/test/payment_history_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

    // OPTIMIZATION: Removed duplicate fetchPreBookingList() call
    // The BookingStatus widget already fetches this data
    // OPTIMIZATION: Load user profile data asynchronously after first frame
    // Use parallel loading for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData(); // Load both fullname and branch in parallel
      // Precache the profile image to prevent frame drops on first render
      _precacheImages();
    });
  }

  // OPTIMIZATION: Precache images to prevent UI jank
  void _precacheImages() {
    precacheImage(const AssetImage("assets/person.jpeg"), context);
  }

  // OPTIMIZATION: Load both storage values in parallel instead of sequentially
  Future<void> _loadUserData() async {
    final results = await Future.wait([
      storage.read(key: "full_name"),
      storage.read(key: "branch"),
    ]);
    
    setState(() {
      fullname = results[0] ?? '';
      branch = results[1] ?? '';
    });
  }

  // Keep individual methods for backward compatibility
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
  void dispose() {
    // MEMORY LEAK FIX: No controllers to dispose, but good practice
    super.dispose();
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
              // OPTIMIZATION: RepaintBoundary isolates this widget from parent repaints
              RepaintBoundary(
                child: Container(
                  padding: const EdgeInsets.all(20),
                // OPTIMIZATION: Using const where possible reduces widget rebuilds
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x14000000), // 0.08 alpha as hex
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
              ),

              const SizedBox(height: 20),

              // Booking Statistics
              // OPTIMIZATION: RepaintBoundary prevents this complex widget from
              // causing repaints in parent/sibling widgets
              RepaintBoundary(
                child: BookingStatus(),
              ),

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

              const SizedBox(height: 20),

              // Stripe Payment Test Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 55,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const StripePaymentTest(),
              //         ),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0xFF635BFF), // Stripe purple
              //       foregroundColor: Colors.white,
              //       elevation: 3,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.all(4),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.white, width: 2),
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //           child: const Icon(
              //             Icons.contactless,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         const SizedBox(width: 10),
              //         const Text(
              //           "Test Stripe Payment",
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 20),

              // Stripe Terminal POS Test Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 55,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Navigator.push(
              //       //   context,
              //       //   MaterialPageRoute(
              //       //     builder: (context) => const StripeTerminalTest(),
              //       //   ),
              //       // );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.deepPurple,
              //       foregroundColor: Colors.white,
              //       elevation: 3,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.all(4),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.white, width: 2),
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //           child: const Icon(
              //             Icons.nfc,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         const SizedBox(width: 10),
              //         const Text(
              //           "Test POS Terminal (NFC)",
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 20),

              // Test buttons row 1
              // Row(
              //   children: [
              //     // Real NFC Test Button (Tap Payments)
              //     Expanded(
              //       child: SizedBox(
              //         height: 55,
              //         child: ElevatedButton(
              //           onPressed: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const RealNFCPaymentTest(),
              //               ),
              //             );
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.purple,
              //             foregroundColor: Colors.white,
              //             elevation: 3,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(15),
              //             ),
              //           ),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: const [
              //               Icon(Icons.nfc, size: 18),
              //               Text(
              //                 "🧪 Tap NFC",
              //                 style: TextStyle(
              //                   fontSize: 12,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     // Genuine Stripe NFC Test Button
              //     Expanded(
              //       child: SizedBox(
              //         height: 55,
              //         child: ElevatedButton(
              //           onPressed: () {
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const SplashScreen(),
              //               ),
              //             );
              //           },
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.blue,
              //             foregroundColor: Colors.white,
              //             elevation: 3,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(15),
              //             ),
              //           ),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: const [
              //               Icon(Icons.contactless, size: 18),
              //               Text(
              //                 "💳 Stripe NFC",
              //                 style: TextStyle(
              //                   fontSize: 12,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 12),

              // Payment History Button
              // SizedBox(
              //   width: double.infinity,
              //   height: 55,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const PaymentHistoryViewer(),
              //         ),
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.green,
              //       foregroundColor: Colors.white,
              //       elevation: 3,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.all(4),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.white, width: 2),
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //           child: const Icon(
              //             Icons.history,
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         ),
              //         const SizedBox(width: 10),
              //         const Text(
              //           "📊 Payment History",
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
