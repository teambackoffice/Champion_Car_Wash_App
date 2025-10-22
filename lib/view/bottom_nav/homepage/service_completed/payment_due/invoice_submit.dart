import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/payment_success.dart';
import 'package:champion_car_wash_app/widgets/common/custom_back_button.dart';
import 'package:flutter/material.dart';

class InvoiceSubmitPage extends StatefulWidget {
  final ServiceCars? booking;
  const InvoiceSubmitPage({super.key, required this.booking});

  @override
  State<InvoiceSubmitPage> createState() => _InvoiceSubmitPageState();
}

class _InvoiceSubmitPageState extends State<InvoiceSubmitPage> {
  String selectedPaymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: const Text('Payment Details'),
          backgroundColor: const Color(0xFFF9FAF9),
          elevation: 0,
          leading: const AppBarBackButton(),
        ),
      ),
      backgroundColor: const Color(0xFFF9FAF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerInfo(),
              const SizedBox(height: 12),
              _buildServicesCard(),
              const SizedBox(height: 12),
              if (widget.booking!.extraWorkItems.isNotEmpty) ...[
                _buildExtraWorksCard(),
                const SizedBox(height: 12),
              ],
              _buildTotalCard(),
              const SizedBox(height: 20),
              _buildPaymentOptions(),
              const Spacer(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service ID',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.booking!.serviceId,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.booking!.customerName,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Registration Number',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.booking!.registrationNumber,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.booking!.services.map(
            (service) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ServiceItem(
                title: _getServiceDisplayName(service),
                amount: '${service.price.toStringAsFixed(2)} AED',
                subtitle: _getServiceSubtitle(service),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraWorksCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Extra Works',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.booking!.extraWorkItems.map(
            (extraWork) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ServiceItem(
                title: extraWork.workItem,
                amount:
                    '${(extraWork.qty * extraWork.rate).toStringAsFixed(2)} AED',
                subtitle:
                    'Qty: ${extraWork.qty} × ${extraWork.rate.toStringAsFixed(2)} AED',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          if (widget.booking!.serviceTotal > 0) ...[
            _ServiceItem(
              title: 'Service Total',
              amount: '${widget.booking!.serviceTotal.toStringAsFixed(2)} AED',
            ),
            const SizedBox(height: 8),
          ],
          if (widget.booking!.oilTotal > 0) ...[
            _ServiceItem(
              title: 'Oil Total',
              amount: '${widget.booking!.oilTotal.toStringAsFixed(2)} AED',
            ),
            const SizedBox(height: 8),
          ],
          if (widget.booking!.carwashTotal > 0) ...[
            _ServiceItem(
              title: 'Car Wash Total',
              amount: '${widget.booking!.carwashTotal.toStringAsFixed(2)} AED',
            ),
            const SizedBox(height: 8),
          ],
          if (widget.booking!.extraWorksTotal > 0) ...[
            _ServiceItem(
              title: 'Extra Works Total',
              amount:
                  '${widget.booking!.extraWorksTotal.toStringAsFixed(2)} AED',
            ),
            const SizedBox(height: 8),
          ],
          const Divider(height: 24, thickness: 1),
          _ServiceItem(
            title: 'Grand Total',
            amount: '${widget.booking!.grandTotal.toStringAsFixed(2)} AED',
            isBold: true,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        // First Row: Cash and Tap
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _selectPaymentMethod('Cash'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: selectedPaymentMethod == 'Cash'
                        ? const Color(0xFFD32F2F)
                        : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: selectedPaymentMethod == 'Cash'
                      ? const Color(0xFFD32F2F)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Cash',
                  style: TextStyle(
                    color: selectedPaymentMethod == 'Cash'
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _selectPaymentMethod('Tap'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: selectedPaymentMethod == 'Tap'
                        ? const Color(0xFFD32F2F)
                        : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: selectedPaymentMethod == 'Tap'
                      ? const Color(0xFFD32F2F)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Tap',
                  style: TextStyle(
                    color: selectedPaymentMethod == 'Tap'
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second Row: Stripe Card and Stripe NFC
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectPaymentMethod('Stripe Card'),
                icon: Icon(
                  Icons.credit_card,
                  size: 20,
                  color: selectedPaymentMethod == 'Stripe Card'
                      ? Colors.white
                      : const Color(0xFF635BFF),
                ),
                label: Text(
                  'Stripe Card',
                  style: TextStyle(
                    color: selectedPaymentMethod == 'Stripe Card'
                        ? Colors.white
                        : const Color(0xFF635BFF),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: selectedPaymentMethod == 'Stripe Card'
                        ? const Color(0xFF635BFF)
                        : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: selectedPaymentMethod == 'Stripe Card'
                      ? const Color(0xFF635BFF)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _selectPaymentMethod('Stripe NFC'),
                icon: Icon(
                  Icons.contactless,
                  size: 20,
                  color: selectedPaymentMethod == 'Stripe NFC'
                      ? Colors.white
                      : const Color(0xFF635BFF),
                ),
                label: Text(
                  'Stripe NFC',
                  style: TextStyle(
                    color: selectedPaymentMethod == 'Stripe NFC'
                        ? Colors.white
                        : const Color(0xFF635BFF),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: selectedPaymentMethod == 'Stripe NFC'
                        ? const Color(0xFF635BFF)
                        : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: selectedPaymentMethod == 'Stripe NFC'
                      ? const Color(0xFF635BFF)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment method selected: $method'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFFD32F2F),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          'Confirm Payment - ${widget.booking!.grandTotal.toStringAsFixed(2)} AED',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _handleSubmit() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Payment'),
          content: Text(
            'Are you sure you want to process payment of ${widget.booking!.grandTotal.toStringAsFixed(2)} AED via $selectedPaymentMethod?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();

                // Route based on selected payment method
                if (selectedPaymentMethod == 'Tap') {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => StripePaymentPage(
                  //       booking: widget.booking,
                  //     ),
                  //   ),
                  //   // MaterialPageRoute(
                  //   //   builder: (context) => TapCheckoutScreen(booking: widget.booking),
                  //   // ),
                  // );
                } else if (selectedPaymentMethod == 'Stripe Card') {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => StripePaymentPage(
                  //       booking: widget.booking,
                  //     ),
                  //   ),
                  // );
                } else if (selectedPaymentMethod == 'Stripe NFC') {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => StripePaymentPage(
                  //       booking: widget.booking,
                  //     ),
                  //   ),
                  // );
                } else {
                  // Cash payment - go directly to success
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentSuccessScreen(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPaymentMethod.contains('Stripe')
                    ? const Color(0xFF635BFF)
                    : const Color(0xFFD32F2F),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  String _getServiceDisplayName(ServiceItem service) {
    if (service.serviceType.toLowerCase().contains('oil')) {
      return '${service.serviceType} - ${service.oilBrand ?? ''} ${service.oilSubtype ?? ''}';
    } else if (service.serviceType.toLowerCase().contains('wash')) {
      return '${service.serviceType} - ${service.washType ?? ''}';
    }
    return service.serviceType;
  }

  String? _getServiceSubtitle(ServiceItem service) {
    if (service.qty > 1) {
      return 'Qty: ${service.qty} × ${(service.price / service.qty).toStringAsFixed(2)} AED';
    }
    return null;
  }
}

class _ServiceItem extends StatelessWidget {
  final String title;
  final String amount;
  final String? subtitle;
  final bool isBold;
  final bool isTotal;

  const _ServiceItem({
    required this.title,
    required this.amount,
    this.subtitle,
    this.isBold = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                  fontSize: isTotal ? 20 : 18,
                  color: isTotal ? const Color(0xFFD32F2F) : Colors.black87,
                ),
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTotal ? 20 : 18,
                color: isTotal ? const Color(0xFFD32F2F) : Colors.black87,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
