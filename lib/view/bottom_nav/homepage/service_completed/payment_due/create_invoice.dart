import 'package:champion_car_wash_app/controller/create_invoice_controller.dart';
import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/invoice_submit.dart';
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
  List<ExtraWorkItem> get extraWorkItems => widget.booking!.extraWorkItems;

  double get subtotal {
    double servicesTotal = services.fold<double>(0, (sum, s) => sum + (s.price ?? 0));
    double extraWorksTotal = extraWorkItems.fold<double>(0, (sum, item) => sum + (item.qty * item.rate));
    return servicesTotal + extraWorksTotal;
  }

  @override
  void initState() {
    super.initState();
    controller = SalesInvoiceController();
  }

  Future<void> _handleCreateInvoice() async {
    // Prepare items list combining services and extra work items
    List<Map<String, dynamic>> items = [];

    // Add service items
    for (var service in services) {
      // Build item description based on service details
      String itemDescription = service.serviceType;
      if (service.washType != null && service.washType!.isNotEmpty) {
        itemDescription += ' - ${service.washType}';
      }
      if (service.oilBrand != null && service.oilBrand!.isNotEmpty) {
        itemDescription += ' - ${service.oilBrand}';
        if (service.oilSubtype != null && service.oilSubtype!.isNotEmpty) {
          itemDescription += ' (${service.oilSubtype})';
        }
      }

      items.add({
        'item_code': service.serviceType, // Backend should map this to actual item
        'item_name': itemDescription,
        'qty': service.qty > 0 ? service.qty : 1,
        'rate': service.price ?? 0,
        'price': service.price ?? 0,
      });
    }

    // Add extra work items
    for (var extraWork in widget.booking!.extraWorkItems) {
      items.add({
        'item_code': extraWork.workItem,
        'item_name': extraWork.workItem,
        'qty': extraWork.qty > 0 ? extraWork.qty : 1,
        'rate': extraWork.rate,
        'price': extraWork.rate,
      });
    }

    // Log items being sent
    print('Total items to send: ${items.length}');
    for (var item in items) {
      print('Item: ${item['item_code']}, Qty: ${item['qty']}, Price: ${item['price']}');
    }

    await controller.submitInvoice(
      customer: widget.booking!.customerName,
      serviceId: widget.booking!.serviceId,
      items: items,
    );

    if (controller.responseMessage?.contains('successfully') ?? false) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InvoiceSubmitPage(booking: widget.booking),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.responseMessage ?? 'Unknown error'),
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

                    // Services and Extra Work Items List
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(24.0),
                        children: [
                          // Services
                          ...services.map((service) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (service.qty > 1)
                                      Text(
                                        '${service.qty} × ₹${(service.price ?? 0).toInt()}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    Text(
                                      '₹${(service.price ?? 0).toInt()}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),

                          // Extra Work Items
                          if (extraWorkItems.isNotEmpty) ...[
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12, top: 8),
                              child: Text(
                                'Extra Work Items',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            ...extraWorkItems.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.workItem,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if (item.qty > 1)
                                        Text(
                                          '${item.qty} × ₹${item.rate.toInt()}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      Text(
                                        '₹${(item.qty * item.rate).toInt()}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ],
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
