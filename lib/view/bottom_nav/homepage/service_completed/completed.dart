import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/service_completed.dart';
import 'package:flutter/material.dart';

class CompletedTab extends StatelessWidget {
  // Sample data for completed services
  final List<Map<String, dynamic>> completedServices = [
    {
      'serviceId': 'RO-2025-06-0039',
      'bookingDate': 'Jun 25 2025',
      'bookingTime': '12:00pm',
      'registrationNumber': 'R-2025-AJ-0039',
      'services': ['Super Car Wash', 'Oil Change'],
      'amount': '550 AED',
    },
    {
      'serviceId': 'RO-2025-06-0040',
      'bookingDate': 'Jun 25 2025',
      'bookingTime': '2:00pm',
      'registrationNumber': 'R-2025-AJ-0040',
      'services': ['Full Service', 'Tire Rotation'],
      'amount': '750 AED',
    },
    {
      'serviceId': 'RO-2025-06-0041',
      'bookingDate': 'Jun 24 2025',
      'bookingTime': '10:30am',
      'registrationNumber': 'R-2025-AJ-0041',
      'services': ['Basic Wash', 'Interior Cleaning'],
      'amount': '300 AED',
    },
    {
      'serviceId': 'RO-2025-06-0042',
      'bookingDate': 'Jun 24 2025',
      'bookingTime': '3:15pm',
      'registrationNumber': 'R-2025-AJ-0042',
      'services': ['Premium Wash', 'Wax Treatment'],
      'amount': '450 AED',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: completedServices.length,
      itemBuilder: (context, index) {
        final service = completedServices[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ServiceCard(
            serviceId: service['serviceId'],
            bookingDate: service['bookingDate'],
            bookingTime: service['bookingTime'],
            registrationNumber: service['registrationNumber'],
            services: List<String>.from(service['services']),
            amount: service['amount'],
            status: ServiceStatus.completed,
          ),
        );
      },
    );
  }
}

class PaymentDueTab extends StatelessWidget {
  // Sample data for payment pending services
  final List<Map<String, dynamic>> paymentDueServices = [
    {
      'serviceId': 'RO-2025-06-0043',
      'bookingDate': 'Jun 26 2025',
      'bookingTime': '9:00am',
      'registrationNumber': 'R-2025-AJ-0043',
      'services': ['Super Car Wash', 'Oil Change'],
      'amount': '550 AED',
    },
    {
      'serviceId': 'RO-2025-06-0044',
      'bookingDate': 'Jun 26 2025',
      'bookingTime': '11:30am',
      'registrationNumber': 'R-2025-AJ-0044',
      'services': ['Full Service', 'Tire Rotation', 'AC Service'],
      'amount': '850 AED',
    },
    {
      'serviceId': 'RO-2025-06-0045',
      'bookingDate': 'Jun 26 2025',
      'bookingTime': '1:00pm',
      'registrationNumber': 'R-2025-AJ-0045',
      'services': ['Premium Wash', 'Engine Check'],
      'amount': '650 AED',
    },
    {
      'serviceId': 'RO-2025-06-0046',
      'bookingDate': 'Jun 25 2025',
      'bookingTime': '4:30pm',
      'registrationNumber': 'R-2025-AJ-0046',
      'services': ['Basic Wash', 'Oil Change', 'Brake Check'],
      'amount': '480 AED',
    },
    {
      'serviceId': 'RO-2025-06-0047',
      'bookingDate': 'Jun 25 2025',
      'bookingTime': '6:00pm',
      'registrationNumber': 'R-2025-AJ-0047',
      'services': ['Detailing Service'],
      'amount': '200 AED',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: paymentDueServices.length,
      itemBuilder: (context, index) {
        final service = paymentDueServices[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: ServiceCard(
            serviceId: service['serviceId'],
            bookingDate: service['bookingDate'],
            bookingTime: service['bookingTime'],
            registrationNumber: service['registrationNumber'],
            services: List<String>.from(service['services']),
            amount: service['amount'],
            status: ServiceStatus.paymentPending,
            showCreateInvoice: true,
          ),
        );
      },
    );
  }
}