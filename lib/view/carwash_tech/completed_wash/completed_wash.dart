import 'package:flutter/material.dart';

class CompletedBookingData {
  final String bookingId;
  final String bookingDate;
  final String bookingTime;
  final String userName;
  final String mobileNo;
  final String email;
  final String vehicleType;
  final String engineModel;
  final List<String> selectedServices;

  CompletedBookingData({
    required this.bookingId,
    required this.bookingDate,
    required this.bookingTime,
    required this.userName,
    required this.mobileNo,
    required this.email,
    required this.vehicleType,
    required this.engineModel,
    required this.selectedServices,
  });
}

class CarWashCompletedBookings extends StatelessWidget {
  CarWashCompletedBookings({super.key});

  final List<CompletedBookingData> completedBookings = [
    CompletedBookingData(
      bookingId: "RO-2025-06-0020",
      bookingDate: "Jun 20 2025",
      bookingTime: "11:00am",
      userName: "Alice Brown",
      mobileNo: "+971 99865 25001",
      email: "alice@gmail.com",
      vehicleType: "SUV",
      engineModel: "Pajero",
      selectedServices: ["Exterior Wash", "Tire Shine", "Vacuuming"],
    ),
    CompletedBookingData(
      bookingId: "RO-2025-06-0021",
      bookingDate: "Jun 21 2025",
      bookingTime: "12:30pm",
      userName: "Bob Smith",
      mobileNo: "+971 99865 25002",
      email: "bob@gmail.com",
      vehicleType: "Hatchback",
      engineModel: "i20",
      selectedServices: ["Interior Cleaning", "Mat Cleaning"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: completedBookings.length,
        itemBuilder: (context, index) {
          final booking = completedBookings[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          booking.bookingId,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Completed',
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
                    _buildDetailRow('Booking Date', booking.bookingDate),
                    _buildDetailRow('Booking Time', booking.bookingTime),
                    _buildDetailRow('User Name', booking.userName),
                    _buildDetailRow('Mobile No', booking.mobileNo),
                    _buildDetailRow('Email ID', booking.email),
                    _buildDetailRow('Vehicle Type', booking.vehicleType),
                    _buildDetailRow('Engine Model', booking.engineModel),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
