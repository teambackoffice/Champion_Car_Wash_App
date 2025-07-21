import 'package:champion_car_wash_app/view/login/login.dart';
import 'package:champion_car_wash_app/view/oil_tech/completed/completed.dart';
import 'package:champion_car_wash_app/view/oil_tech/new/new.dart';
import 'package:champion_car_wash_app/view/oil_tech/underprocess/underprocess.dart';
import 'package:flutter/material.dart';

class OilTechnicianHomePage extends StatelessWidget {
  const OilTechnicianHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Oil Technician",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _showLogoutDialog(context),
              tooltip: "Logout",
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "New"),
              Tab(text: "Under Process"),
              Tab(text: "Completed"),
            ],
          ),
          backgroundColor: Colors.red[900],
        ),
        body: TabBarView(
          children: [
            NewBookingsTab(),
            UnderProcessingTab(),
            CompletedBookingsTab(),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[900],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // TODO: Add any logout logic here (e.g., clearing tokens)

    // Navigate to login screen and clear navigation stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
