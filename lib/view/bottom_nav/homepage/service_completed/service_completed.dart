import 'package:champion_car_wash_app/controller/get_completed_controller.dart';
import 'package:champion_car_wash_app/modal/get_completed_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/payment_due.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceCompletedScreen extends StatefulWidget {
  const ServiceCompletedScreen({super.key});

  @override
  _ServiceCompletedScreenState createState() => _ServiceCompletedScreenState();
}

class _ServiceCompletedScreenState extends State<ServiceCompletedScreen> {
  String _searchQuery = '';

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

  // Helper method to format date
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
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 16,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        title: const Text(
          'Service Completed',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase().trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Customer by Vehicle Number',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<GetCompletedController>(
        builder: (context, controller, child) {
          // Show loading indicator
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message
          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
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
            );
          }

          // Show empty state
          if (controller.bookingData.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.grey,
                    size: 48,
                  ),
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

          // Filter data based on search query
          final filteredData = controller.bookingData.where((service) {
            return service.registrationNumber.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
          }).toList();

          // Show message if no results match search
          if (filteredData.isEmpty && _searchQuery.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, color: Colors.grey, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'No matching services found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No completed services match "$_searchQuery"',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
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
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final service = filteredData[index];

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
      ),
    );
  }
}

enum ServiceStatus { completed, paymentPending }
