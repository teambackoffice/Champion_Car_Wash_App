import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
import 'package:champion_car_wash_app/service/stripe_payment_service.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/payment_success.dart';
import 'package:flutter/material.dart';

/// Stripe Payment Page for Test Mode Integration
/// Processes payments when service status is "in progress"
class StripePaymentPage extends StatefulWidget {
  final ServiceCars? booking;
  final String paymentMethod; // 'card' or 'nfc'

  const StripePaymentPage({
    super.key,
    required this.booking,
    this.paymentMethod = 'card',
  });

  @override
  State<StripePaymentPage> createState() => _StripePaymentPageState();
}

class _StripePaymentPageState extends State<StripePaymentPage> {
  final StripePaymentService _stripeService = StripePaymentService.instance;

  bool _isProcessing = false;
  String _statusMessage = 'Initializing payment...';
  List<String> _logs = [];

  // Card form controllers
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expMonthController = TextEditingController();
  final TextEditingController _expYearController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeStripe();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expMonthController.dispose();
    _expYearController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  Future<void> _initializeStripe() async {
    _addLog('🔧 Initializing Stripe SDK...');
    setState(() {
      _statusMessage = 'Initializing Stripe...';
    });

    final result = await _stripeService.initialize();

    if (result['success']) {
      _addLog('✅ Stripe initialized successfully');
      setState(() {
        _statusMessage = widget.paymentMethod == 'nfc'
            ? 'Ready for NFC payment'
            : 'Ready for card payment';
      });
    } else {
      _addLog('❌ Stripe initialization failed: ${result['error']}');
      setState(() {
        _statusMessage = 'Initialization failed';
      });
    }
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toIso8601String().substring(11, 19)}: $message');
    });
    print('Stripe Payment: $message');
  }

  Future<void> _processCardPayment() async {
    // Validate card inputs
    if (_cardNumberController.text.isEmpty ||
        _expMonthController.text.isEmpty ||
        _expYearController.text.isEmpty ||
        _cvcController.text.isEmpty) {
      _showError('Please fill in all card details');
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Processing card payment...';
    });

    _addLog('💳 Processing card payment...');
    _addLog('💰 Amount: ${widget.booking!.grandTotal} AED');

    try {
      final result = await _stripeService.processCardPayment(
        amount: widget.booking!.grandTotal,
        currency: 'AED',
        orderId: widget.booking!.serviceId,
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        expMonth: _expMonthController.text,
        expYear: _expYearController.text,
        cvc: _cvcController.text,
        description: 'Car Wash Service - ${widget.booking!.serviceId}',
      );

      if (result['success']) {
        _addLog('✅ Payment successful!');
        _addLog('💳 Payment ID: ${result['payment_intent_id']}');

        setState(() {
          _statusMessage = 'Payment successful!';
        });

        // Navigate to success page
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(),
            ),
          );
        }
      } else {
        _addLog('❌ Payment failed: ${result['error']}');
        setState(() {
          _statusMessage = 'Payment failed';
          _isProcessing = false;
        });
        _showError(result['error'] ?? 'Payment failed');
      }
    } catch (e) {
      _addLog('❌ Payment error: $e');
      setState(() {
        _statusMessage = 'Payment error';
        _isProcessing = false;
      });
      _showError('Payment error: $e');
    }
  }

  Future<void> _processNFCPayment() async {
    setState(() {
      _isProcessing = true;
      _statusMessage = 'Waiting for NFC card...';
    });

    _addLog('📱 Starting NFC payment...');
    _addLog('💰 Amount: ${widget.booking!.grandTotal} AED');
    _addLog('📱 Hold your NFC card against the phone...');

    try {
      final result = await _stripeService.processNFCPayment(
        amount: widget.booking!.grandTotal,
        currency: 'AED',
        orderId: widget.booking!.serviceId,
        description: 'Car Wash Service - ${widget.booking!.serviceId}',
      );

      if (result['success']) {
        _addLog('✅ NFC payment successful!');
        _addLog('💳 Payment ID: ${result['payment_intent_id']}');
        _addLog('💳 Card ending: ${result['last_four']}');

        setState(() {
          _statusMessage = 'NFC payment successful!';
        });

        // Navigate to success page
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentSuccessScreen(),
            ),
          );
        }
      } else {
        _addLog('❌ NFC payment failed: ${result['error']}');
        setState(() {
          _statusMessage = 'NFC payment failed';
          _isProcessing = false;
        });
        _showError(result['error'] ?? 'NFC payment failed');
      }
    } catch (e) {
      _addLog('❌ NFC payment error: $e');
      setState(() {
        _statusMessage = 'NFC payment error';
        _isProcessing = false;
      });
      _showError('NFC payment error: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paymentMethod == 'nfc' ? 'Stripe NFC Payment' : 'Stripe Card Payment'),
        backgroundColor: const Color(0xFF635BFF), // Stripe purple
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF6F9FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Status Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF635BFF), Color(0xFF7A73FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _isProcessing ? Icons.credit_card : Icons.credit_card_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _statusMessage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_isProcessing) ...[
                    const SizedBox(height: 16),
                    CircularProgressIndicator(color: Colors.white),
                  ],
                ],
              ),
            ),

            // Order Details
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Service ID', widget.booking!.serviceId),
                  _buildDetailRow('Customer', widget.booking!.customerName),
                  _buildDetailRow('Vehicle', widget.booking!.registrationNumber),
                  const Divider(height: 24),
                  _buildDetailRow(
                    'Amount',
                    '${widget.booking!.grandTotal.toStringAsFixed(2)} AED',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            // Payment Form
            if (widget.paymentMethod == 'card' && !_isProcessing)
              _buildCardForm(),

            // Action Button
            if (!_isProcessing)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.paymentMethod == 'nfc'
                        ? _processNFCPayment
                        : _processCardPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF635BFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      widget.paymentMethod == 'nfc'
                          ? 'Start NFC Payment'
                          : 'Pay ${widget.booking!.grandTotal.toStringAsFixed(2)} AED',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

            // Debug Logs
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.terminal, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Payment Logs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: _logs.isEmpty
                        ? Center(
                            child: Text(
                              'Waiting for payment...',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _logs.length,
                            itemBuilder: (context, index) {
                              final log = _logs[index];
                              Color textColor = Colors.white;

                              if (log.contains('✅')) {
                                textColor = Colors.green;
                              } else if (log.contains('❌')) {
                                textColor = Colors.red;
                              } else if (log.contains('💳') || log.contains('💰')) {
                                textColor = Colors.cyan;
                              } else if (log.contains('📱')) {
                                textColor = Colors.yellow;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  log,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Card Number
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: '4242 4242 4242 4242',
              prefixIcon: Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Expiry and CVC
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expMonthController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'MM',
                    hintText: '12',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _expYearController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'YY',
                    hintText: '25',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _cvcController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CVC',
                    hintText: '123',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Test card info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Test Mode: Use 4242 4242 4242 4242 with any future date and CVC',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Color(0xFF635BFF) : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? Color(0xFF635BFF) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
