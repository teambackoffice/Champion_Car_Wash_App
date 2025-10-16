import 'package:champion_car_wash_app/modal/get_newbooking_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewMorePage extends StatelessWidget {
  final ServiceData booking;

  const ViewMorePage({super.key, required this.booking});

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date); // expects yyyy-MM-dd
      return DateFormat(
        'dd MMMM yyyy',
      ).format(parsedDate); // e.g., 07 July 2025
    } catch (_) {
      return date; // fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View More')),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _buildBookingCard(),
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Expanded(
                child: Text(
                  booking.registrationNumber,
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
          // Info Rows
          _buildInfoRow('Booking Date', _formatDate(booking.purchaseDate)),
          _buildInfoRow('Customer Name', booking.customerName),
          _buildInfoRow('Mobile No', booking.phone),
          _buildInfoRow('Email ID', booking.email),
          _buildInfoRow('Vehicle Type', booking.carType),
          _buildInfoRow('Vehicle Model', booking.model),
          _buildInfoRow('Vehicle Make', booking.make),
          _buildInfoRow('Chassis No', booking.chasisNumber),
          _buildInfoRow('Engine No', booking.engineNumber),
          _buildInfoRow('Address', booking.address),
          _buildInfoRow('Branch', booking.branch),
          _buildInfoRow(
            'Current ODO',
            '${booking.currentOdometerReading.toStringAsFixed(0)} KM',
          ),
          _buildInfoRow(
            'Next ODO',
            '${booking.nextServiceOdometer.toStringAsFixed(0)} KM',
          ),
          _buildInfoRow(
            'Fuel Level',
            '${booking.fuelLevel.toStringAsFixed(0)} %',
          ),

          const SizedBox(height: 16),
          // Selected Services
          Text(
            'Selected Services',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...booking.services.map(
            (service) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                [
                  service.serviceType,
                  if (service.washType != null) service.washType!,
                  if (service.oilBrand != null) service.oilBrand!,
                ].join(' - '),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
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