import 'package:champion_car_wash_app/controller/create_invoice_controller.dart';
import 'package:champion_car_wash_app/modal/create_invoice_modal.dart';
import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/under_process/invoice_success.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateInvoicePage extends StatefulWidget {
  final ServiceCars? booking;

  const CreateInvoicePage({super.key, required this.booking});

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  late SalesInvoiceController controller;

  List<ServiceItem> get services => widget.booking!.services;
  double get subtotal => services.fold(0, (sum, s) => sum + s.price);

  @override
  void initState() {
    super.initState();
    controller = SalesInvoiceController();
  }

  Future<void> _handleCreateInvoice() async {
    final invoice = CreateInvoiceModal(
      customer: widget.booking!.customerName,
      serviceId: widget.booking!.serviceId,
      items: services.map((s) {
        return Item(
          itemCode: s.serviceType,
          price: s.price.toDouble(),
          qty: 1, // Assuming qty as 1 for each service, change if needed
        );
      }).toList(),
    );

    await controller.submitInvoice(invoice);

    if (controller.responseMessage?.contains("successfully") ?? false) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InvoiceSuccessPage()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.responseMessage ?? "Unknown error"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SalesInvoiceController>(
      create: (_) => controller,
      child: Consumer<SalesInvoiceController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Header
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Customer: ${widget.booking!.customerName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Registration No : ${widget.booking!.registrationNumber}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Services List
                    Container(
                      height: 200,
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
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.serviceType,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      if (service.washType != null)
                                        Text(
                                          'Wash Type: ${service.washType}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      if (service.oilBrand != null)
                                        Text(
                                          'Oil Brand: ${service.oilBrand}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${service.price.toInt()}',
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

                    // Summary
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('Sub Total', '₹${subtotal.toInt()}'),
                          Divider(color: Colors.grey[300]),
                          _buildSummaryRow(
                            'Total',
                            '₹${subtotal.toInt()}',
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Submit Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : _handleCreateInvoice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB53E3E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : const Text(
                                'Create Invoice',
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

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
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
