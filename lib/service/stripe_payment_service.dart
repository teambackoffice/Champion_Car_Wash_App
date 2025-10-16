// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:champion_car_wash_app/config/api_constants.dart';
//
// /// Stripe Payment Service with Backend Integration
// /// Uses flutter_stripe package for Stripe Payment Sheet
// /// Supports Tap to Pay (NFC contactless card reading) via Stripe Payment Sheet
// class StripePaymentService {
//   static final StripePaymentService _instance = StripePaymentService._internal();
//   factory StripePaymentService() => _instance;
//   StripePaymentService._internal();
//
//   static StripePaymentService get instance => _instance;
//
//   // Backend API endpoints
//   static const String _getPublishableKeyEndpoint = 'api/method/carwash.Api.stripe_payment.get_publishable_key';
//   static const String _createPaymentIntentEndpoint = 'api/method/carwash.Api.stripe_payment.create_payment_intent';
//
//   String? _publishableKey;
//   String? _currency;
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
//   /// Initialize Stripe SDK with backend configuration
//   Future<Map<String, dynamic>> initialize() async {
//     if (_isInitialized && _publishableKey != null) {
//       return {
//         'success': true,
//         'message': 'Already initialized',
//         'publishable_key': _publishableKey!.substring(0, 20) + '...',
//         'currency': _currency,
//       };
//     }
//
//     try {
//       print('Stripe: Fetching configuration from backend...');
//
//       // Step 1: Get publishable key from backend
//       final configResult = await _getPublishableKey();
//
//       if (!configResult['success']) {
//         return {
//           'success': false,
//           'error': 'Failed to get Stripe configuration: ${configResult['error']}',
//         };
//       }
//
//       _publishableKey = configResult['publishable_key'];
//       _currency = configResult['currency'] ?? 'AED';
//
//       print('Stripe: Initializing SDK with backend config...');
//
//       // Step 2: Initialize Stripe with publishable key from backend
//       Stripe.publishableKey = _publishableKey!;
//       Stripe.merchantIdentifier = 'merchant.com.championcarwash.ae';
//
//       // Configure Stripe settings
//       await Stripe.instance.applySettings();
//
//       _isInitialized = true;
//       print('Stripe: SDK initialized successfully');
//       print('Stripe: Currency: $_currency');
//
//       return {
//         'success': true,
//         'message': 'Stripe initialized successfully',
//         'publishable_key': _publishableKey!.substring(0, 20) + '...',
//         'currency': _currency,
//       };
//     } catch (e) {
//       print('Stripe: Initialization error: $e');
//       _isInitialized = false;
//
//       // Provide helpful error messages
//       String errorMessage = 'Initialization failed: $e';
//       if (e.toString().contains('FlutterFragmentActivity')) {
//         errorMessage = 'Android configuration issue: MainActivity must extend FlutterFragmentActivity. Please rebuild the app.';
//       } else if (e.toString().contains('flutter_stripe initialization failed')) {
//         errorMessage = 'Stripe initialization failed. Please check Android configuration and rebuild the app.';
//       }
//
//       return {
//         'success': false,
//         'error': errorMessage,
//       };
//     }
//   }
//
//   /// Get Stripe publishable key from backend
//   Future<Map<String, dynamic>> _getPublishableKey() async {
//     try {
//       final url = Uri.parse('${ApiConstants.baseUrl}$_getPublishableKeyEndpoint');
//       print('Stripe API: GET $url');
//
//       final response = await http.get(url, headers: _headers);
//
//       print('Stripe API: Response status: ${response.statusCode}');
//       print('Stripe API: Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['message'] != null && data['message']['success'] == true) {
//           return {
//             'success': true,
//             'publishable_key': data['message']['publishable_key'],
//             'currency': data['message']['currency'],
//             'enabled': data['message']['enabled'],
//           };
//         } else {
//           return {
//             'success': false,
//             'error': 'Invalid response format from backend',
//           };
//         }
//       } else {
//         return {
//           'success': false,
//           'error': 'HTTP ${response.statusCode}: ${response.body}',
//         };
//       }
//     } catch (e) {
//       print('Stripe API: Error getting publishable key: $e');
//       return {
//         'success': false,
//         'error': 'Network error: $e',
//       };
//     }
//   }
//
//   /// Create payment intent on backend
//   Future<Map<String, dynamic>> _createPaymentIntent({
//     required double amount,
//     required String invoiceName,
//     required String serviceId,
//     bool optimizeForNFC = false,
//   }) async {
//     try {
//       final url = Uri.parse('${ApiConstants.baseUrl}$_createPaymentIntentEndpoint');
//       print('Stripe API: POST $url');
//
//       // Convert amount to smallest currency unit (fils for AED)
//       final amountInSmallestUnit = (amount * 100).toInt();
//
//       final body = json.encode({
//         'amount': amountInSmallestUnit,
//         'invoice_name': invoiceName,
//         'service_id': serviceId,
//         'optimize_for_nfc': optimizeForNFC,
//         'payment_method_types': optimizeForNFC
//             ? ['card', 'apple_pay', 'google_pay']
//             : ['card'],
//       });
//
//       print('Stripe API: Request body: $body');
//
//       final response = await http.post(
//         url,
//         headers: _headers,
//         body: body,
//       );
//
//       print('Stripe API: Response status: ${response.statusCode}');
//       print('Stripe API: Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['message'] != null && data['message']['success'] == true) {
//           return {
//             'success': true,
//             'client_secret': data['message']['client_secret'],
//             'payment_intent_id': data['message']['payment_intent_id'],
//             'amount': data['message']['amount'],
//             'currency': data['message']['currency'],
//             'publishable_key': data['message']['publishable_key'],
//           };
//         } else {
//           return {
//             'success': false,
//             'error': 'Invalid response format from backend',
//           };
//         }
//       } else {
//         return {
//           'success': false,
//           'error': 'HTTP ${response.statusCode}: ${response.body}',
//         };
//       }
//     } catch (e) {
//       print('Stripe API: Error creating payment intent: $e');
//       return {
//         'success': false,
//         'error': 'Network error: $e',
//       };
//     }
//   }
//
//   /// Present Stripe Payment Sheet with NFC as default payment mode
//   /// NFC/Tap to Pay is prioritized for UAE market
//   /// Supports: NFC/Tap to Pay (default), Apple Pay, Google Pay, Card payments
//   Future<Map<String, dynamic>> presentPaymentSheet({
//     required double amount,
//     required String invoiceName,
//     required String serviceId,
//     String? customerEmail,
//     bool enableLink = false, // Disable Stripe Link by default
//     bool useNFCAsDefault = true, // NFC is now the default payment mode
//   }) async {
//     try {
//       // Step 1: Ensure Stripe is initialized
//       if (!_isInitialized) {
//         final initResult = await initialize();
//         if (!initResult['success']) {
//           return initResult;
//         }
//       }
//
//       print('Stripe: Creating payment intent on backend...');
//       print('Stripe: Amount: $amount ${_currency ?? 'AED'}');
//
//       // Step 2: Create payment intent with NFC as default
//       final paymentIntentResult = await _createPaymentIntent(
//         amount: amount,
//         invoiceName: invoiceName,
//         serviceId: serviceId,
//         optimizeForNFC: useNFCAsDefault, // NFC optimization enabled by default
//       );
//
//       if (!paymentIntentResult['success']) {
//         return paymentIntentResult;
//       }
//
//       final clientSecret = paymentIntentResult['client_secret'];
//       final paymentIntentId = paymentIntentResult['payment_intent_id'];
//
//       print('Stripe: Payment intent created: $paymentIntentId');
//
//       // Step 3: Initialize payment sheet with NFC as default mode
//       print('Stripe: Initializing NFC-first payment sheet for UAE market...');
//       print('Stripe: 📱 NFC/Tap to Pay is the default payment mode');
//       print('Stripe: 🇦🇪 Configured for UAE (AE) with AED currency');
//
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: clientSecret,
//           merchantDisplayName: useNFCAsDefault
//               ? 'Champion Car Wash - Tap to Pay (UAE)'
//               : 'Champion Car Wash (UAE)',
//           customerEphemeralKeySecret: null,
//           customerId: null,
//           style: ThemeMode.system,
//
//           // NFC-first appearance for UAE market
//           appearance: PaymentSheetAppearance(
//             colors: PaymentSheetAppearanceColors(
//               primary: useNFCAsDefault ? Colors.green : const Color(0xFF635BFF),
//               background: Colors.white,
//               componentBackground: useNFCAsDefault
//                   ? Colors.green.shade50
//                   : Colors.grey.shade50,
//               componentBorder: useNFCAsDefault
//                   ? Colors.green.shade200
//                   : Colors.grey.shade300,
//               componentDivider: Colors.grey.shade200,
//               primaryText: Colors.black87,
//               secondaryText: Colors.grey.shade600,
//               componentText: Colors.black87,
//               placeholderText: Colors.grey.shade500,
//             ),
//             shapes: PaymentSheetShape(
//               borderRadius: useNFCAsDefault ? 16 : 12,
//               borderWidth: useNFCAsDefault ? 2 : 1,
//             ),
//           ),
//
//           // UAE-specific Apple Pay configuration (prioritized for NFC)
//           applePay: const PaymentSheetApplePay(
//             merchantCountryCode: 'AE', // UAE country code
//             buttonType: PlatformButtonType.pay,
//             // buttonStyle: PlatformButtonStyle.black,
//           ),
//
//           // UAE-specific Google Pay configuration (prioritized for NFC)
//           googlePay: const PaymentSheetGooglePay(
//             merchantCountryCode: 'AE', // UAE country code
//             testEnv: true, // Set to false in production
//             currencyCode: 'AED', // UAE Dirham
//             buttonType: PlatformButtonType.pay,
//
//           ),
//
//           // Minimal billing collection for faster NFC payments in UAE
//           allowsDelayedPaymentMethods: true,
//           billingDetailsCollectionConfiguration: const BillingDetailsCollectionConfiguration(
//             name: CollectionMode.never,
//             email: CollectionMode.never,
//             phone: CollectionMode.never,
//             address: AddressCollectionMode.never, // No address collection for UAE
//           ),
//
//           // Link disabled for cleaner NFC experience
//           returnURL: enableLink ? 'championcarwash://payment-return' : null,
//
//           // UAE-specific configuration
//           removeSavedPaymentMethodMessage: 'Remove payment method?',
//         ),
//       );
//
//       print('Stripe: NFC-first payment sheet initialized for UAE market');
//       print('Stripe: 🎯 Presenting NFC/Tap to Pay as default payment mode...');
//       print('Stripe: 🇦🇪 UAE location with AED currency configured');
//
//       // Step 4: Present payment sheet
//       await Stripe.instance.presentPaymentSheet();
//
//       print('Stripe: Payment completed successfully!');
//
//       // Payment successful
//       return {
//         'success': true,
//         'payment_intent_id': paymentIntentId,
//         'status': 'succeeded',
//         'amount': amount,
//         'currency': _currency ?? 'AED',
//         'invoice_name': invoiceName,
//         'service_id': serviceId,
//         'method': useNFCAsDefault ? 'STRIPE_NFC_DEFAULT_UAE' : 'STRIPE_PAYMENT_SHEET',
//         'message': 'Payment completed successfully',
//       };
//     } on StripeException catch (e) {
//       print('Stripe: Payment sheet error: ${e.error.message}');
//
//       // Handle user cancellation
//       if (e.error.code == FailureCode.Canceled) {
//         return {
//           'success': false,
//           'error': 'Payment cancelled by user',
//           'cancelled': true,
//         };
//       }
//
//       // Handle other Stripe errors
//       return {
//         'success': false,
//         'error': e.error.message ?? 'Payment failed',
//         'error_code': e.error.code.toString(),
//       };
//     } catch (e) {
//       print('Stripe: Payment sheet exception: $e');
//       return {
//         'success': false,
//         'error': 'Payment failed: $e',
//       };
//     }
//   }
//
//   /// Present NFC-focused payment sheet
//   /// Optimized for contactless/tap to pay experience
//   Future<Map<String, dynamic>> presentNFCPaymentSheet({
//     required double amount,
//     required String invoiceName,
//     required String serviceId,
//     String? customerEmail,
//   }) async {
//     print('Stripe: 🚀 Starting NFC-focused payment...');
//     print('Stripe: 📱 Optimized for Tap to Pay experience');
//     print('Stripe: 💳 Contactless cards, Apple Pay, Google Pay supported');
//     print('Stripe: 🔧 Link disabled for cleaner NFC experience');
//
//     // Check NFC availability first
//     final nfcSupported = await isNFCSupported();
//     if (nfcSupported) {
//       print('Stripe: ✅ NFC/Contactless payments available on this device');
//     } else {
//       print('Stripe: ⚠️ NFC may not be available - fallback to card entry');
//     }
//
//     // Use NFC-optimized payment processing
//     try {
//       // Step 1: Ensure Stripe is initialized
//       if (!_isInitialized) {
//         final initResult = await initialize();
//         if (!initResult['success']) {
//           return initResult;
//         }
//       }
//
//       print('Stripe: Creating NFC-optimized payment intent...');
//       print('Stripe: Amount: $amount ${_currency ?? 'AED'}');
//
//       // Step 2: Create NFC-optimized payment intent
//       final paymentIntentResult = await _createPaymentIntent(
//         amount: amount,
//         invoiceName: invoiceName,
//         serviceId: serviceId,
//         optimizeForNFC: true, // Enable NFC optimization
//       );
//
//       if (!paymentIntentResult['success']) {
//         return paymentIntentResult;
//       }
//
//       final clientSecret = paymentIntentResult['client_secret'];
//       final paymentIntentId = paymentIntentResult['payment_intent_id'];
//
//       print('Stripe: NFC-optimized payment intent created: $paymentIntentId');
//
//       // Step 3: Initialize payment sheet with NFC-first configuration
//       print('Stripe: 📱 Initializing NFC-first payment sheet...');
//
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: clientSecret,
//           merchantDisplayName: 'Champion Car Wash - Tap to Pay',
//           customerEphemeralKeySecret: null,
//           customerId: null,
//           style: ThemeMode.system,
//
//           // NFC-optimized appearance
//           appearance: PaymentSheetAppearance(
//             colors: PaymentSheetAppearanceColors(
//               primary: Colors.green, // Green for contactless theme
//               background: Colors.white,
//               componentBackground: Colors.green.shade50,
//               componentBorder: Colors.green.shade200,
//               primaryText: Colors.black87,
//               secondaryText: Colors.grey.shade600,
//             ),
//             shapes: PaymentSheetShape(
//               borderRadius: 16,
//               borderWidth: 2,
//             ),
//           ),
//
//           // Prioritize contactless payment methods
//           applePay: const PaymentSheetApplePay(
//             merchantCountryCode: 'AE',
//             buttonType: PlatformButtonType.pay,
//             // buttonStyle: PlatformButtonStyle.black,
//           ),
//
//           googlePay: const PaymentSheetGooglePay(
//             merchantCountryCode: 'AE',
//             testEnv: true,
//             currencyCode: 'AED',
//             buttonType: PlatformButtonType.pay,
//             // buttonStyle: PlatformButtonStyle.black,
//           ),
//
//           // Minimal billing collection for faster NFC experience
//           billingDetailsCollectionConfiguration: const BillingDetailsCollectionConfiguration(
//             name: CollectionMode.never,
//             email: CollectionMode.never,
//             phone: CollectionMode.never,
//             address: AddressCollectionMode.never,
//           ),
//
//           allowsDelayedPaymentMethods: true,
//           returnURL: null, // No Link for NFC-focused experience
//         ),
//       );
//
//       print('Stripe: 📱 NFC-optimized payment sheet initialized');
//       print('Stripe: 🎯 Presenting contactless-first payment options...');
//
//       // Step 4: Present NFC-optimized payment sheet
//       await Stripe.instance.presentPaymentSheet();
//
//       print('Stripe: ✅ NFC payment completed successfully!');
//
//       return {
//         'success': true,
//         'payment_intent_id': paymentIntentId,
//         'status': 'succeeded',
//         'amount': amount,
//         'currency': _currency ?? 'AED',
//         'invoice_name': invoiceName,
//         'service_id': serviceId,
//         'method': 'STRIPE_NFC_OPTIMIZED',
//         'message': 'NFC payment completed successfully',
//       };
//     } on StripeException catch (e) {
//       print('Stripe: NFC payment error: ${e.error.message}');
//
//       if (e.error.code == FailureCode.Canceled) {
//         return {
//           'success': false,
//           'error': 'NFC payment cancelled by user',
//           'cancelled': true,
//         };
//       }
//
//       return {
//         'success': false,
//         'error': e.error.message ?? 'NFC payment failed',
//         'error_code': e.error.code.toString(),
//       };
//     } catch (e) {
//       print('Stripe: NFC payment exception: $e');
//       return {
//         'success': false,
//         'error': 'NFC payment failed: $e',
//       };
//     }
//   }
//
//   /// Check available payment methods and NFC support
//   Future<Map<String, dynamic>> checkAvailablePaymentMethods() async {
//     try {
//       if (!_isInitialized) {
//         await initialize();
//       }
//
//       print('Stripe: 🔍 Checking available payment methods...');
//
//       // Check Apple Pay availability
//       bool applePaySupported = false;
//       try {
//         applePaySupported = await Stripe.instance.isPlatformPaySupported();
//         print('Stripe: 🍎 Apple Pay supported: $applePaySupported');
//       } catch (e) {
//         print('Stripe: 🍎 Apple Pay check failed: $e');
//       }
//
//       // Check Google Pay availability
//       bool googlePaySupported = false;
//       try {
//         googlePaySupported = await Stripe.instance.isPlatformPaySupported();
//         print('Stripe: 🤖 Google Pay supported: $googlePaySupported');
//       } catch (e) {
//         print('Stripe: 🤖 Google Pay check failed: $e');
//       }
//
//       // NFC support is implicit through Apple Pay/Google Pay and contactless cards
//       final nfcSupported = applePaySupported || googlePaySupported;
//       print('Stripe: 📱 NFC/Contactless supported: $nfcSupported');
//       print('Stripe: 💳 Card payments: Always available');
//
//       return {
//         'apple_pay': applePaySupported,
//         'google_pay': googlePaySupported,
//         'nfc_contactless': nfcSupported,
//         'card_payments': true,
//         'recommended_method': nfcSupported ? 'contactless' : 'card',
//       };
//     } catch (e) {
//       print('Stripe: ❌ Error checking payment methods: $e');
//       return {
//         'apple_pay': false,
//         'google_pay': false,
//         'nfc_contactless': false,
//         'card_payments': true,
//         'recommended_method': 'card',
//         'error': e.toString(),
//       };
//     }
//   }
//
//   /// Check if device supports NFC payments
//   Future<bool> isNFCSupported() async {
//     try {
//       final methods = await checkAvailablePaymentMethods();
//       return methods['nfc_contactless'] ?? false;
//     } catch (e) {
//       print('Stripe: Error checking NFC support: $e');
//       return false;
//     }
//   }
//
//   /// Get Stripe configuration status
//   Map<String, dynamic> getStatus() {
//     return {
//       'initialized': _isInitialized,
//       'publishable_key': _publishableKey != null ? _publishableKey!.substring(0, 20) + '...' : 'Not set',
//       'currency': _currency ?? 'Not set',
//       'merchant_identifier': 'merchant.com.championcarwash.ae',
//       'tap_to_pay_supported': true,
//       'apple_pay_supported': true,
//       'google_pay_supported': true,
//       'mode': 'BACKEND_INTEGRATED',
//       'backend_url': ApiConstants.baseUrl,
//     };
//   }
//
//   /// Generate or fetch proper invoice name from ERPNext system
//   /// This should be replaced with actual API call to your ERPNext system
//   Future<String> getInvoiceName(String serviceId) async {
//     try {
//       // TODO: Replace with actual API call to ERPNext to get/create invoice
//       // For now, return a placeholder format that matches ERPNext naming
//       final year = DateTime.now().year;
//       final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(8);
//       return 'ACC-SINV-$year-$timestamp';
//     } catch (e) {
//       print('Stripe: Error getting invoice name: $e');
//       // Fallback to service ID format
//       return 'ACC-SINV-$serviceId';
//     }
//   }
//
//   /// Reset Stripe service (for testing)
//   void reset() {
//     _isInitialized = false;
//     _publishableKey = null;
//     _currency = null;
//     print('Stripe: Service reset');
//   }
// }
