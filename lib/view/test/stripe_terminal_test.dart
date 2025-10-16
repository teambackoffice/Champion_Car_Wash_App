// import 'package:flutter/material.dart';
// import 'package:champion_car_wash_app/service/stripe_terminal_service.dart';
// import 'package:stripe_terminal/stripe_terminal.dart' hide Card;
//
// /// Stripe Terminal POS Test Page
// /// Tests physical NFC card reader functionality
// /// For merchant to accept customer's contactless cards
// class StripeTerminalTest extends StatefulWidget {
//   const StripeTerminalTest({super.key});
//
//   @override
//   State<StripeTerminalTest> createState() => _StripeTerminalTestState();
// }
//
// class _StripeTerminalTestState extends State<StripeTerminalTest> {
//   final StripeTerminalService _terminalService = StripeTerminalService.instance;
//
//   bool _isInitialized = false;
//   bool _isDiscovering = false;
//   bool _isConnecting = false;
//   bool _isProcessing = false;
//
//   List<StripeReader> _discoveredReaders = [];
//   StripeReader? _connectedReader;
//
//   String _statusMessage = 'Not initialized';
//   String _lastError = '';
//
//   final TextEditingController _amountController = TextEditingController(text: '10.00');
//   final TextEditingController _invoiceController = TextEditingController(text: 'TEST-TERMINAL-001');
//   final TextEditingController _serviceController = TextEditingController(text: 'SERVICE-001');
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeTerminal();
//   }
//
//   Future<void> _initializeTerminal() async {
//     setState(() {
//       _statusMessage = 'Initializing Stripe Terminal...';
//     });
//
//     final result = await _terminalService.initialize();
//
//     setState(() {
//       _isInitialized = result['success'] == true;
//       _statusMessage = result['success'] == true
//           ? 'Terminal initialized successfully'
//           : 'Failed to initialize: ${result['error']}';
//
//       if (!result['success']) {
//         _lastError = result['error'] ?? 'Unknown error';
//       }
//     });
//   }
//
//   Future<void> _discoverReaders() async {
//     if (!_isInitialized) {
//       _showError('Terminal not initialized');
//       return;
//     }
//
//     setState(() {
//       _isDiscovering = true;
//       _statusMessage = 'Discovering readers...';
//       _discoveredReaders = [];
//       _lastError = '';
//     });
//
//     final result = await _terminalService.discoverReaders(
//       method: DiscoveryMethod.bluetooth,
//       simulated: false, // Set to true for testing without physical reader
//     );
//
//     setState(() {
//       _isDiscovering = false;
//
//       if (result['success'] == true) {
//         _discoveredReaders = result['readers'] as List<StripeReader>;
//         _statusMessage = 'Found ${_discoveredReaders.length} reader(s)';
//
//         if (_discoveredReaders.isEmpty) {
//           _lastError = 'No readers found. Make sure reader is powered on and in pairing mode.';
//         }
//       } else {
//         _statusMessage = 'Discovery failed';
//         _lastError = result['error'] ?? 'Unknown error';
//       }
//     });
//   }
//
//   Future<void> _connectToReader(StripeReader reader) async {
//     setState(() {
//       _isConnecting = true;
//       _statusMessage = 'Connecting to ${reader.label ?? reader.serialNumber}...';
//       _lastError = '';
//     });
//
//     final result = await _terminalService.connectToReader(
//       serialNumber: reader.serialNumber,
//       locationId: null, // TODO: Add your Stripe Terminal location ID
//     );
//
//     setState(() {
//       _isConnecting = false;
//
//       if (result['success'] == true) {
//         _connectedReader = result['reader'] as StripeReader?;
//         _statusMessage = 'Connected to ${_connectedReader?.label ?? 'reader'}';
//       } else {
//         _statusMessage = 'Connection failed';
//         _lastError = result['error'] ?? 'Unknown error';
//       }
//     });
//   }
//
//   Future<void> _disconnectReader() async {
//     await _terminalService.disconnectReader();
//
//     setState(() {
//       _connectedReader = null;
//       _statusMessage = 'Disconnected from reader';
//     });
//   }
//
//   Future<void> _processPayment() async {
//     if (_connectedReader == null) {
//       _showError('No reader connected');
//       return;
//     }
//
//     final amount = double.tryParse(_amountController.text);
//     if (amount == null || amount <= 0) {
//       _showError('Invalid amount');
//       return;
//     }
//
//     setState(() {
//       _isProcessing = true;
//       _statusMessage = 'Creating payment intent...';
//       _lastError = '';
//     });
//
//     final result = await _terminalService.processPayment(
//       amount: amount,
//       invoiceName: _invoiceController.text,
//       serviceId: _serviceController.text,
//     );
//
//     setState(() {
//       _isProcessing = false;
//
//       if (result['success'] == true) {
//         _statusMessage = 'Payment successful!';
//         _showSuccessDialog(result);
//       } else {
//         _statusMessage = 'Payment failed';
//         _lastError = result['error'] ?? 'Unknown error';
//       }
//     });
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
//
//   void _showSuccessDialog(Map<String, dynamic> result) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Payment Successful'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Amount: ${result['amount']} ${result['currency']}'),
//             Text('Payment ID: ${result['payment_intent_id']}'),
//             Text('Status: ${result['status']}'),
//             Text('Method: ${result['method']}'),
//             Text('Reader: ${result['reader']}'),
//           ],
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
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stripe Terminal POS Test'),
//         backgroundColor: const Color(0xFF635BFF),
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Status Card
//             Card(
//               color: _isInitialized ? Colors.green.shade50 : Colors.orange.shade50,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           _isInitialized ? Icons.check_circle : Icons.pending,
//                           color: _isInitialized ? Colors.green : Colors.orange,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             _statusMessage,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (_lastError.isNotEmpty) ...[
//                       const SizedBox(height: 8),
//                       Text(
//                         'Error: $_lastError',
//                         style: const TextStyle(
//                           color: Colors.red,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                     if (_connectedReader != null) ...[
//                       const SizedBox(height: 8),
//                       const Divider(),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Connected Reader',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text('Label: ${_connectedReader!.label ?? 'N/A'}'),
//                       Text('Serial: ${_connectedReader!.serialNumber}'),
//                       Text('Battery: ${_connectedReader!.batteryStatus.name}'),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Initialize Button
//             if (!_isInitialized)
//               ElevatedButton.icon(
//                 onPressed: _initializeTerminal,
//                 icon: const Icon(Icons.power_settings_new),
//                 label: const Text('Initialize Terminal'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF635BFF),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.all(16),
//                 ),
//               ),
//
//             if (_isInitialized) ...[
//               // Discover Readers Button
//               ElevatedButton.icon(
//                 onPressed: _isDiscovering ? null : _discoverReaders,
//                 icon: _isDiscovering
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Icon(Icons.bluetooth_searching),
//                 label: Text(_isDiscovering ? 'Discovering...' : 'Discover Readers'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.all(16),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // Discovered Readers List
//               if (_discoveredReaders.isNotEmpty) ...[
//                 const Text(
//                   'Discovered Readers',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 ..._discoveredReaders.map((reader) => Card(
//                   child: ListTile(
//                     leading: const Icon(Icons.contactless, color: Colors.blue),
//                     title: Text(reader.label ?? 'Unknown Reader'),
//                     subtitle: Text('Serial: ${reader.serialNumber}'),
//                     trailing: _isConnecting
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: () => _connectToReader(reader),
//                             child: const Text('Connect'),
//                           ),
//                   ),
//                 )),
//                 const SizedBox(height: 20),
//               ],
//
//               // Payment Form (only if connected)
//               if (_connectedReader != null) ...[
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Process Payment',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//
//                 TextField(
//                   controller: _amountController,
//                   decoration: const InputDecoration(
//                     labelText: 'Amount (AED)',
//                     border: OutlineInputBorder(),
//                     prefixText: 'AED ',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 10),
//
//                 TextField(
//                   controller: _invoiceController,
//                   decoration: const InputDecoration(
//                     labelText: 'Invoice Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//
//                 TextField(
//                   controller: _serviceController,
//                   decoration: const InputDecoration(
//                     labelText: 'Service ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 ElevatedButton.icon(
//                   onPressed: _isProcessing ? null : _processPayment,
//                   icon: _isProcessing
//                       ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Icon(Icons.credit_card),
//                   label: Text(_isProcessing ? 'Processing...' : 'Collect Payment'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.all(16),
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 OutlinedButton.icon(
//                   onPressed: _disconnectReader,
//                   icon: const Icon(Icons.bluetooth_disabled),
//                   label: const Text('Disconnect Reader'),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: Colors.red,
//                     padding: const EdgeInsets.all(16),
//                   ),
//                 ),
//               ],
//             ],
//
//             const SizedBox(height: 30),
//
//             // Instructions
//             Card(
//               color: Colors.blue.shade50,
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'Instructions',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '1. Initialize Terminal\n'
//                       '2. Discover Readers (Bluetooth or Tap to Pay)\n'
//                       '3. Connect to a Reader\n'
//                       '4. Enter payment details\n'
//                       '5. Tap "Collect Payment"\n'
//                       '6. Customer taps their card on the reader\n'
//                       '7. Payment completes!',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'Note: For Tap to Pay on iPhone, this device must be iPhone XS or newer with iOS 15.5+',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontStyle: FontStyle.italic,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _amountController.dispose();
//     _invoiceController.dispose();
//     _serviceController.dispose();
//     super.dispose();
//   }
// }
