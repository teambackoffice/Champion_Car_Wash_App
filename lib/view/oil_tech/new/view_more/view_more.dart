// ignore_for_file: deprecated_member_use

import 'package:champion_car_wash_app/view/oil_tech/new/new.dart';
import 'package:champion_car_wash_app/view/oil_tech/new/view_more/booking_info.dart';
import 'package:champion_car_wash_app/view/oil_tech/new/view_more/customer_info.dart';
import 'package:champion_car_wash_app/view/oil_tech/new/view_more/selected_services.dart';
import 'package:champion_car_wash_app/view/oil_tech/new/view_more/vehicle_info.dart';
import 'package:flutter/material.dart';

class OilViewMore extends StatelessWidget {
  final BookingData bookingData;
  const OilViewMore({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking ID Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[800]!, Colors.red[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.receipt_long,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Booking ID',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bookingData.bookingId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            BookingInformation(bookingData: bookingData),
            const SizedBox(height: 16),
            CustomerInformation(bookingData: bookingData),
            const SizedBox(height: 16),
            VehicleInformation(bookingData: bookingData),
            const SizedBox(height: 16),
            SelectedServices(bookingData: bookingData),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
