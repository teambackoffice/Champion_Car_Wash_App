import 'package:champion_car_wash_app/view/bottom_nav/homepage/new_booking/view_More.dart';
import 'package:flutter/material.dart';

class NewBookingsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookings = [
    {
      'id': 'RO-2025-06-0039',
      'date': 'Jun 25 2025',
      'time': '12:00pm',
      'userName': 'User 1',
      'mobile': '+971 99865 25142',
      'email': 'example@gmail.com',
      'vehicleType': 'SUV',
      'engineModel': 'Fortuner',
      'services': ['Super Car Wash', 'Oil Change'],
    },
    {
      'id': 'RO-2025-06-0039',
      'date': 'Jun 25 2025',
      'time': '12:00pm',
      'userName': 'User 1',
      'mobile': '+971 99865 25142',
      'email': 'example@gmail.com',
      'vehicleType': 'SUV',
      'engineModel': 'Fortuner',
      'services': ['Super Car Wash', 'Oil Change'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
       backgroundColor: Colors.white ,
        title: Text(
          'New Bookings',
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
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Customer by Vehicle Number',
                hintStyle: TextStyle(color: Colors.grey[500]),
                suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildBookingCard(context, bookings[index]),
                    if (index < bookings.length - 1) SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Map<String, dynamic> booking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                booking['id'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
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
          SizedBox(height: 16),
          _buildInfoRow('Booking Date', booking['date']),
          _buildInfoRow('Booking Time', booking['time']),
          _buildInfoRow('User Name', booking['userName']),
          _buildInfoRow('Mobile No', booking['mobile']),
          _buildInfoRow('Email ID', booking['email']),
          _buildInfoRow('Vehicle Type', booking['vehicleType']),
          _buildInfoRow('Engine Model', booking['engineModel']),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              // Handle view more button tap
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMorePage()));
            },
            child: Text(
              'View More',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Selected Services',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          ...booking['services'].map<Widget>((service) => Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              service,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          )).toList(),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}