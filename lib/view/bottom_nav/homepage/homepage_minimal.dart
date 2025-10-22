import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Minimal homepage for emergency performance fix
/// Use this if the main homepage is causing ProfileInstaller issues
class HomePageMinimal extends StatelessWidget {
  const HomePageMinimal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Simple header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.local_car_wash,
                      size: 60,
                      color: Color(0xFFD32F2F),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Champion Car Wash',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Performance Mode Active',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Simple action buttons
              _buildActionButton(
                context: context,
                title: 'Create Service',
                icon: Icons.add,
                color: const Color(0xFFD32F2F),
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: Navigate to create service
                },
              ),

              const SizedBox(height: 16),

              _buildActionButton(
                context: context,
                title: 'View Bookings',
                icon: Icons.list,
                color: const Color(0xFF1565C0),
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: Navigate to bookings
                },
              ),

              const SizedBox(height: 16),

              _buildActionButton(
                context: context,
                title: 'Profile',
                icon: Icons.person,
                color: const Color(0xFF00796B),
                onTap: () {
                  HapticFeedback.lightImpact();
                  // TODO: Navigate to profile
                },
              ),

              const SizedBox(height: 40),

              // Performance info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.speed, color: Colors.orange, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Minimal UI loaded for better performance',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
