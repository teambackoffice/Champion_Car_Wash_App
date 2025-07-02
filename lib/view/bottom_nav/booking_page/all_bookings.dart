import 'package:flutter/material.dart';

class BookingData {
  final String id;
  final String status;
  final DateTime bookingDate;
  final String bookingTime;
  final String registrationNumber;
  final List<String> services;
  
  BookingData({
    required this.id,
    required this.status,
    required this.bookingDate,
    required this.bookingTime,
    required this.registrationNumber,
    required this.services,
  });
}

class AllBookingsPage extends StatefulWidget {
  @override
  _AllBookingsPageState createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 1;
  
  final List<BookingData> bookings = [
    BookingData(
      id: 'RO-2025-06-0039',
      status: 'Completed',
      bookingDate: DateTime(2025, 6, 25),
      bookingTime: '12:00pm',
      registrationNumber: 'R-2025-AJ-0039',
      services: ['Super Car Wash', 'Oil Change'],
    ),
    BookingData(
      id: 'RO-2025-06-0039',
      status: 'Cancelled',
      bookingDate: DateTime(2025, 6, 25),
      bookingTime: '12:00pm',
      registrationNumber: 'R-2025-AJ-0039',
      services: ['Super Car Wash', 'Oil Change'],
    ),
    BookingData(
      id: 'RO-2025-06-0039',
      status: 'Pending',
      bookingDate: DateTime(2025, 6, 25),
      bookingTime: '12:00pm',
      registrationNumber: 'R-2025-AJ-0039',
      services: ['Super Car Wash', 'Oil Change'],
    ),
    BookingData(
      id: 'RO-2025-06-0039',
      status: 'Completed',
      bookingDate: DateTime(2025, 6, 25),
      bookingTime: '12:00pm',
      registrationNumber: 'R-2025-AJ-0039',
      services: ['Super Car Wash', 'Oil Change'],
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'All Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Customer by Vehicle Number',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          
          // Date Filter
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'June 25 2025 Wednesday',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Icon(Icons.tune, color: Colors.grey[600]),
              ],
            ),
          ),
          
          // Booking List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with ID and Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              booking.id,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(booking.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking.status,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 12),
                        
                        // Booking Details
                        _buildDetailRow('Booking Date', '${booking.bookingDate.day} ${_getMonthName(booking.bookingDate.month)} ${booking.bookingDate.year}'),
                        _buildDetailRow('Booking Time', booking.bookingTime),
                        _buildDetailRow('Registration Number', booking.registrationNumber),
                        
                        SizedBox(height: 8),
                        
                        // Services
                        Text(
                          'Selected Services',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        ...booking.services.map((service) => Padding(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text(
                            service,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      // Bottom Navigation
     
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}