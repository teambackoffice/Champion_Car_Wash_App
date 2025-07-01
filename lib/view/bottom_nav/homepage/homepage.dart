import 'package:champion_car_wash_app/view/bottom_nav/booking_page/all_bookings.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/booking_status.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/create_service.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/new_booking/new_bookings.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/pre_booking_now/pre_book.dart';
import 'package:champion_car_wash_app/view/bottom_nav/profile_page/profile.dart';
import 'package:flutter/material.dart';



// Extract your existing HomePage content into this widget
class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
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
                        child: Image.asset("assets/person.jpeg", fit: BoxFit.cover)
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Mohammed Ali",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "+966 87523 7236",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            "Al Hamidya 1, Ajman",
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
              
              const SizedBox(height: 40),
              
              // Booking Statistics
              BookingStatus(),
              
              const SizedBox(height: 30),
              
              // Create Service Button
              Container(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.push(
                     context,
                      MaterialPageRoute(builder: (context) => CreateServiceScreen()),
                         );
                    print("Create Service tapped");
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
              Container(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.push(
                     context,
                      MaterialPageRoute(builder: (context) => PreBookingButton()),
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
                  child: const Text(
                    "Pre Book Now",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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

