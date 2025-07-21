import 'package:flutter/material.dart';

class BookingData {
  final String bookingId;
  final String bookingDate;
  final String bookingTime;
  final String userName;
  final String mobileNo;
  final String email;
  final String vehicleType;
  final String engineModel;
  final List<String> selectedServices;
  final bool isNew;

  BookingData({
    required this.bookingId,
    required this.bookingDate,
    required this.bookingTime,
    required this.userName,
    required this.mobileNo,
    required this.email,
    required this.vehicleType,
    required this.engineModel,
    required this.selectedServices,
    this.isNew = false,
  });
}

class CarWashNewBookings extends StatefulWidget {
  const CarWashNewBookings({super.key});

  @override
  State<CarWashNewBookings> createState() => _CarWashNewBookingsState();
}

class _CarWashNewBookingsState extends State<CarWashNewBookings> {
  final List<BookingData> bookings = [
    BookingData(
      bookingId: "RO-2025-06-0039",
      bookingDate: "Jun 25 2025",
      bookingTime: "12:00pm",
      userName: "User 1",
      mobileNo: "+971 99865 25142",
      email: "example@gmail.com",
      vehicleType: "SUV",
      engineModel: "Fortuner",
      selectedServices: ["Super Car Wash", "Oil Change"],
      isNew: true,
    ),
    BookingData(
      bookingId: "RO-2025-06-0040",
      bookingDate: "Jun 26 2025",
      bookingTime: "2:30pm",
      userName: "User 2",
      mobileNo: "+971 99865 25143",
      email: "user2@gmail.com",
      vehicleType: "Sedan",
      engineModel: "Camry",
      selectedServices: ["Full Service", "Tire Rotation"],
      isNew: true,
    ),
    BookingData(
      bookingId: "RO-2025-06-0041",
      bookingDate: "Jun 27 2025",
      bookingTime: "10:00am",
      userName: "User 3",
      mobileNo: "+971 99865 25144",
      email: "user3@gmail.com",
      vehicleType: "Hatchback",
      engineModel: "Civic",
      selectedServices: ["Basic Wash", "Interior Cleaning"],
      isNew: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index]; // ✅ Proper initialization
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
                    // Header with booking ID and New badge
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
                        if (booking.isNew)
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
                              'New',
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
                    // _buildDetailRow('Mobile No', booking.mobileNo),
                    // _buildDetailRow('Email ID', booking.email),
                    // _buildDetailRow('Vehicle Type', booking.vehicleType),
                    // _buildDetailRow('Engine Model', booking.engineModel),
                    const SizedBox(height: 8),
                    // TextButton(
                    //   onPressed: () =>
                    //       _showMoreDetails(context, booking), // ✅ Fix
                    //   child: const Text(
                    //     'View More',
                    //     style: TextStyle(
                    //       color: Colors.red,
                    //       fontWeight: FontWeight.w500,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selected Services',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            _startService(context, booking.bookingId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Start Service',
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

  void _showMoreDetails(BuildContext context, BookingData booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Details - ${booking.bookingId}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${booking.userName}'),
              Text('Vehicle: ${booking.vehicleType} - ${booking.engineModel}'),
              Text('Contact: ${booking.mobileNo}'),
              Text('Email: ${booking.email}'),
              const SizedBox(height: 12),
              const Text(
                'Services:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...booking.selectedServices.map((service) => Text('• $service')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _startService(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(' $bookingId'),
              content: Text(
                "Are You Sure You Want To Start Service ?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Started car wash for $bookingId'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // TODO: Call backend API to mark car wash service started
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  child: const Text('Start Service'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
