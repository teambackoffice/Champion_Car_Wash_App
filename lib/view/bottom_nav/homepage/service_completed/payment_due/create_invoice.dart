import 'package:champion_car_wash_app/view/bottom_nav/homepage/under_process/invoice_success.dart';
import 'package:flutter/material.dart';

class CreateInvoicePage extends StatelessWidget {
  const CreateInvoicePage({super.key});

  // Sample data for services
  final List<Map<String, dynamic>> services = const [
    {'name': 'Super Car Wash', 'price': 200},
    {'name': 'Oil Change', 'price': 300},
    {'name': 'Tire Rotation', 'price': 150},
    {'name': 'Brake Inspection', 'price': 100},
  ];

  // Calculate totals
  double get subtotal =>
      services.fold(0, (sum, service) => sum + service['price']);
  double get serviceCharge => 50;
  double get total => subtotal + serviceCharge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Order ID Container
              Column(
                children: [
                  Text(
                    'Order ID',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'RO-2025-06-0039',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Services ListView Container
              Container(
                height: 300, // Fixed height for services list
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == services.length - 1 ? 0 : 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            service['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${service['price']} AED',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Summary Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Subtotal
                    _buildSummaryRow(
                      'Sub Total',
                      '${subtotal.toInt()} AED',
                      false,
                    ),
                    const SizedBox(height: 16),

                    // Service Charge
                    _buildSummaryRow(
                      'Service Charge',
                      '${serviceCharge.toInt()} AED',
                      false,
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    Container(height: 1, color: Colors.grey[300]),
                    const SizedBox(height: 16),

                    // Total
                    _buildSummaryRow('Total', '${total.toInt()} AED', true),
                  ],
                ),
              ),

              const Spacer(),

              const SizedBox(height: 16),

              // Submit Button - Separate at bottom
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit action
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvoiceSuccessPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB53E3E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Invoice',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, bool isTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
