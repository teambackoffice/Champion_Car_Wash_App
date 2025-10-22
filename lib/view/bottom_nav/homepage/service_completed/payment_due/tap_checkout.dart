// import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
// import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/payment_success.dart';
// import 'package:flutter/material.dart';
// import 'package:champion_car_wash_app/service/stripe_payment_service.dart';
// // import 'package:champion_car_wash_app/service/real_nfc_card_reader.dart';
// import 'dart:async';
//
// class TapCheckoutScreen extends StatefulWidget {
//   final ServiceCars? booking;
//   const TapCheckoutScreen({super.key, required this.booking});
//
//   @override
//   State<TapCheckoutScreen> createState() => _TapCheckoutScreenState();
// }
//
// class _TapCheckoutScreenState extends State<TapCheckoutScreen>
//     with SingleTickerProviderStateMixin {
//   bool isLoading = false;
//   bool isProcessing = false;
//   bool isSuccess = false;
//   String? errorMessage;
//   String? statusMessage;
//
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//
//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
//     );
//
//     _init();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _init() async {
//     setState(() => isLoading = true);
//     try {
//       _animationController.forward();
//       await StripePaymentService.instance.initialize();
//       if (mounted) {
//         setState(() => statusMessage = 'Stripe Payment ready');
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => errorMessage = 'Failed to initialize Stripe: $e');
//       }
//     } finally {
//       if (mounted) setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _startStripePayment() async {
//     if (!mounted) return;
//
//     setState(() {
//       isLoading = true;
//       isProcessing = true;
//       isSuccess = false;
//       errorMessage = null;
//       statusMessage = 'Preparing secure payment...';
//     });
//
//     // Restart animation for processing state
//     _animationController.reset();
//     _animationController.forward();
//
//     try {
//       final orderId = widget.booking!.serviceId;
//       final amount = widget.booking!.grandTotal;
//       final customerEmail = widget.booking!.email ?? 'customer@carwash.ae';
//
//       if (!mounted) return;
//       setState(() => statusMessage = 'Opening secure payment sheet...');
//
//       await Future.delayed(const Duration(milliseconds: 500));
//
//       if (!mounted) return;
//
//       // Show NFC card reading dialog
//       final paymentCompleted = await _showNFCCardDialog(amount);
//
//       if (!mounted) return;
//
//       // If user cancelled the dialog
//       if (paymentCompleted == false) {
//         setState(() {
//           isProcessing = false;
//           isLoading = false;
//           statusMessage = 'Payment cancelled';
//         });
//         return;
//       }
//
//       // Process the payment
//       final result = await StripePaymentService.instance.presentPaymentSheet(
//         amount: amount,
//         currency: 'AED',
//         orderId: orderId,
//         customerEmail: customerEmail,
//         description: 'Car Wash Service Payment',
//       );
//
//       print('Payment result: $result');
//
//       if (mounted) {
//         if (result['success'] == true) {
//           setState(() {
//             isSuccess = true;
//             isProcessing = false;
//             isLoading = false;
//             statusMessage = 'Payment successful!';
//           });
//
//           // Show success animation and wait a bit
//           await _showSuccessAnimation();
//
//           // Extra delay to show success state
//           await Future.delayed(const Duration(milliseconds: 500));
//
//           // Navigate to success screen
//           if (mounted) {
//             try {
//               await Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const PaymentSuccessScreen()),
//               );
//             } catch (e) {
//               print('Navigation error: $e');
//             }
//           }
//         } else if (result['cancelled'] == true) {
//           setState(() {
//             isProcessing = false;
//             isLoading = false;
//             statusMessage = 'Payment cancelled';
//           });
//         } else {
//           setState(() {
//             isProcessing = false;
//             isLoading = false;
//             errorMessage = 'Payment failed: ${result['error']}';
//           });
//         }
//       }
//     } catch (e, stackTrace) {
//       print('PAYMENT ERROR: $e');
//       print('STACK TRACE: $stackTrace');
//
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           isProcessing = false;
//           errorMessage = 'Failed to process payment: $e';
//         });
//
//         // Show error dialog
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Payment Error'),
//             content: Text('An error occurred: $e\n\nPlease try again.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> _showSuccessAnimation() async {
//     // Play success animation
//     _animationController.reset();
//     await _animationController.forward();
//     await Future.delayed(const Duration(milliseconds: 1500));
//   }
//
//   /// Show NFC card reading dialog - waits for real card tap
//   Future<bool?> _showNFCCardDialog(double amount) async {
//     return showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return _NFCCardReaderDialog(amount: amount);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Secure Checkout'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: isProcessing ? null : () => Navigator.pop(context),
//         ),
//       ),
//       backgroundColor: Colors.grey[50],
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: ScaleTransition(
//           scale: _scaleAnimation,
//           child: SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Customer Info Card with animation
//                   _buildAnimatedCard(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.receipt_long,
//                                 color: Colors.blue,
//                                 size: 28,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             const Expanded(
//                               child: Text(
//                                 'Payment Details',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         _buildDetailRow(
//                           Icons.person,
//                           'Customer',
//                           widget.booking!.customerName,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildDetailRow(
//                           Icons.confirmation_number,
//                           'Service ID',
//                           widget.booking!.serviceId,
//                         ),
//                         const SizedBox(height: 12),
//                         _buildDetailRow(
//                           Icons.directions_car,
//                           'Vehicle',
//                           '${widget.booking!.make} ${widget.booking!.model}',
//                         ),
//                         const SizedBox(height: 20),
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Colors.blue.shade50, Colors.blue.shade100],
//                             ),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 'Total Amount',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               Text(
//                                 '${widget.booking!.grandTotal.toStringAsFixed(2)} AED',
//                                 style: const TextStyle(
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Payment Methods Card with animation
//                   _buildAnimatedCard(
//                     delay: 200,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Row(
//                           children: [
//                             Icon(Icons.payment, color: Colors.blue, size: 24),
//                             SizedBox(width: 12),
//                             Text(
//                               'Secure Payment Methods',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             _buildPaymentMethodIcon(Icons.credit_card, 'Cards'),
//                             const SizedBox(width: 12),
//                             _buildPaymentMethodIcon(Icons.nfc, 'NFC'),
//                             const SizedBox(width: 12),
//                             _buildPaymentMethodIcon(Icons.apple, 'Apple Pay'),
//                             const SizedBox(width: 12),
//                             _buildPaymentMethodIcon(Icons.wallet, 'Google Pay'),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.green.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(Icons.lock, color: Colors.green, size: 16),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   'Secured by Stripe - PCI DSS Level 1 Certified',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                   // Status Messages with animations
//                   if (statusMessage != null) ...[
//                     _buildStatusMessage(
//                       statusMessage!,
//                       isSuccess ? Colors.green : Colors.blue,
//                       isSuccess ? Icons.check_circle : Icons.info,
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//
//                   if (errorMessage != null) ...[
//                     _buildStatusMessage(
//                       errorMessage!,
//                       Colors.red,
//                       Icons.error,
//                     ),
//                     const SizedBox(height: 12),
//                   ],
//
//                   // Processing Indicator with animation
//                   if (isProcessing) ...[
//                     _buildProcessingIndicator(),
//                     const SizedBox(height: 12),
//                   ],
//
//                   // Success animation
//                   if (isSuccess) ...[
//                     _buildSuccessAnimation(),
//                     const SizedBox(height: 12),
//                   ],
//
//                   // Pay Button with animation
//                   TweenAnimationBuilder<double>(
//                     tween: Tween(begin: 0.0, end: 1.0),
//                     duration: const Duration(milliseconds: 800),
//                     curve: Curves.easeOutBack,
//                     builder: (context, value, child) {
//                       return Transform.scale(
//                         scale: value,
//                         child: child,
//                       );
//                     },
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: ElevatedButton(
//                         onPressed: (isLoading || isProcessing || isSuccess)
//                             ? null
//                             : _startStripePayment,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                           disabledBackgroundColor: Colors.grey[300],
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           elevation: isLoading || isProcessing ? 0 : 4,
//                         ),
//                         child: isLoading
//                             ? const SizedBox(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2.5,
//                                   valueColor:
//                                       AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               )
//                             : Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     isProcessing
//                                         ? Icons.hourglass_empty
//                                         : Icons.lock,
//                                     size: 22,
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Text(
//                                     isProcessing
//                                         ? 'Processing...'
//                                         : 'Pay Securely with Stripe',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       letterSpacing: 0.5,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnimatedCard({required Widget child, int delay = 0}) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: Duration(milliseconds: 600 + delay),
//       curve: Curves.easeOut,
//       builder: (context, value, _) {
//         return Opacity(
//           opacity: value,
//           child: Transform.translate(
//             offset: Offset(0, 20 * (1 - value)),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 20,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: child,
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey[600]),
//         const SizedBox(width: 12),
//         Text(
//           '$label: ',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[600],
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPaymentMethodIcon(IconData icon, String label) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: Colors.blue.withOpacity(0.2),
//                 width: 1.5,
//               ),
//             ),
//             child: Icon(icon, size: 26, color: Colors.blue),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 11,
//               color: Colors.black54,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusMessage(String message, Color color, IconData icon) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeOut,
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: Transform.scale(
//             scale: 0.8 + (0.2 * value),
//             child: child,
//           ),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.4), width: 1.5),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   color: color.withOpacity(0.9),
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProcessingIndicator() {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: const Duration(milliseconds: 600),
//       curve: Curves.easeInOut,
//       builder: (context, value, child) {
//         return Opacity(
//           opacity: value,
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.orange.shade50,
//                   Colors.orange.shade100,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.orange.withOpacity(0.4)),
//             ),
//             child: Column(
//               children: [
//                 SizedBox(
//                   width: 40,
//                   height: 40,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 3,
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Processing payment...',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.orange,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSuccessAnimation() {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.0, end: 1.0),
//       duration: const Duration(milliseconds: 1000),
//       curve: Curves.elasticOut,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: value,
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.green.shade50,
//                   Colors.green.shade100,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.green.withOpacity(0.4)),
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   Icons.check_circle,
//                   size: 60,
//                   color: Colors.green,
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Payment Successful!',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Redirecting to confirmation...',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.green,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
// /// NFC Card Reader Dialog Widget
// class _NFCCardReaderDialog extends StatefulWidget {
//   final double amount;
//
//   const _NFCCardReaderDialog({required this.amount});
//
//   @override
//   State<_NFCCardReaderDialog> createState() => _NFCCardReaderDialogState();
// }
//
// class _NFCCardReaderDialogState extends State<_NFCCardReaderDialog> {
//   StreamSubscription<NFCCardInfo>? _nfcSubscription;
//   bool _isReading = false;
//   String _statusMessage = 'Initializing NFC...';
//   bool _nfcAvailable = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeNFC();
//   }
//
//   Future<void> _initializeNFC() async {
//     print('🔧 Initializing NFC card reader...');
//     setState(() => _statusMessage = 'Initializing NFC...');
//
//     final nfcReader = RealNFCCardReader.instance;
//     final isAvailable = await nfcReader.initialize();
//
//     if (!mounted) return;
//
//     setState(() => _nfcAvailable = isAvailable);
//
//     if (isAvailable) {
//       print('✅ NFC is available, starting card reading...');
//       _startCardReading();
//     } else {
//       print('❌ NFC not available on this device');
//       setState(() => _statusMessage = 'NFC not available - please enable NFC in device settings and try again');
//     }
//   }
//
//   void _startCardReading() {
//     if (_isReading) return;
//
//     setState(() {
//       _isReading = true;
//       _statusMessage = 'Waiting for card tap...';
//     });
//
//     print('📡 Starting NFC card reading session...');
//
//     // final nfcReader = RealNFCCardReader.instance;
//     // final cardStream = nfcReader.startCardReading();
//
//     _nfcSubscription = cardStream.listen(
//       (cardInfo) {
//         print('🎉 Card detected!');
//         print('💳 Card Info: ${cardInfo.toString()}');
//         // print('🆔 Card ID: ${cardInfo.cardId}');
//         print('🔢 Last 4 digits: ${cardInfo.lastFourDigits}');
//         print('� Casrd Type: ${cardInfo.cardType}');
//
//         if (mounted) {
//           setState(() => _statusMessage = 'Card detected! Processing...');
//
//           // Wait a moment to show success, then close
//           Future.delayed(const Duration(milliseconds: 500), () {
//             if (mounted) {
//               Navigator.of(context).pop(true);
//             }
//           });
//         }
//       },
//       onError: (error) {
//         print('❌ NFC Error: $error');
//         if (mounted) {
//           setState(() => _statusMessage = 'Error: $error');
//         }
//       },
//     );
//   }
//
//   void _showNFCSettingsDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Enable NFC'),
//         content: const Text(
//           'To use contactless payments, please:\n\n'
//           '1. Go to Settings > Connected devices\n'
//           '2. Turn on NFC\n'
//           '3. Return to this screen and try again\n\n'
//           'Or use the "Simulate Payment" option for testing.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     print('🛑 Disposing NFC card reader dialog...');
//     _nfcSubscription?.cancel();
//     // RealNFCCardReader.instance.stopCardReading();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // NFC Icon with animation
//               TweenAnimationBuilder<double>(
//                 tween: Tween(begin: 0.8, end: 1.2),
//                 duration: const Duration(milliseconds: 1000),
//                 curve: Curves.easeInOut,
//                 builder: (context, scale, child) {
//                   return Transform.scale(
//                     scale: scale,
//                     child: Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: _isReading
//                             ? Colors.blue.withOpacity(0.1)
//                             : Colors.grey.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         Icons.nfc,
//                         size: 64,
//                         color: _isReading ? Colors.blue : Colors.grey,
//                       ),
//                     ),
//                   );
//                 },
//                 onEnd: () {
//                   if (mounted && _isReading) {
//                     setState(() {});
//                   }
//                 },
//               ),
//               const SizedBox(height: 24),
//
//               // Title
//               Text(
//                 _isReading ? 'Tap Your Card' : 'NFC Reader',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 12),
//
//               // Amount
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 20,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   '${widget.amount.toStringAsFixed(2)} AED',
//                   style: const TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Status message
//               Text(
//                 _statusMessage,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: _isReading ? Colors.black87 : Colors.grey,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               if (_nfcAvailable)
//                 const Text(
//                   'Hold your contactless card near the device',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                 ),
//               const SizedBox(height: 24),
//
//               // Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.of(context).pop(false),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         side: const BorderSide(color: Colors.grey),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _nfcAvailable
//                           ? () {
//                               // Simulate successful card tap
//                               print('✅ Manual simulation triggered');
//                               Navigator.of(context).pop(true);
//                             }
//                           : () {
//                               // Show NFC settings help
//                               _showNFCSettingsDialog();
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _nfcAvailable ? Colors.blue : Colors.orange,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(_nfcAvailable ? 'Simulate Payment' : 'Enable NFC'),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
