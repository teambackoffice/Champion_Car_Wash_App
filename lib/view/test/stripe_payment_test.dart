// import 'package:flutter/material.dart';
// import '../../service/stripe_payment_service.dart';
//
// class StripePaymentTest extends StatefulWidget {
//   const StripePaymentTest({Key? key}) : super(key: key);
//
//   @override
//   State<StripePaymentTest> createState() => _StripePaymentTestState();
// }
//
// class _StripePaymentTestState extends State<StripePaymentTest> {
//   final List<String> _logs = [];
//   bool _isProcessing = false;
//   Map<String, dynamic>? _lastResult;
//   bool _nfcSupported = true;
//
//   // Test data
//   final double _testAmount = 1.0;
//   final String _testCurrency = 'AED';
//
//   @override
//   void initState() {
//     super.initState();
//     _addLog('🚀 Stripe Payment Test initialized');
//     _addLog('📝 Using flutter_stripe package');
//     _addLog('');
//     _addLog('💡 Stripe advantages:');
//     _addLog('   ✅ Industry-leading payment processor');
//     _addLog('   ✅ Built-in NFC support (Tap to Pay)');
//     _addLog('   ✅ PCI compliant payment sheet');
//     _addLog('   ✅ Supports all card types');
//     _addLog('   ✅ Apple Pay & Google Pay ready');
//     _addLog('   ✅ 3DS2 automatic');
//     _addLog('');
//     _initSDK();
//     _checkNFCSupport();
//   }
//
//   void _addLog(String message) {
//     setState(() {
//       final now = DateTime.now();
//       final timestamp = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
//       _logs.add('[$timestamp] $message');
//     });
//     print('Stripe Test: $message');
//   }
//
//   Future<void> _initSDK() async {
//     _addLog('⏳ Initializing Stripe SDK...');
//
//     final result = await StripePaymentService.instance.initialize();
//
//     if (result['success']) {
//       _addLog('✅ Stripe SDK initialized successfully');
//       _addLog('   Key: ${result['publishable_key'] ?? 'configured'}');
//       _addLog('   Merchant: merchant.com.championcarwash.ae');
//     } else {
//       _addLog('❌ Stripe SDK initialization failed: ${result['error']}');
//     }
//   }
//
//   Future<void> _checkNFCSupport() async {
//     _addLog('🔍 Checking NFC support...');
//
//     final supported = await StripePaymentService.instance.isNFCSupported();
//
//     setState(() {
//       _nfcSupported = supported;
//     });
//
//     if (supported) {
//       _addLog('✅ NFC/Tap to Pay is supported on this device');
//     } else {
//       _addLog('⚠️ NFC/Tap to Pay may not be available');
//     }
//   }
//
//   Future<void> _testBackendIntegration() async {
//     setState(() {
//       _isProcessing = true;
//       _lastResult = null;
//     });
//
//     _addLog('');
//     _addLog('🔌 TEST: Backend Integration');
//     _addLog('────────────────────────────');
//     _addLog('📋 Testing connection to backend...');
//     _addLog('');
//
//     try {
//       // Reset and reinitialize to test backend
//       StripePaymentService.instance.reset();
//       _addLog('⏳ Fetching Stripe configuration from backend...');
//
//       final result = await StripePaymentService.instance.initialize();
//
//       setState(() {
//         _lastResult = result;
//       });
//
//       if (result['success']) {
//         _addLog('');
//         _addLog('✅ Backend integration successful!');
//         _addLog('');
//         _addLog('📊 Configuration:');
//         _addLog('   Publishable Key: ${result['publishable_key']}');
//         _addLog('   Currency: ${result['currency']}');
//       } else {
//         _addLog('');
//         _addLog('❌ Backend integration failed');
//         _addLog('   Error: ${result['error']}');
//       }
//     } catch (e) {
//       _addLog('❌ Exception: $e');
//       setState(() {
//         _lastResult = {
//           'success': false,
//           'error': e.toString(),
//         };
//       });
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }
//
//   Future<void> _testPaymentSheet() async {
//     setState(() {
//       _isProcessing = true;
//       _lastResult = null;
//     });
//
//     _addLog('');
//     _addLog('📱 TEST: Payment Sheet with Backend');
//     _addLog('────────────────────────────────────');
//     _addLog('📋 Amount: $_testAmount $_testCurrency');
//     _addLog('📋 NFC as default payment mode for UAE');
//     _addLog('📋 Opens Stripe Payment Sheet with NFC priority');
//     _addLog('📋 Supports: NFC/Tap to Pay (default), Apple Pay, Google Pay, Cards');
//     _addLog('');
//     _addLog('🇦🇪 UAE market configuration with AED currency');
//     _addLog('💡 Using real invoice name from ERPNext system');
//     _addLog('⏳ Creating NFC-default payment intent...');
//
//     try {
//       final serviceId = 'TEST-${DateTime.now().millisecondsSinceEpoch}';
//       // Use a real invoice name format that exists in ERPNext
//       final invoiceName = 'ACC-SINV-2025-00004'; // Replace with actual invoice from ERPNext
//
//       final result = await StripePaymentService.instance.presentPaymentSheet(
//         amount: _testAmount,
//         invoiceName: invoiceName,
//         serviceId: serviceId,
//         customerEmail: 'test@carwash.ae',
//         useNFCAsDefault: true, // NFC is now default for UAE
//       );
//
//       setState(() {
//         _lastResult = result;
//       });
//
//       if (result['success']) {
//         _addLog('');
//         _addLog('🎉 Payment successful!');
//         _addLog('');
//         _addLog('📊 Payment Details:');
//         _addLog('   Payment Intent: ${result['payment_intent_id']}');
//         _addLog('   Status: ${result['status']}');
//         _addLog('   Amount: ${result['amount']} ${result['currency']}');
//         _addLog('   Method: ${result['method']}');
//       } else if (result['cancelled'] == true) {
//         _addLog('');
//         _addLog('⏹️ Payment cancelled by user');
//       } else {
//         _addLog('');
//         _addLog('❌ Payment failed');
//         _addLog('   Error: ${result['error']}');
//         if (result['error_code'] != null) {
//           _addLog('   Code: ${result['error_code']}');
//         }
//       }
//     } catch (e) {
//       _addLog('❌ Exception: $e');
//       setState(() {
//         _lastResult = {
//           'success': false,
//           'error': e.toString(),
//         };
//       });
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }
//
//   Future<void> _testNFCPaymentSheet() async {
//     setState(() {
//       _isProcessing = true;
//       _lastResult = null;
//     });
//
//     _addLog('');
//     _addLog('📱 TEST: NFC-Optimized Payment Sheet');
//     _addLog('──────────────────────────────────────');
//     _addLog('📋 Amount: $_testAmount $_testCurrency');
//     _addLog('📋 NFC-first configuration');
//     _addLog('📋 Contactless cards, Apple Pay, Google Pay');
//     _addLog('📋 Minimal UI for faster NFC experience');
//     _addLog('');
//     _addLog('⏳ Creating NFC-optimized payment...');
//
//     try {
//       final serviceId = 'NFC-TEST-${DateTime.now().millisecondsSinceEpoch}';
//       final invoiceName = 'ACC-SINV-2025-00004'; // Use real invoice
//
//       final result = await StripePaymentService.instance.presentNFCPaymentSheet(
//         amount: _testAmount,
//         invoiceName: invoiceName,
//         serviceId: serviceId,
//         customerEmail: 'nfc-test@carwash.ae',
//       );
//
//       setState(() {
//         _lastResult = result;
//       });
//
//       if (result['success']) {
//         _addLog('');
//         _addLog('🎉 NFC Payment successful!');
//         _addLog('');
//         _addLog('📊 NFC Payment Details:');
//         _addLog('   Payment Intent: ${result['payment_intent_id']}');
//         _addLog('   Status: ${result['status']}');
//         _addLog('   Amount: ${result['amount']} ${result['currency']}');
//         _addLog('   Method: ${result['method']}');
//       } else if (result['cancelled'] == true) {
//         _addLog('');
//         _addLog('⏹️ NFC Payment cancelled by user');
//       } else {
//         _addLog('');
//         _addLog('❌ NFC Payment failed');
//         _addLog('   Error: ${result['error']}');
//         if (result['error_code'] != null) {
//           _addLog('   Code: ${result['error_code']}');
//         }
//       }
//     } catch (e) {
//       _addLog('❌ NFC Exception: $e');
//       setState(() {
//         _lastResult = {
//           'success': false,
//           'error': e.toString(),
//         };
//       });
//     } finally {
//       setState(() {
//         _isProcessing = false;
//       });
//     }
//   }
//
//   Future<void> _checkPaymentMethods() async {
//     _addLog('');
//     _addLog('🔍 PAYMENT METHODS CHECK');
//     _addLog('────────────────────────────');
//     _addLog('📋 Checking available payment options...');
//
//     try {
//       final methods = await StripePaymentService.instance.checkAvailablePaymentMethods();
//
//       _addLog('');
//       _addLog('📊 Available Payment Methods:');
//       _addLog('   🍎 Apple Pay: ${methods['apple_pay'] ? '✅ Available' : '❌ Not available'}');
//       _addLog('   🤖 Google Pay: ${methods['google_pay'] ? '✅ Available' : '❌ Not available'}');
//       _addLog('   📱 NFC/Contactless: ${methods['nfc_contactless'] ? '✅ Supported' : '❌ Not supported'}');
//       _addLog('   💳 Card Payments: ${methods['card_payments'] ? '✅ Always available' : '❌ Error'}');
//       _addLog('');
//       _addLog('💡 Recommended: ${methods['recommended_method']}');
//
//       if (methods['error'] != null) {
//         _addLog('⚠️ Error: ${methods['error']}');
//       }
//
//       _addLog('');
//       _addLog('✅ Payment methods check completed');
//     } catch (e) {
//       _addLog('❌ Payment methods check failed: $e');
//     }
//   }
//
//   Future<void> _checkStatus() async {
//     _addLog('');
//     _addLog('🔍 STRIPE STATUS CHECK');
//     _addLog('────────────────────────────');
//
//     try {
//       final status = StripePaymentService.instance.getStatus();
//
//       _addLog('📊 Configuration:');
//       _addLog('   Initialized: ${status['initialized']}');
//       _addLog('   Publishable Key: ${status['publishable_key']}');
//       _addLog('   Merchant ID: ${status['merchant_identifier']}');
//       _addLog('   NFC Support: ${status['tap_to_pay_supported']}');
//       _addLog('   Apple Pay: ${status['apple_pay_supported']}');
//       _addLog('   Google Pay: ${status['google_pay_supported']}');
//       _addLog('   Backend URL: ${status['backend_url']}');
//       _addLog('');
//       _addLog('✅ Status check completed');
//     } catch (e) {
//       _addLog('❌ Status check failed: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     // MEMORY LEAK FIX: Clear logs list to free memory
//     _logs.clear();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stripe Payment Test'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // Header section
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             color: Colors.blue.shade50,
//             child: Column(
//               children: [
//                 Icon(
//                   _isProcessing ? Icons.hourglass_empty : Icons.payment,
//                   size: 48,
//                   color: _isProcessing ? Colors.orange : Colors.blue,
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Stripe Payment Integration',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _nfcSupported
//                       ? '✅ NFC Supported | PCI Compliant | World-Class'
//                       : '✅ PCI Compliant | World-Class Payment Processing',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.blue,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//
//           // Test controls
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: _isProcessing ? null : _testBackendIntegration,
//                   icon: const Icon(Icons.cloud),
//                   label: const Text('1. 🔌 Test Backend Integration'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: _isProcessing ? null : _testPaymentSheet,
//                   icon: const Icon(Icons.contactless),
//                   label: const Text('2. 🇦🇪 NFC Default Payment (UAE)'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: _isProcessing ? null : _testNFCPaymentSheet,
//                   icon: const Icon(Icons.nfc),
//                   label: const Text('3. 📱 Advanced NFC Payment'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.teal,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: _isProcessing ? null : _checkPaymentMethods,
//                   icon: const Icon(Icons.payment),
//                   label: const Text('4. 🔍 Check Payment Methods'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton.icon(
//                   onPressed: _isProcessing ? null : _checkStatus,
//                   icon: const Icon(Icons.info),
//                   label: const Text('5. 🔍 Check Stripe Status'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey.shade600,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.amber.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.amber.shade200),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: const [
//                       Text(
//                         '💡 Test Cards:',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Visa: 4242 4242 4242 4242\n'
//                         'Mastercard: 5555 5555 5555 4444\n'
//                         'Amex: 3782 822463 10005\n'
//                         'Exp: Any future date | CVC: Any 3 digits',
//                         style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Results section
//           if (_lastResult != null) _buildResultCard(),
//
//           // Logs section
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.black87,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.grey),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       const Text(
//                         'Test Logs',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Spacer(),
//                       Text(
//                         '${_logs.length} entries',
//                         style: const TextStyle(color: Colors.grey, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: _logs.length,
//                       itemBuilder: (context, index) {
//                         final log = _logs[index];
//                         Color textColor = Colors.white;
//
//                         if (log.contains('✅') || log.contains('🎉')) {
//                           textColor = Colors.green;
//                         } else if (log.contains('❌')) {
//                           textColor = Colors.red;
//                         } else if (log.contains('⏳')) {
//                           textColor = Colors.orange;
//                         } else if (log.contains('⏹️') || log.contains('⚠️')) {
//                           textColor = Colors.yellow;
//                         } else if (log.contains('📊') || log.contains('💡') || log.contains('🔍')) {
//                           textColor = Colors.cyan;
//                         } else if (log.contains('💳') || log.contains('📱')) {
//                           textColor = Colors.purple;
//                         }
//
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 1),
//                           child: Text(
//                             log,
//                             style: TextStyle(
//                               color: textColor,
//                               fontSize: 11,
//                               fontFamily: 'monospace',
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildResultCard() {
//     final result = _lastResult!;
//     final isSuccess = result['success'] ?? false;
//     final isCancelled = result['cancelled'] ?? false;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isSuccess
//             ? Colors.green.shade50
//             : isCancelled
//                 ? Colors.orange.shade50
//                 : Colors.red.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: isSuccess
//               ? Colors.green
//               : isCancelled
//                   ? Colors.orange
//                   : Colors.red,
//           width: 2,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 isSuccess
//                     ? Icons.check_circle
//                     : isCancelled
//                         ? Icons.cancel
//                         : Icons.error,
//                 color: isSuccess
//                     ? Colors.green
//                     : isCancelled
//                         ? Colors.orange
//                         : Colors.red,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 isSuccess
//                     ? 'Success'
//                     : isCancelled
//                         ? 'Cancelled'
//                         : 'Failed',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: isSuccess
//                       ? Colors.green
//                       : isCancelled
//                           ? Colors.orange
//                           : Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           if (result['payment_intent_id'] != null) ...[
//             Text('Payment Intent: ${result['payment_intent_id']}',
//                 style: const TextStyle(fontSize: 12)),
//           ],
//           if (result['status'] != null) ...[
//             Text('Status: ${result['status']}',
//                 style: const TextStyle(fontSize: 12)),
//           ],
//           if (result['error'] != null) ...[
//             Text('Error: ${result['error']}',
//                 style: const TextStyle(fontSize: 12, color: Colors.red)),
//           ],
//         ],
//       ),
//     );
//   }
// }
