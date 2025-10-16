// import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
// import 'package:champion_car_wash_app/service/stripe_payment_service.dart';
// import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/payment_success.dart';
// import 'package:champion_car_wash_app/widgets/common/custom_back_button.dart';
// import 'package:flutter/material.dart';
//
// /// Stripe Payment Page with Backend Integration
// /// Supports Tap to Pay, Card Payments, Apple Pay, and Google Pay
// /// Uses Stripe Payment Sheet for secure payment processing
// class StripePaymentPage extends StatefulWidget {
//   final ServiceCars? booking;
//
//   const StripePaymentPage({
//     super.key,
//     required this.booking,
//   });
//
//   @override
//   State<StripePaymentPage> createState() => _StripePaymentPageState();
// }
//
// class _StripePaymentPageState extends State<StripePaymentPage> {
//   final StripePaymentService _stripeService = StripePaymentService.instance;
//
//   bool _isProcessing = false;
//   String _statusMessage = 'Initializing payment...';
//   List<String> _logs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeStripe();
//   }
//
//   Future<void> _initializeStripe() async {
//     _addLog('🔧 Initializing Stripe SDK with backend...');
//     setState(() {
//       _statusMessage = 'Connecting to backend...';
//     });
//
//     final result = await _stripeService.initialize();
//
//     if (result['success']) {
//       _addLog('✅ Stripe initialized successfully');
//       _addLog('💱 Currency: ${result['currency']}');
//       setState(() {
//         _statusMessage = 'Ready for payment';
//       });
//     } else {
//       _addLog('❌ Stripe initialization failed: ${result['error']}');
//       setState(() {
//         _statusMessage = 'Initialization failed';
//       });
//       _showError(result['error'] ?? 'Failed to initialize Stripe');
//     }
//   }
//
//   void _addLog(String message) {
//     setState(() {
//       _logs.add('${DateTime.now().toIso8601String().substring(11, 19)}: $message');
//     });
//     print('Stripe Payment: $message');
//   }
//
//   Future<void> _processPayment() async {
//     setState(() {
//       _isProcessing = true;
//       _statusMessage = 'Processing payment...';
//     });
//
//     _addLog('💳 Starting payment process...');
//     _addLog('💰 Amount: ${widget.booking!.grandTotal} AED');
//     _addLog('🔄 Opening Stripe Payment Sheet...');
//
//     try {
//       // Get proper invoice name from ERPNext system
//       final invoiceName = await _stripeService.getInvoiceName(widget.booking!.serviceId);
//       _addLog('📋 Invoice: $invoiceName');
//
//       // Use NFC as default payment mode for UAE market
//       _addLog('🇦🇪 Using NFC as default payment mode for UAE');
//       final result = await _stripeService.presentPaymentSheet(
//         amount: widget.booking!.grandTotal,
//         invoiceName: invoiceName,
//         serviceId: widget.booking!.serviceId,
//         useNFCAsDefault: true, // NFC is now the default
//       );
//
//       if (result['success']) {
//         _addLog('✅ Payment successful!');
//         _addLog('💳 Payment ID: ${result['payment_intent_id']}');
//         _addLog('💵 Amount: ${result['amount']} ${result['currency']}');
//
//         setState(() {
//           _statusMessage = 'Payment successful!';
//         });
//
//         // Navigate to success page
//         await Future.delayed(const Duration(seconds: 1));
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PaymentSuccessScreen(),
//             ),
//           );
//         }
//       } else if (result['cancelled'] == true) {
//         _addLog('⚠️ Payment cancelled by user');
//         setState(() {
//           _statusMessage = 'Payment cancelled';
//           _isProcessing = false;
//         });
//       } else {
//         _addLog('❌ Payment failed: ${result['error']}');
//         setState(() {
//           _statusMessage = 'Payment failed';
//           _isProcessing = false;
//         });
//         _showError(result['error'] ?? 'Payment failed');
//       }
//     } catch (e) {
//       _addLog('❌ Payment error: $e');
//       setState(() {
//         _statusMessage = 'Payment error';
//         _isProcessing = false;
//       });
//       _showError('Payment error: $e');
//     }
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tap to Pay - UAE'),
//         backgroundColor: Colors.green, // Green for NFC/contactless theme
//         foregroundColor: Colors.white,
//         leading: const AppBarBackButton(
//           backgroundColor: Colors.white,
//           iconColor: Colors.green,
//         ),
//       ),
//       backgroundColor: const Color(0xFFF6F9FC),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Status Section - NFC/UAE Theme
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.green, Color(0xFF4CAF50)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Icon(
//                     _isProcessing ? Icons.credit_card : Icons.contactless,
//                     size: 60,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     _statusMessage,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   if (_isProcessing) ...[
//                     const SizedBox(height: 16),
//                     const CircularProgressIndicator(color: Colors.white),
//                   ],
//                 ],
//               ),
//             ),
//
//             // Order Details
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.05),
//                     blurRadius: 10,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Order Details',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildDetailRow('Service ID', widget.booking!.serviceId),
//                   _buildDetailRow('Customer', widget.booking!.customerName),
//                   _buildDetailRow('Vehicle', widget.booking!.registrationNumber),
//                   const Divider(height: 24),
//                   _buildDetailRow(
//                     'Amount',
//                     '${widget.booking!.grandTotal.toStringAsFixed(2)} AED',
//                     isTotal: true,
//                   ),
//                 ],
//               ),
//             ),
//
//             // Payment Methods Info
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.contactless, color: Colors.green, size: 24),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'NFC Payment Methods (UAE)',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   _buildPaymentMethodItem(Icons.contactless, 'Tap to Pay (Recommended)', 'Hold your contactless card near the device', isRecommended: true),
//                   _buildPaymentMethodItem(Icons.credit_card, 'Credit/Debit Cards', 'Manual card entry if needed'),
//                   _buildPaymentMethodItem(Icons.apple, 'Apple Pay', 'Quick checkout with Apple Pay'),
//                   _buildPaymentMethodItem(Icons.android, 'Google Pay', 'Fast payments with Google Pay'),
//                 ],
//               ),
//             ),
//
//             // Action Button
//             if (!_isProcessing)
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _processPayment,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green, // Green for NFC theme
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.contactless, size: 20),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Tap to Pay ${widget.booking!.grandTotal.toStringAsFixed(2)} AED',
//                           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//             // Debug Logs
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.black87,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.terminal, color: Colors.green, size: 20),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Payment Logs',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     constraints: BoxConstraints(maxHeight: 200),
//                     child: _logs.isEmpty
//                         ? Center(
//                             child: Text(
//                               'Waiting for payment...',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           )
//                         : ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: _logs.length,
//                             itemBuilder: (context, index) {
//                               final log = _logs[index];
//                               Color textColor = Colors.white;
//
//                               if (log.contains('✅')) {
//                                 textColor = Colors.green;
//                               } else if (log.contains('❌')) {
//                                 textColor = Colors.red;
//                               } else if (log.contains('💳') || log.contains('💰')) {
//                                 textColor = Colors.cyan;
//                               } else if (log.contains('📱')) {
//                                 textColor = Colors.yellow;
//                               }
//
//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(vertical: 2),
//                                 child: Text(
//                                   log,
//                                   style: TextStyle(
//                                     color: textColor,
//                                     fontSize: 12,
//                                     fontFamily: 'monospace',
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPaymentMethodItem(IconData icon, String title, String subtitle, {bool isRecommended = false}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isRecommended ? Colors.green.withValues(alpha: 0.05) : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//         border: isRecommended ? Border.all(color: Colors.green.withValues(alpha: 0.3)) : null,
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: isRecommended
//                   ? Colors.green.withValues(alpha: 0.1)
//                   : const Color(0xFF635BFF).withValues(alpha: 0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               color: isRecommended ? Colors.green : const Color(0xFF635BFF),
//               size: 24
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: isRecommended ? Colors.green.shade700 : Colors.black87,
//                       ),
//                     ),
//                     if (isRecommended) ...[
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Text(
//                           'FAST',
//                           style: TextStyle(
//                             fontSize: 8,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: isTotal ? 18 : 14,
//               fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
//               color: isTotal ? Color(0xFF635BFF) : Colors.grey[700],
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: isTotal ? 18 : 14,
//               fontWeight: FontWeight.bold,
//               color: isTotal ? Color(0xFF635BFF) : Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
