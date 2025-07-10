import 'package:champion_car_wash_app/controller/get_completed_controller.dart';
import 'package:champion_car_wash_app/modal/get_completed_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/payment_due.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/service_completed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedTab extends StatefulWidget {
  const CompletedTab({super.key});

  @override
  State<CompletedTab> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetCompletedController>(
        context,
        listen: false,
      ).fetchcompletedlist();
    });
  }

  // Helper method to format services list
  List<String> _formatServices(List<ConpletedServiceItem> services) {
    return services.map((service) {
      String serviceText = service.serviceType;
      if (service.washType.isNotEmpty) {
        serviceText += ' - ${service.washType}';
      }
      if (service.oilBrand != null && service.oilBrand!.isNotEmpty) {
        serviceText += ' (${service.oilBrand})';
      }
      return serviceText;
    }).toList();
  }

  // Helper method to calculate total amount
  String _calculateTotalAmount(List<ConpletedServiceItem> services) {
    double total = services.fold(0.0, (sum, service) => sum + service.price);
    return '${total.toStringAsFixed(2)} AED';
  }

  // Helper method to format date (you may need to adjust based on your date format)
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day} ${date.year}';
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GetCompletedController>(
      builder: (context, controller, child) {
        // Show loading indicator
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message
        if (controller.error != null) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading completed services',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.error!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.clearError();
                      controller.fetchcompletedlist();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show empty state
        if (controller.bookingData.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, color: Colors.grey, size: 48),
                SizedBox(height: 16),
                Text(
                  'No completed services found',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Completed services will appear here',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Show completed services list
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchcompletedlist();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.bookingData.length,
            itemBuilder: (context, index) {
              final service = controller.bookingData[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ServiceCard(
                  serviceId: service.serviceId,
                  bookingDate: _formatDate(service.purchaseDate),
                  customerName: service.customerName,
                  registrationNumber: service.registrationNumber,
                  services: _formatServices(service.services),
                  amount: _calculateTotalAmount(service.services),
                  status: ServiceStatus.completed,
                ),
              );
            },
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

  PaymentDueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: paymentDueServices.length,
      itemBuilder: (context, index) {
        final service = paymentDueServices[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ServiceCard(
            serviceId: service['serviceId'],
            bookingDate: service['bookingDate'],
            registrationNumber: service['registrationNumber'],
            services: List<String>.from(service['services']),
            amount: service['amount'],
            status: ServiceStatus.paymentPending,
            showCreateInvoice: true,
            customerName: 'Akhil',
          ),
        );
      },
    );
  }
}
