import 'package:champion_car_wash_app/controller/service_counts_controller.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/booking_status.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/create_service.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/pre_booking_now/pre_book.dart';
import 'package:champion_car_wash_app/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    precacheImage(const AssetImage('assets/person.jpeg'), context);
  }

  // OPTIMIZATION: Load both storage values in parallel instead of sequentially
  Future<void> _loadUserData() async {
    final results = await Future.wait([
      storage.read(key: 'full_name'),
      storage.read(key: 'branch'),
    ]);

    setState(() {
      fullname = results[0] ?? '';
      branch = results[1] ?? '';
    });
  }

  // Pull to refresh functionality
  Future<void> _handleRefresh() async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    // Refresh count data
    await Provider.of<ServiceCountsController>(
      context,
      listen: false,
    ).refreshData();
  }

  // Keep individual methods for backward compatibility
  Future<void> _loadFullname() async {
    final storedName = await storage.read(key: 'full_name');
    setState(() {
      fullname = storedName ?? '';
    });
  }

  Future<void> loadbranch() async {
    final storedBranch = await storage.read(key: 'branch');
    setState(() {
      branch = storedBranch ?? '';
    });
  }

  // Get time-based greeting
  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return 'Good morning!';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon!';
    } else if (hour >= 17 && hour < 22) {
      return 'Good evening!';
    } else {
      return 'Working late?';
    }
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: No controllers to dispose, but good practice
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Pure black-grey background
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: const Color(0xFFD32F2F),
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: 100,
            ),
            child: Column(
              children: [
              // User Profile Section - Enhanced Compact Design with Tap Navigation
              // OPTIMIZATION: RepaintBoundary isolates this widget from parent repaints
              RepaintBoundary(
                child: InkWell(
                  onTap: () {
                    // Add haptic feedback for better UX
                    HapticFeedback.lightImpact();
                    // OPTIMIZED NAVIGATION: Use pushNamed for better performance
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const ProfileScreen(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          // Smooth slide transition
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                  padding: const EdgeInsets.all(16),
                  // OPTIMIZATION: Using const where possible reduces widget rebuilds
                  // DESIGN: Enhanced dark mode styling with modern gradient
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2C2C2C), // Enhanced dark grey
                        Color(0xFF404040), // Slightly lighter with better contrast
                      ],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Profile Avatar with enhanced styling
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD32F2F).withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 32,
                          backgroundColor: Color(0xFFD32F2F),
                          child: Icon(
                            Icons.person,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // User info section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Time-based greeting
                            Text(
                              _getTimeBasedGreeting(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // User name with enhanced typography
                            Text(
                              fullname.isNotEmpty
                                  ? fullname[0].toUpperCase() + fullname.substring(1)
                                  : 'User',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            // Branch info with icon
                            if (branch.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      branch[0].toUpperCase() + branch.substring(1),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      // Status indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),

              const SizedBox(height: 20),

              // Booking Statistics
              // OPTIMIZATION: RepaintBoundary prevents this complex widget from
              // causing repaints in parent/sibling widgets
              const RepaintBoundary(
                child: BookingStatus(),
              ),

              const SizedBox(height: 30),

              // Create Service Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // Add haptic feedback
                    HapticFeedback.mediumImpact();
                    // OPTIMIZED NAVIGATION: Custom transition for better performance
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => 
                            const CreateServicePage(isPrebook: false),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
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
                        'Create Service',
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
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    // Add haptic feedback
                    HapticFeedback.mediumImpact();
                    // OPTIMIZED NAVIGATION: Custom transition for better performance
                    final result = await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const PreBookingButton(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end).chain(
                            CurveTween(curve: curve),
                          );
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                    );

                    // Refresh data if booking was created successfully
                    if (result == true && context.mounted) {
                      Provider.of<ServiceCountsController>(context, listen: false)
                          .refreshData();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD32F2F),
                    // side: const BorderSide(color: Color(0xFFD32F2F), width: 2),
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
                        'Pre Book Now',
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
      ),
    );
  }
}
