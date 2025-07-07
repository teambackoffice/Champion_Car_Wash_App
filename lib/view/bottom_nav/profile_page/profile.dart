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
    // TODO: implement initState
    super.initState();
    _loadFullname();
    loadbranch();
  }

  Future<void> _loadFullname() async {
    final storedName = await storage.read(key: "full_name");
    setState(() {
      fullname = storedName ?? '';
    });
  }

  Future<void> loadbranch() async {
    final storedBranch = await storage.read(key: "branch");
    setState(() {
      branch = storedBranch ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text('Confirm Logout'),
                                content: const Text(
                                  'Are you sure you want to log out?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
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
                                            Navigator.of(
                                              context,
                                            ).pop(); // Close dialog

                                            // Show loading indicator
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );

                                            // Perform logout
                                            await loginController.logout();

                                            // Close loading dialog
                                            Navigator.of(context).pop();

                                            // Navigate to login screen
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                              (Route<dynamic> route) => false,
                                            );
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
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: isButton ? const Color(0xFFF9F9F9) : Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isButton ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
