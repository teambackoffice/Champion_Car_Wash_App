import 'package:champion_car_wash_app/controller/login_controller.dart';
import 'package:champion_car_wash_app/view/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullname = '';
  final storage = const FlutterSecureStorage();
  String branch = '';

  @override
  void initState() {
    super.initState();
    // PERFORMANCE FIX: Load profile data in parallel instead of sequentially
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    // PERFORMANCE FIX: Use Future.wait to load both values in parallel
    final results = await Future.wait([
      storage.read(key: 'full_name'),
      storage.read(key: 'branch'),
    ]);

    if (mounted) {
      setState(() {
        fullname = results[0] ?? '';
        branch = results[1] ?? '';
      });
    }
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: No controllers to dispose, but good practice
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Pure black-grey background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              // Profile Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/person.jpeg', // Placeholder image
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Name Field
              ReadOnlyField(
                icon: Icons.person_outline,
                text: fullname.isNotEmpty
                    ? fullname[0].toUpperCase() + fullname.substring(1)
                    : '',
              ),
              const SizedBox(height: 12),

              // Phone Field
              // const ReadOnlyField(
              //   icon: Icons.phone_outlined,
              //   text: '+971 8271674928',
              // ),
              // const SizedBox(height: 12),

              // Address Field
              ReadOnlyField(icon: Icons.location_on_outlined, text: branch),
              const SizedBox(height: 12),

              // Logout Button
              Consumer<LoginController>(
                builder: (context, loginController, child) {
                  return GestureDetector(
                    onTap: loginController.isLoading
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xFF2A2A2A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  'Confirm Logout',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  'Are you sure you want to log out?',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: loginController.isLoading
                                        ? null
                                        : () async {
                                            // Close dialog first
                                            Navigator.of(context).pop();

                                            // Show loading indicator
                                            if (mounted) {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => const Center(
                                                  child: CircularProgressIndicator(),
                                                ),
                                              );
                                            }

                                            try {
                                              // Perform logout
                                              await loginController.logout();

                                              // Check if widget is still mounted before navigation
                                              if (mounted) {
                                                // Close loading dialog
                                                Navigator.of(context).pop();

                                                // Navigate to login screen
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const LoginScreen(),
                                                  ),
                                                  (Route<dynamic> route) => false,
                                                );
                                              }
                                            } catch (e) {
                                              // Handle logout error
                                              if (mounted) {
                                                // Close loading dialog if still open
                                                Navigator.of(context).pop();
                                                
                                                // Show error message
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Logout failed: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                    child: loginController.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'Log Out',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            );
                          },
                    child: ReadOnlyField(
                      icon: Icons.logout,
                      text: loginController.isLoading
                          ? 'Logging out...'
                          : 'Log Out',
                      isButton: true,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReadOnlyField extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isButton;

  const ReadOnlyField({
    super.key,
    required this.icon,
    required this.text,
    this.isButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF555555)),
        borderRadius: BorderRadius.circular(8),
        color: isButton ? const Color(0xFF2A2A2A) : const Color(0xFF3D3D3D),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade300),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isButton ? const Color(0xFFD32F2F) : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
