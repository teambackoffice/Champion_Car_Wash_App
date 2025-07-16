import 'package:champion_car_wash_app/view/carwash_tech/completed_wash/completed_wash.dart';
import 'package:champion_car_wash_app/view/carwash_tech/new_wash/new_wash.dart';
import 'package:champion_car_wash_app/view/carwash_tech/underprocess_wash/underprocess_wash.dart';
import 'package:champion_car_wash_app/view/login/login.dart';
import 'package:flutter/material.dart';

class CarWashTechnicianHomePage extends StatelessWidget {
  const CarWashTechnicianHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Car Wash Technician",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[800],
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
        ),
        body: TabBarView(
          children: [
            CarWashNewBookings(),
            CarWashUnderProcessing(),
            CarWashCompletedBookings(),
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
