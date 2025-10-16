// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stripe_terminal/stripe_terminal.dart';
// import 'package:champion_car_wash_app/config/api_constants.dart';
//
// /// Stripe Terminal Service for NFC Card Reader / POS
// /// Accepts physical contactless cards (tap to pay)
// /// NOT Apple Pay/Google Pay - this is for merchant accepting customer's physical card
// class StripeTerminalService {
//   static final StripeTerminalService _instance = StripeTerminalService._internal();
//   factory StripeTerminalService() => _instance;
//   StripeTerminalService._internal();
//
//   static StripeTerminalService get instance => _instance;
//
//   // Backend API endpoints
//   static const String _connectionTokenEndpoint = 'api/method/carwash.Api.stripe_payment.create_connection_token';
//   static const String _createPaymentIntentEndpoint = 'api/method/carwash.Api.stripe_payment.create_payment_intent';
//
//   StripeTerminal? _terminal;
//   StripeReader? _connectedReader;
//   bool _isInitialized = false;
//
//   // Session cookies for authentication
//   Map<String, String> _headers = {
//     'Content-Type': 'application/json',
//   };
//
//   /// Set session cookies for API authentication
//   void setSessionCookies(String cookies) {
//     _headers['Cookie'] = cookies;
//   }
//
//   /// Initialize Stripe Terminal SDK
//   Future<Map<String, dynamic>> initialize() async {
//     if (_isInitialized && _terminal != null) {
//       return {
//         'success': true,
//         'message': 'Already initialized',
//       };
//     }
//
//     try {
//       print('Stripe Terminal: Initializing...');
//
//       _terminal = await StripeTerminal.getInstance(
//         fetchToken: () async {
//           // Fetch connection token from backend
//           final token = await _fetchConnectionToken();
//           return token['secret'] ?? '';
//         },
//       );
//
//       _isInitialized = true;
//       print('Stripe Terminal: Initialized successfully');
//
//       return {
//         'success': true,
//         'message': 'Stripe Terminal initialized',
//       };
//     } catch (e) {
//       print('Stripe Terminal: Initialization error: $e');
//       _isInitialized = false;
//
//       return {
//         'success': false,
//         'error': 'Failed to initialize: $e',
//       };
//     }
//   }
//
//   /// Fetch connection token from backend
//   Future<Map<String, dynamic>> _fetchConnectionToken() async {
//     try {
//       final url = Uri.parse('${ApiConstants.baseUrl}$_connectionTokenEndpoint');
//       print('Stripe Terminal: Fetching connection token...');
//
//       final response = await http.post(url, headers: _headers);
//
//       print('Stripe Terminal: Response: ${response.statusCode}');
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['message'] != null && data['message']['success'] == true) {
//           return {
//             'success': true,
//             'secret': data['message']['secret'],
//           };
//         }
//       }
//
//       return {
//         'success': false,
//         'error': 'Failed to get connection token',
//       };
//     } catch (e) {
//       print('Stripe Terminal: Connection token error: $e');
//       return {
//         'success': false,
//         'error': 'Network error: $e',
//       };
//     }
//   }
//
//   /// Discover readers (physical POS devices or phone as POS)
//   /// For Stripe Reader M2, BBPOS WisePad 3, Tap to Pay on iPhone/Android, etc.
//   Future<Map<String, dynamic>> discoverReaders({
//     DiscoveryMethod method = DiscoveryMethod.bluetooth,
//     bool simulated = false,
//     String? locationId,
//   }) async {
//     if (_terminal == null) {
//       final initResult = await initialize();
//       if (!initResult['success']) return initResult;
//     }
//
//     try {
//       print('Stripe Terminal: Discovering readers...');
//       print('Stripe Terminal: Method: $method, Simulated: $simulated');
//
//       final readers = <StripeReader>[];
//
//       // Listen for discovered readers
//       final stream = _terminal!.discoverReaders(
//         DiscoverConfig(
//           discoveryMethod: method,
//           simulated: simulated,
//           locationId: locationId,
//         ),
//       );
//
//       // Collect readers for 10 seconds
//       final subscription = stream.listen((foundReaders) {
//         print('Stripe Terminal: Found ${foundReaders.length} reader(s)');
//         readers.addAll(foundReaders);
//       });
//
//       // Wait for discovery to complete
//       await Future.delayed(const Duration(seconds: 10));
//       await subscription.cancel();
//
//       if (readers.isEmpty) {
//         return {
//           'success': false,
//           'error': 'No readers found. Make sure reader is powered on and in pairing mode.',
//           'readers': [],
//         };
//       }
//
//       print('Stripe Terminal: Discovery complete. Found ${readers.length} readers');
//
//       return {
//         'success': true,
//         'readers': readers,
//         'message': 'Found ${readers.length} reader(s)',
//       };
//     } catch (e) {
//       print('Stripe Terminal: Discovery error: $e');
//       return {
//         'success': false,
//         'error': 'Discovery failed: $e',
//         'readers': [],
//       };
//     }
//   }
//
//   /// Connect to a Bluetooth reader
//   Future<Map<String, dynamic>> connectToReader({
//     required String serialNumber,
//     String? locationId,
//   }) async {
//     if (_terminal == null) {
//       return {
//         'success': false,
//         'error': 'Terminal not initialized',
//       };
//     }
//
//     try {
//       print('Stripe Terminal: Connecting to reader: $serialNumber');
//
//       final connected = await _terminal!.connectBluetoothReader(
//         serialNumber,
//         locationId: locationId,
//       );
//
//       if (connected) {
//         print('Stripe Terminal: Connected successfully');
//
//         // Get connected reader info
//         final readerInfo = await _terminal!.fetchConnectedReader();
//         _connectedReader = readerInfo;
//
//         return {
//           'success': true,
//           'reader': readerInfo,
//           'message': 'Connected to ${readerInfo?.label ?? serialNumber}',
//         };
//       } else {
//         return {
//           'success': false,
//           'error': 'Failed to connect to reader',
//         };
//       }
//     } catch (e) {
//       print('Stripe Terminal: Connection error: $e');
//       return {
//         'success': false,
//         'error': 'Connection failed: $e',
//       };
//     }
//   }
//
//   /// Create payment intent for Terminal
//   Future<Map<String, dynamic>> _createPaymentIntent({
//     required double amount,
//     required String invoiceName,
//     required String serviceId,
//   }) async {
//     try {
//       final url = Uri.parse('${ApiConstants.baseUrl}$_createPaymentIntentEndpoint');
//       print('Stripe Terminal: Creating payment intent...');
//
//       final amountInSmallestUnit = (amount * 100).toInt();
//
//       final body = json.encode({
//         'amount': amountInSmallestUnit,
//         'invoice_name': invoiceName,
//         'service_id': serviceId,
//         'payment_method_types': ['card_present'], // For Terminal
//         'capture_method': 'automatic',
//       });
//
//       final response = await http.post(url, headers: _headers, body: body);
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['message'] != null && data['message']['success'] == true) {
//           return {
//             'success': true,
//             'client_secret': data['message']['client_secret'],
//             'payment_intent_id': data['message']['payment_intent_id'],
//           };
//         }
//       }
//
//       return {
//         'success': false,
//         'error': 'Failed to create payment intent',
//       };
//     } catch (e) {
//       print('Stripe Terminal: Payment intent error: $e');
//       return {
//         'success': false,
//         'error': 'Network error: $e',
//       };
//     }
//   }
//
//   /// Process payment with connected NFC reader
//   /// Customer taps their physical card on the reader
//   Future<Map<String, dynamic>> processPayment({
//     required double amount,
//     required String invoiceName,
//     required String serviceId,
//   }) async {
//     if (_terminal == null || _connectedReader == null) {
//       return {
//         'success': false,
//         'error': 'No reader connected. Connect to a reader first.',
//       };
//     }
//
//     try {
//       print('Stripe Terminal: Processing payment...');
//       print('Stripe Terminal: Amount: $amount AED');
//
//       // Step 1: Create payment intent
//       final paymentIntentResult = await _createPaymentIntent(
//         amount: amount,
//         invoiceName: invoiceName,
//         serviceId: serviceId,
//       );
//
//       if (!paymentIntentResult['success']) {
//         return paymentIntentResult;
//       }
//
//       final clientSecret = paymentIntentResult['client_secret'];
//       print('Stripe Terminal: Payment intent created');
//
//       // Step 2: Collect payment method (customer taps card)
//       print('Stripe Terminal: Ready to collect payment');
//       print('Stripe Terminal: Customer should tap their card now...');
//
//       final collectedPaymentIntent = await _terminal!.collectPaymentMethod(clientSecret);
//
//       print('Stripe Terminal: Payment method collected');
//       print('Stripe Terminal: Payment status: ${collectedPaymentIntent.status}');
//
//       // Payment is complete - the stripe_terminal package handles processing automatically
//       return {
//         'success': true,
//         'payment_intent_id': collectedPaymentIntent.id,
//         'status': collectedPaymentIntent.status.name,
//         'amount': amount,
//         'currency': 'AED',
//         'method': 'TERMINAL_NFC_CARD',
//         'reader': _connectedReader?.label ?? 'Unknown',
//         'message': 'Payment completed successfully',
//       };
//     } catch (e) {
//       print('Stripe Terminal: Payment error: $e');
//
//       return {
//         'success': false,
//         'error': 'Payment failed: $e',
//       };
//     }
//   }
//
//   /// Disconnect from reader
//   Future<void> disconnectReader() async {
//     try {
//       await _terminal?.disconnectFromReader();
//       _connectedReader = null;
//       print('Stripe Terminal: Disconnected');
//     } catch (e) {
//       print('Stripe Terminal: Disconnect error: $e');
//     }
//   }
//
//   /// Get connected reader info
//   Future<StripeReader?> getConnectedReader() async {
//     try {
//       return await _terminal?.fetchConnectedReader();
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Get connection status
//   Future<ConnectionStatus?> getConnectionStatus() async {
//     try {
//       return await _terminal?.connectionStatus();
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Get status
//   Map<String, dynamic> getStatus() {
//     return {
//       'initialized': _isInitialized,
//       'reader_connected': _connectedReader != null,
//       'reader_label': _connectedReader?.label,
//       'reader_serial': _connectedReader?.serialNumber,
//       'reader_battery_status': _connectedReader?.batteryStatus.name,
//     };
//   }
//
//   /// Listen to native logs (for debugging)
//   Stream<StripeLog>? get nativeLogs => _terminal?.onNativeLogs;
//
//   /// Reset service
//   void reset() {
//     _isInitialized = false;
//     _terminal = null;
//     _connectedReader = null;
//     print('Stripe Terminal: Service reset');
//   }
// }
