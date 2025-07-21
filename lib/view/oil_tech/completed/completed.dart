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
  final DateTime completedDate;
  final String completedBy;
  final List<String> inspectionItems;

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
    required this.completedDate,
    required this.completedBy,
    required this.inspectionItems,
  });
}

class CompletedBookingsTab extends StatelessWidget {
  CompletedBookingsTab({super.key});

  // Sample data - replace with your actual data source
  final List<CompletedBookingData> completedBookings = [
    CompletedBookingData(
      bookingId: "RO-2025-06-0030",
      bookingDate: "Jun 24 2025",
      bookingTime: "9:00am",
      userName: "John Smith",
      mobileNo: "+971 99865 25130",
      email: "john.smith@gmail.com",
      vehicleType: "SUV",
      engineModel: "Fortuner",
      selectedServices: ["Super Car Wash", "Oil Change"],
      completedDate: DateTime(2025, 6, 24, 11, 30),
      completedBy: "Ahmed Ali",
      inspectionItems: [
        "Engine Oil Check",
        "Brake Fluid Level",
        "Tire Pressure",
        "Battery Check",
        "Lights & Indicators",
        "Windshield Wipers",
        "Air Filter",
        "Coolant Level",
        "Exhaust System",
        "Suspension Check",
        "Interior Cleaning",
        "Exterior Wash",
      ],
    ),
    CompletedBookingData(
      bookingId: "RO-2025-06-0031",
      bookingDate: "Jun 24 2025",
      bookingTime: "10:30am",
      userName: "Sarah Johnson",
      mobileNo: "+971 99865 25131",
      email: "sarah.j@gmail.com",
      vehicleType: "Sedan",
      engineModel: "Camry",
      selectedServices: ["Super Car Wash", "Oil Change"],
      completedDate: DateTime(2025, 6, 24, 14, 15),
      completedBy: "Mohammed Hassan",
      inspectionItems: [
        "Engine Oil Check",
        "Brake Fluid Level",
        "Tire Pressure",
        "Battery Check",
        "Lights & Indicators",
        "Windshield Wipers",
        "Air Filter",
        "Coolant Level",
        "Interior Cleaning",
        "Exterior Wash",
      ],
    ),
    CompletedBookingData(
      bookingId: "RO-2025-06-0032",
      bookingDate: "Jun 24 2025",
      bookingTime: "2:00pm",
      userName: "Mike Wilson",
      mobileNo: "+971 99865 25132",
      email: "mike.wilson@gmail.com",
      vehicleType: "Hatchback",
      engineModel: "Civic",
      selectedServices: ["Super Car Wash", "Oil Change"],
      completedDate: DateTime(2025, 6, 24, 16, 45),
      completedBy: "Ali Rahman",
      inspectionItems: [
        "Engine Oil Check",
        "Tire Pressure",
        "Battery Check",
        "Lights & Indicators",
        "Windshield Wipers",
        "Interior Cleaning",
        "Exterior Wash",
      ],
    ),
    CompletedBookingData(
      bookingId: "RO-2025-06-0033",
      bookingDate: "Jun 23 2025",
      bookingTime: "11:00am",
      userName: "Emma Davis",
      mobileNo: "+971 99865 25133",
      email: "emma.davis@gmail.com",
      vehicleType: "SUV",
      engineModel: "Prado",
      selectedServices: ["Super Car Wash", "Oil Change"],
      completedDate: DateTime(2025, 6, 23, 15, 20),
      completedBy: "Ahmed Ali",
      inspectionItems: [
        "Engine Oil Check",
        "Brake Fluid Level",
        "Tire Pressure",
        "Battery Check",
        "Lights & Indicators",
        "Windshield Wipers",
        "Air Filter",
        "Coolant Level",
        "Exhaust System",
        "Suspension Check",
        "Interior Cleaning",
        "Exterior Wash",
      ],
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
          return CompletedBookingCard(
            booking: completedBookings[index],
            onTap: () => _navigateToDetails(context, completedBookings[index]),
          );
        },
      ),
    );
  }

  void _navigateToDetails(BuildContext context, CompletedBookingData booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(booking: booking),
      ),
    );
  }
}

class CompletedBookingCard extends StatelessWidget {
  final CompletedBookingData booking;
  final VoidCallback onTap;

  const CompletedBookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with booking ID and Completed badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.bookingId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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

              // Car details
              _buildDetailRow('Booking Date', booking.bookingDate),
              _buildDetailRow('Booking Time', booking.bookingTime),
              _buildDetailRow('User Name', booking.userName),
              // _buildDetailRow('Mobile No', booking.mobileNo),
              // _buildDetailRow('Email ID', booking.email),
              // _buildDetailRow('Vehicle Type', booking.vehicleType),
              // _buildDetailRow('Engine Model', booking.engineModel),
              // _buildDetailRow('Completed By', booking.completedBy),
              // _buildDetailRow(
              //   'Completed On',
              //   _formatCompletedDate(booking.completedDate),
              // ),

              // const SizedBox(height: 16),

              // Selected Services
              const Text(
                'Selected Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Services list
              ...booking.selectedServices.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    service,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tap to view details hint
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(Icons.touch_app, size: 16, color: Colors.grey[600]),
              //     const SizedBox(width: 4),
              //     Text(
              //       'Tap to view full details',
              //       style: TextStyle(
              //         fontSize: 12,
              //         color: Colors.grey[600],
              //         fontStyle: FontStyle.italic,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompletedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class BookingDetailsScreen extends StatelessWidget {
  final CompletedBookingData booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(booking.bookingId),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Service Completed',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Completed on ${_formatCompletedDate(booking.completedDate)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'By ${booking.completedBy}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Customer Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Booking Date', booking.bookingDate),
                    _buildDetailRow('Booking Time', booking.bookingTime),
                    _buildDetailRow('Customer Name', booking.userName),
                    _buildDetailRow('Mobile Number', booking.mobileNo),
                    _buildDetailRow('Email Address', booking.email),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Vehicle Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vehicle Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Vehicle Type', booking.vehicleType),
                    _buildDetailRow('Engine Model', booking.engineModel),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Services Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Services Performed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...booking.selectedServices.map(
                      (service) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green[600],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                service,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
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

            const SizedBox(height: 16),

            // Inspection Checklist Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Inspection Checklist',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...booking.inspectionItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_box,
                              color: Colors.green[600],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
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

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCompletedDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
