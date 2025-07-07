import 'package:champion_car_wash_app/view/bottom_nav/booking_page/all_bookings.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/homepage.dart';
import 'package:champion_car_wash_app/view/bottom_nav/profile_page/profile.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomePageContent(), // Your existing home page content
          AllBookingsPage(),
          ProfileScreen(),
        ],
      ),
      // Custom Bottom Navigation Bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 78,
        width: 275,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // color: _selectedIndex == 0 ? const Color(0xFFD32F2F).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/home icon.png", color: Colors.red),
                    const SizedBox(height: 2),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: _selectedIndex == 0
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _selectedIndex == 0
                            ? const Color(0xFFD32F2F)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // color: _selectedIndex == 1 ? const Color(0xFFD32F2F).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/booking.png", color: Colors.red),
                    const SizedBox(height: 2),
                    Text(
                      'All Bookings',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: _selectedIndex == 1
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _selectedIndex == 1
                            ? const Color(0xFFD32F2F)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // color: _selectedIndex == 2 ? const Color(0xFFD32F2F).withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/profile.png", color: Colors.red),
                    const SizedBox(height: 2),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: _selectedIndex == 2
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: _selectedIndex == 2
                            ? const Color(0xFFD32F2F)
                            : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
