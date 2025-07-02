import 'package:flutter/material.dart';

class ViewMorePage extends StatefulWidget {
  const ViewMorePage({super.key});

  @override
  State<ViewMorePage> createState() => _ViewMorePageState();
}

class _ViewMorePageState extends State<ViewMorePage> {
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
      'vehicleMake': 'Toyota',
      'purchaseDate': 'Jan 10 2023',
      'chassis': 'CHS123456789',
      'registration': 'ABC1234',
      'services': ['Super Car Wash', 'Oil Change'],
    },
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View More'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Column(
            children: [
              _buildBookingCard(context, booking),
              const SizedBox(height: 16),
            ],
          );
        },
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  booking['id'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
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
          _buildInfoRow('Booking Date', booking['date']),
          _buildInfoRow('Booking Time', booking['time']),
          _buildInfoRow('User Name', booking['userName']),
          _buildInfoRow('Mobile No', booking['mobile']),
          _buildInfoRow('Email ID', booking['email']),
          _buildInfoRow('Vehicle Type', booking['vehicleType']),
          _buildInfoRow('Vehicle Model', booking['engineModel']),
          _buildInfoRow('Vehicle Make', booking['vehicleMake']),
          _buildInfoRow('Purchase Date', booking['purchaseDate']),
          _buildInfoRow('Chassis No', booking['chassis']),
          _buildInfoRow('Registration No', booking['registration']),
          const SizedBox(height: 16),
          Text(
            'Selected Services',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...booking['services'].map<Widget>((service) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
              style: const TextStyle(
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
