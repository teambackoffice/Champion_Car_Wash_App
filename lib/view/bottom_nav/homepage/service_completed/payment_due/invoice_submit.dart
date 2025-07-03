import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/payment_success.dart';
import 'package:flutter/material.dart';

class InvoiceSubmitPage extends StatefulWidget {
  const InvoiceSubmitPage({super.key});

  @override
  State<InvoiceSubmitPage> createState() => _InvoiceSubmitPageState();
}

class _InvoiceSubmitPageState extends State<InvoiceSubmitPage> {
  String selectedPaymentMethod = 'Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xFFF9FAF9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildServiceCard(),
              const SizedBox(height: 16),
              _buildTotalCard(),
              const SizedBox(height: 32),
              _buildPaymentOptions(),
              const Spacer(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: const [
          _ServiceItem(title: 'Super Car Wash', amount: '200 AED'),
          SizedBox(height: 10),
          _ServiceItem(title: 'Oil Change', amount: '300 AED'),
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
      ),
      child: Column(
        children: const [
          _ServiceItem(title: 'Sub Total', amount: '500 AED'),
          SizedBox(height: 10),
          _ServiceItem(title: 'Service Charge', amount: '50 AED'),
          Divider(height: 24),
          _ServiceItem(title: 'Total', amount: '550 AED', isBold: true),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _selectPaymentMethod('Cash'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: selectedPaymentMethod == 'Cash'
                    ? Colors.red
                    : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: selectedPaymentMethod == 'Cash'
                  ? Color(0xFFD32F2F)
                  : Colors.black,
              backgroundColor: selectedPaymentMethod == 'Cash'
                  ? Color(0xFFD32F2F)
                  : Colors.white,
            ),
            child:  Text('Cash',style: TextStyle(color:selectedPaymentMethod == 'Cash'? Colors.white : Colors.black),),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _selectPaymentMethod('Card'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: selectedPaymentMethod == 'Card'
                    ? Colors.red
                    : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              foregroundColor: selectedPaymentMethod == 'Card'
                  ? Color(0xFFD32F2F)
                  : Colors.black,
              backgroundColor: selectedPaymentMethod == 'Card'
                  ? Color(0xFFD32F2F)
                  : Colors.white,
            ),
            child:  Text('Card',style: TextStyle(color:selectedPaymentMethod == 'Card'? Colors.white : Colors.black)),
          ),
        ),
      ],
    );
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
    
    // Optional: Show a brief confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment method selected: $method'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Submit'),
      ),
    );
  }

  void _handleSubmit() {
    // Handle submission based on payment method
     Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));
  }

  
}

class _ServiceItem extends StatelessWidget {
  final String title;
  final String amount;
  final bool isBold;

  const _ServiceItem({
    required this.title,
    required this.amount,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: 16,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(amount, style: style.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}