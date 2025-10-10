import 'package:flutter/material.dart';
import '../../service/stripe_payment_service.dart';

class StripePaymentTest extends StatefulWidget {
  const StripePaymentTest({Key? key}) : super(key: key);

  @override
  State<StripePaymentTest> createState() => _StripePaymentTestState();
}

class _StripePaymentTestState extends State<StripePaymentTest> {
  final List<String> _logs = [];
  bool _isProcessing = false;
  Map<String, dynamic>? _lastResult;
  bool _nfcSupported = false;

  // Test data
  final double _testAmount = 1.0;
  final String _testCurrency = 'AED';

  // Test card data (Stripe test card)
  final String _testCardNumber = '4242424242424242';
  final String _testExpMonth = '12';
  final String _testExpYear = '25';
  final String _testCVC = '123';

  @override
  void initState() {
    super.initState();
    _addLog('🚀 Stripe Payment Test initialized');
    _addLog('📝 Using flutter_stripe package');
    _addLog('');
    _addLog('💡 Stripe advantages:');
    _addLog('   ✅ Industry-leading payment processor');
    _addLog('   ✅ Built-in NFC support (Tap to Pay)');
    _addLog('   ✅ PCI compliant payment sheet');
    _addLog('   ✅ Supports all card types');
    _addLog('   ✅ Apple Pay & Google Pay ready');
    _addLog('   ✅ 3DS2 automatic');
    _addLog('');
    _initSDK();
    _checkNFCSupport();
  }

  void _addLog(String message) {
    setState(() {
      final now = DateTime.now();
      final timestamp = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      _logs.add('[$timestamp] $message');
    });
    print('Stripe Test: $message');
  }

  Future<void> _initSDK() async {
    _addLog('⏳ Initializing Stripe SDK...');

    final result = await StripePaymentService.instance.initialize();

    if (result['success']) {
      _addLog('✅ Stripe SDK initialized successfully');
      _addLog('   Key: ${result['publishable_key'] ?? 'configured'}');
      _addLog('   Merchant: merchant.com.championcarwash.ae');
    } else {
      _addLog('❌ Stripe SDK initialization failed: ${result['error']}');
    }
  }

  Future<void> _checkNFCSupport() async {
    _addLog('🔍 Checking NFC support...');

    final supported = await StripePaymentService.instance.isNFCSupported();

    setState(() {
      _nfcSupported = supported;
    });

    if (supported) {
      _addLog('✅ NFC/Tap to Pay is supported on this device');
    } else {
      _addLog('⚠️ NFC/Tap to Pay may not be available');
    }
  }

  Future<void> _testCardPayment() async {
    setState(() {
      _isProcessing = true;
      _lastResult = null;
    });

    _addLog('');
    _addLog('💳 TEST: Secure Card Payment');
    _addLog('────────────────────────────');
    _addLog('📋 Amount: $_testAmount $_testCurrency');
    _addLog('📋 Uses secure payment sheet for PCI compliance');
    _addLog('');
    _addLog('⏳ Processing secure card payment...');

    try {
      final orderId = 'STRIPE_${DateTime.now().millisecondsSinceEpoch}';

      final result = await StripePaymentService.instance.processCardPayment(
        amount: _testAmount,
        currency: _testCurrency,
        orderId: orderId,
        cardNumber: _testCardNumber,
        expMonth: _testExpMonth,
        expYear: _testExpYear,
        cvc: _testCVC,
        description: 'Car wash service test payment',
      );

      setState(() {
        _lastResult = result;
      });

      if (result['success']) {
        _addLog('');
        _addLog('🎉 Card payment successful!');
        _addLog('');
        _addLog('📊 Payment Details:');
        _addLog('   Payment Intent: ${result['payment_intent_id']}');
        _addLog('   Status: ${result['status']}');
        _addLog('   Amount: ${result['amount']} ${result['currency']}');
      } else if (result['cancelled'] == true) {
        _addLog('');
        _addLog('⏹️ Payment cancelled by user');
      } else {
        _addLog('');
        _addLog('❌ Card payment failed');
        _addLog('   Error: ${result['error']}');
        _addLog('   Code: ${result['error_code']}');
      }
    } catch (e) {
      _addLog('❌ Exception: $e');
      setState(() {
        _lastResult = {
          'success': false,
          'error': e.toString(),
        };
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _testPaymentSheet() async {
    setState(() {
      _isProcessing = true;
      _lastResult = null;
    });

    _addLog('');
    _addLog('📱 TEST: Payment Sheet');
    _addLog('────────────────────────────');
    _addLog('📋 Amount: $_testAmount $_testCurrency');
    _addLog('📋 Opens Stripe\'s payment UI');
    _addLog('📋 Supports cards, NFC, Apple/Google Pay');
    _addLog('');
    _addLog('⏳ Opening payment sheet...');

    try {
      final orderId = 'SHEET_${DateTime.now().millisecondsSinceEpoch}';

      final result = await StripePaymentService.instance.presentPaymentSheet(
        amount: _testAmount,
        currency: _testCurrency,
        orderId: orderId,
        customerEmail: 'test@carwash.ae',
        description: 'Car wash service test payment',
      );

      setState(() {
        _lastResult = result;
      });

      if (result['success']) {
        _addLog('');
        _addLog('🎉 Payment successful!');
        _addLog('');
        _addLog('📊 Payment Details:');
        _addLog('   Payment Intent: ${result['payment_intent_id']}');
        _addLog('   Status: ${result['status']}');
        _addLog('   Amount: ${result['amount']} ${result['currency']}');
      } else if (result['cancelled'] == true) {
        _addLog('');
        _addLog('⏹️ Payment cancelled by user');
      } else {
        _addLog('');
        _addLog('❌ Payment failed');
        _addLog('   Error: ${result['error']}');
        _addLog('   Code: ${result['error_code']}');
      }
    } catch (e) {
      _addLog('❌ Exception: $e');
      setState(() {
        _lastResult = {
          'success': false,
          'error': e.toString(),
        };
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _testNFCPayment() async {
    setState(() {
      _isProcessing = true;
      _lastResult = null;
    });

    _addLog('');
    _addLog('📱 TEST: NFC Payment (Tap to Pay)');
    _addLog('────────────────────────────────────');
    _addLog('📋 Amount: $_testAmount $_testCurrency');
    _addLog('📋 Hold card near device to pay');
    _addLog('');
    _addLog('⏳ Starting NFC payment...');

    try {
      final orderId = 'NFC_${DateTime.now().millisecondsSinceEpoch}';

      final result = await StripePaymentService.instance.processNFCPayment(
        amount: _testAmount,
        currency: _testCurrency,
        orderId: orderId,
        description: 'Car wash service - NFC payment',
      );

      setState(() {
        _lastResult = result;
      });

      if (result['success']) {
        _addLog('');
        _addLog('🎉 NFC payment successful!');
        _addLog('');
        _addLog('📊 Payment Details:');
        _addLog('   Payment Intent: ${result['payment_intent_id']}');
        _addLog('   Status: ${result['status']}');
        _addLog('   Method: ${result['method']}');
        _addLog('   Amount: ${result['amount']} ${result['currency']}');
      } else if (result['cancelled'] == true) {
        _addLog('');
        _addLog('⏹️ Payment cancelled by user');
      } else {
        _addLog('');
        _addLog('❌ NFC payment failed');
        _addLog('   Error: ${result['error']}');
        _addLog('   Code: ${result['error_code']}');
      }
    } catch (e) {
      _addLog('❌ Exception: $e');
      setState(() {
        _lastResult = {
          'success': false,
          'error': e.toString(),
        };
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _checkStatus() async {
    _addLog('');
    _addLog('🔍 STRIPE STATUS CHECK');
    _addLog('────────────────────────────');
    
    try {
      final status = StripePaymentService.instance.getStatus();
      
      _addLog('📊 Configuration:');
      _addLog('   Initialized: ${status['initialized']}');
      _addLog('   Publishable Key: ${status['publishable_key']}');
      _addLog('   Merchant ID: ${status['merchant_identifier']}');
      _addLog('   NFC Support: ${status['nfc_supported']}');
      _addLog('');
      _addLog('✅ Status check completed');
    } catch (e) {
      _addLog('❌ Status check failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Icon(
                  _isProcessing ? Icons.hourglass_empty : Icons.payment,
                  size: 48,
                  color: _isProcessing ? Colors.orange : Colors.blue,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Stripe Payment Integration',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _nfcSupported
                      ? '✅ NFC Supported | PCI Compliant | World-Class'
                      : '✅ PCI Compliant | World-Class Payment Processing',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Test controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _testPaymentSheet,
                  icon: const Icon(Icons.credit_card),
                  label: const Text('1. 🌟 Payment Sheet (RECOMMENDED)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _testCardPayment,
                  icon: const Icon(Icons.credit_card_outlined),
                  label: const Text('2. 💳 Secure Card Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _testNFCPayment,
                  icon: const Icon(Icons.nfc),
                  label: const Text('3. 📱 NFC Payment (Tap to Pay)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _checkStatus,
                  icon: const Icon(Icons.info),
                  label: const Text('4. 🔍 Check Stripe Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '💡 Test Cards:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Visa: 4242 4242 4242 4242\n'
                        'Mastercard: 5555 5555 5555 4444\n'
                        'Amex: 3782 822463 10005\n'
                        'Exp: Any future date | CVC: Any 3 digits',
                        style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results section
          if (_lastResult != null) _buildResultCard(),

          // Logs section
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Test Logs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_logs.length} entries',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        Color textColor = Colors.white;

                        if (log.contains('✅') || log.contains('🎉')) {
                          textColor = Colors.green;
                        } else if (log.contains('❌')) {
                          textColor = Colors.red;
                        } else if (log.contains('⏳')) {
                          textColor = Colors.orange;
                        } else if (log.contains('⏹️') || log.contains('⚠️')) {
                          textColor = Colors.yellow;
                        } else if (log.contains('📊') || log.contains('💡') || log.contains('🔍')) {
                          textColor = Colors.cyan;
                        } else if (log.contains('💳') || log.contains('📱')) {
                          textColor = Colors.purple;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            log,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 11,
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
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final result = _lastResult!;
    final isSuccess = result['success'] ?? false;
    final isCancelled = result['cancelled'] ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSuccess
            ? Colors.green.shade50
            : isCancelled
                ? Colors.orange.shade50
                : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSuccess
              ? Colors.green
              : isCancelled
                  ? Colors.orange
                  : Colors.red,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSuccess
                    ? Icons.check_circle
                    : isCancelled
                        ? Icons.cancel
                        : Icons.error,
                color: isSuccess
                    ? Colors.green
                    : isCancelled
                        ? Colors.orange
                        : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                isSuccess
                    ? 'Success'
                    : isCancelled
                        ? 'Cancelled'
                        : 'Failed',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSuccess
                      ? Colors.green
                      : isCancelled
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (result['payment_intent_id'] != null) ...[
            Text('Payment Intent: ${result['payment_intent_id']}',
                style: const TextStyle(fontSize: 12)),
          ],
          if (result['status'] != null) ...[
            Text('Status: ${result['status']}',
                style: const TextStyle(fontSize: 12)),
          ],
          if (result['error'] != null) ...[
            Text('Error: ${result['error']}',
                style: const TextStyle(fontSize: 12, color: Colors.red)),
          ],
        ],
      ),
    );
  }
}
