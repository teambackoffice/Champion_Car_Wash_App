import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              const ReadOnlyField(
                icon: Icons.person_outline,
                text: 'Muhammed Ali',
              ),
              const SizedBox(height: 12),

              // Phone Field
              const ReadOnlyField(
                icon: Icons.phone_outlined,
                text: '+971 8271674928',
              ),
              const SizedBox(height: 12),

              // Address Field
              const ReadOnlyField(
                icon: Icons.location_on_outlined,
                text: 'Al Hamidiya 1, Ajman',
              ),
              const SizedBox(height: 12),

              // Logout Button
             GestureDetector(
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(


            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Add actual logout logic here
              // e.g., navigate to login screen or clear user session
            },
            child: const Text('Log Out',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  },
  child: const ReadOnlyField(
    icon: Icons.logout,
    text: 'Log Out',
    isButton: true,
  ),
)

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
