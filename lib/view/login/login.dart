import 'dart:convert';

import 'package:champion_car_wash_app/controller/login_controller.dart';
import 'package:champion_car_wash_app/view/bottom_nav/bottom_nav.dart';
import 'package:champion_car_wash_app/view/carwash_tech/carwas_homepage.dart';
import 'package:champion_car_wash_app/view/oil_tech/oil_homepage.dart';

// ACTIVE STRIPE PAYMENT TEST
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _imagesPrecached = false;

  // PERFORMANCE FIX: Precache login logo for smoother initial render
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      precacheImage(const AssetImage('assets/login_logo.png'), context);
      _imagesPrecached = true;
    }
  }

  // Update your _handleLogin method in the LoginScreen
  void _handleLogin() async {
    final loginController = Provider.of<LoginController>(
      context,
      listen: false,
    );

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool isLoggedIn = await loginController.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      // PERFORMANCE FIX: Check if widget is still mounted before setState
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (isLoggedIn) {
        // Get roles from secure storage
        const secureStorage = FlutterSecureStorage();
        final rolesString = await secureStorage.read(key: 'roles');
        List<String> roles = [];

        if (rolesString != null) {
          roles = List<String>.from(jsonDecode(rolesString));
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate based on role
        if (!mounted) return;
        if (roles.contains('Carwash Technician')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const CarWashTechnicianHomePage(),
            ), // replace with your Carwash page
          );
        } else if (roles.contains('Oil Technician')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const OilTechnicianHomePage(),
            ), // replace with your Oil Tech page
          );
        } else if (roles.contains('supervisors')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BottomNavigation()),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No valid role assigned to user.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loginController.errorMessage ?? 'Login failed!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(bottom: keyboardHeight),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    keyboardHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Flexible spacing that collapses when keyboard appears
                    if (!isKeyboardVisible) ...[
                      SizedBox(height: size.height * 0.08),
                    ] else ...[
                      const SizedBox(height: 20),
                    ],

                    // Logo - smaller when keyboard is visible
                    Image.asset(
                      'assets/login_logo.png',
                      height: isKeyboardVisible ? 60 : 100,
                    ),

                    SizedBox(height: isKeyboardVisible ? 20 : 40),

                    // Welcome Text
                    const Text(
                      'Please login to continue!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Login ID Field
                    TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Login Id',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade400),
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFD01C32),
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your login ID';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleLogin(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400),
                        filled: true,
                        fillColor: const Color(0xFF2A2A2A),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFD01C32),
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD01C32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    // Test Pages Access Button (Development Only)
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        _showTestPagesMenu(context);
                      },
                      child: const Text(
                        '🧪 Test Pages (Dev)',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Bottom spacing - collapses when keyboard appears
                    if (!isKeyboardVisible) ...[
                      SizedBox(height: size.height * 0.12),
                    ] else ...[
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTestPagesMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              '🧪 Test Pages',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // PRIMARY TEST - Stripe Payment (RECOMMENDED!)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const StripePaymentTest(),
                //   ),
                // );
              },
              icon: const Icon(Icons.payment),
              label: const Text('💎 STRIPE PAYMENT (BEST - NFC READY)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Note about archived tests
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '📝 Note: All Tap Payments tests have been archived.\nNow using Stripe for payment processing.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
