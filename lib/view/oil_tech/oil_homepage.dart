import 'dart:math' as math;

import 'package:champion_car_wash_app/view/login/login.dart';
import 'package:flutter/material.dart';

class OilTechnicianHomePage extends StatelessWidget {
  const OilTechnicianHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Oil Technician Dashboard"),
          centerTitle: true,
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () => _showLogoutDialog(context),
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
        body: const TabBarView(
          children: [
            OilNewBookings(),
            OilUnderProcessing(),
            OilCompletedBookings(),
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
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}

// NEW BOOKINGS TAB
class OilNewBookings extends StatefulWidget {
  const OilNewBookings({super.key});

  @override
  State<OilNewBookings> createState() => _OilNewBookingsState();
}

class _OilNewBookingsState extends State<OilNewBookings>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _slideController;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bookings = [
      {
        'customer': 'John Doe',
        'carModel': 'Toyota Corolla',
        'make': '2020',
        'date': '2025-07-12',
        'bookingId': 'BK-001',
        'status': 'confirmed',
        'time': '10:00 AM',
        'serviceType': 'Oil Change',
        'phone': '+1 234 567 8900',
        'priority': 'standard',
        'progress': 0.0,
        'color': const Color(0xFF6C5CE7),
        'avatar': '👨‍💼',
        'estimated': '45 min',
      },
      {
        'customer': 'Sarah Smith',
        'carModel': 'Honda Civic',
        'make': '2019',
        'date': '2025-07-13',
        'bookingId': 'BK-002',
        'status': 'pending',
        'time': '2:30 PM',
        'serviceType': 'Full Service',
        'phone': '+1 234 567 8901',
        'priority': 'urgent',
        'progress': 0.0,
        'color': const Color(0xFFFF6B6B),
        'avatar': '👩‍💼',
        'estimated': '90 min',
      },
      {
        'customer': 'Ali Khan',
        'carModel': 'Ford F-150',
        'make': '2022',
        'date': '2025-07-14',
        'bookingId': 'BK-003',
        'status': 'confirmed',
        'time': '9:15 AM',
        'serviceType': 'Oil Change',
        'phone': '+1 234 567 8902',
        'priority': 'standard',
        'progress': 0.0,
        'color': const Color(0xFF4ECDC4),
        'avatar': '🧔',
        'estimated': '60 min',
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildNewHeader(),
                  const SizedBox(height: 32),
                  _buildNewStatsRow(bookings),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        index * 0.1,
                        math.min(1.0, (index + 1) * 0.1 + 0.3),
                        curve: Curves.elasticOut,
                      ),
                    ),
                  );

                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - animation.value)),
                    child: Opacity(
                      opacity: animation.value,
                      child: _buildNewBookingCard(
                        bookings[index],
                        index,
                        context,
                      ),
                    ),
                  );
                },
              );
            }, childCount: bookings.length),
          ),
        ],
      ),
    );
  }

  Widget _buildNewHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.new_releases, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Bookings",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Ready to Start",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewStatsRow(List<Map<String, dynamic>> bookings) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Total",
            bookings.length.toString(),
            Icons.event_note,
            const Color(0xFF4ECDC4),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "Confirmed",
            bookings.where((b) => b['status'] == 'confirmed').length.toString(),
            Icons.check_circle,
            const Color(0xFF45B7D1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "Pending",
            bookings.where((b) => b['status'] == 'pending').length.toString(),
            Icons.schedule,
            const Color(0xFFFF6B6B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewBookingCard(
    Map<String, dynamic> booking,
    int index,
    BuildContext context,
  ) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = isSelected ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.fromLTRB(24, 8, 24, isSelected ? 24 : 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white.withOpacity(0.9)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: booking['color'].withOpacity(0.3),
                blurRadius: isSelected ? 25 : 15,
                offset: Offset(0, isSelected ? 15 : 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                booking['color'],
                                booking['color'].withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: booking['color'].withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              booking['avatar'],
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking['customer'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booking['bookingId'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _startService(booking),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: booking['color'],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Start"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildCarServiceInfo(booking),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: _buildNewExpandedContent(booking),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarServiceInfo(Map<String, dynamic> booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: booking['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.directions_car,
              color: booking['color'],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${booking['carModel']} (${booking['make']})",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking['serviceType'],
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            booking['estimated'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: booking['color'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewExpandedContent(Map<String, dynamic> booking) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoChip(
                Icons.access_time,
                "Time",
                booking['time'],
                const Color(0xFF4ECDC4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoChip(
                Icons.calendar_today,
                "Date",
                _formatDate(booking['date']),
                const Color(0xFF6C5CE7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoChip(
          Icons.phone,
          "Phone",
          booking['phone'],
          const Color(0xFF45B7D1),
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String label,
    String value,
    Color color, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      final List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return "${dateTime.day} ${months[dateTime.month - 1]}";
    } catch (e) {
      return date;
    }
  }

  void _startService(Map<String, dynamic> booking) {
    print("Starting service for: ${booking['customer']}");
  }
}

// UNDER PROCESSING TAB
class OilUnderProcessing extends StatefulWidget {
  const OilUnderProcessing({super.key});

  @override
  State<OilUnderProcessing> createState() => _OilUnderProcessingState();
}

class _OilUnderProcessingState extends State<OilUnderProcessing>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activeServices = [
      {
        'customer': 'Michael Chen',
        'carModel': 'BMW X5',
        'make': '2021',
        'bookingId': 'BK-104',
        'serviceType': 'Full Service',
        'progress': 0.65,
        'startTime': '2:30 PM',
        'estimatedCompletion': '4:00 PM',
        'currentStep': 'Oil Filter Replacement',
        'technician': 'Alex',
        'color': const Color(0xFF9B59B6),
        'avatar': '👨‍🔧',
        'steps': [
          {'name': 'Inspection', 'completed': true},
          {'name': 'Drain Old Oil', 'completed': true},
          {'name': 'Oil Filter Replacement', 'completed': false},
          {'name': 'Add New Oil', 'completed': false},
          {'name': 'Final Check', 'completed': false},
        ],
      },
      {
        'customer': 'Emma Wilson',
        'carModel': 'Audi A4',
        'make': '2020',
        'bookingId': 'BK-105',
        'serviceType': 'Oil Change',
        'progress': 0.3,
        'startTime': '1:00 PM',
        'estimatedCompletion': '2:45 PM',
        'currentStep': 'Drain Old Oil',
        'technician': 'Sam',
        'color': const Color(0xFFE74C3C),
        'avatar': '👩‍💼',
        'steps': [
          {'name': 'Inspection', 'completed': true},
          {'name': 'Drain Old Oil', 'completed': false},
          {'name': 'Add New Oil', 'completed': false},
          {'name': 'Final Check', 'completed': false},
        ],
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C3E50), Color(0xFF3498DB), Color(0xFF2980B9)],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProcessingHeader(),
                  const SizedBox(height: 32),
                  _buildProcessingStats(activeServices),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildProcessingCard(activeServices[index]),
              childCount: activeServices.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingHeader() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(
                      0xFFE67E22,
                    ).withOpacity(0.8 + 0.2 * _pulseController.value),
                    const Color(
                      0xFFD35400,
                    ).withOpacity(0.8 + 0.2 * _pulseController.value),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE67E22).withOpacity(0.4),
                    blurRadius: 20 + 10 * _pulseController.value,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.build, color: Colors.white, size: 32),
            );
          },
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Active Services",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Currently Processing",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingStats(List<Map<String, dynamic>> services) {
    double avgProgress = services.isEmpty
        ? 0
        : services.map((s) => s['progress'] as double).reduce((a, b) => a + b) /
              services.length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Icon(
                  Icons.engineering,
                  color: Color(0xFFE67E22),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  services.length.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Active",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 60, color: Colors.white.withOpacity(0.3)),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.timeline, color: Color(0xFF3498DB), size: 32),
                const SizedBox(height: 8),
                Text(
                  "${(avgProgress * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Avg Progress",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: service['color'].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  service['color'].withOpacity(0.1),
                  service['color'].withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        service['color'],
                        service['color'].withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      service['avatar'],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['customer'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        service['bookingId'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${(service['progress'] * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: service['color'],
                      ),
                    ),
                    Text(
                      "Complete",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Progress Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: service['progress'],
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      service['color'],
                      service['color'].withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          // Current Step
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.settings, color: service['color'], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        service['currentStep'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: service['color'],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Service Steps
                ...service['steps'].map<Widget>((step) {
                  final isCompleted = step['completed'] as bool;
                  final isCurrent = step['name'] == service['currentStep'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? service['color'].withOpacity(0.1)
                          : isCurrent
                          ? service['color'].withOpacity(0.05)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCompleted || isCurrent
                            ? service['color'].withOpacity(0.3)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCompleted
                              ? Icons.check_circle
                              : isCurrent
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isCompleted
                              ? service['color']
                              : isCurrent
                              ? service['color']
                              : Colors.grey.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          step['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isCompleted || isCurrent
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isCompleted || isCurrent
                                ? Colors.black87
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pauseService(service),
                        icon: const Icon(Icons.pause, size: 18),
                        label: const Text("Pause"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange.shade600,
                          side: BorderSide(color: Colors.orange.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateProgress(service),
                        icon: const Icon(Icons.update, size: 18),
                        label: const Text("Update"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: service['color'],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pauseService(Map<String, dynamic> service) {
    print("Pausing service for: ${service['customer']}");
  }

  void _updateProgress(Map<String, dynamic> service) {
    print("Updating progress for: ${service['customer']}");
  }
}

// COMPLETED BOOKINGS TAB
class OilCompletedBookings extends StatefulWidget {
  const OilCompletedBookings({super.key});

  @override
  State<OilCompletedBookings> createState() => _OilCompletedBookingsState();
}

class _OilCompletedBookingsState extends State<OilCompletedBookings>
    with TickerProviderStateMixin {
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> completedServices = [
      {
        'customer': 'Robert Johnson',
        'carModel': 'Mercedes C-Class',
        'make': '2022',
        'bookingId': 'BK-098',
        'serviceType': 'Full Service',
        'completedTime': '11:30 AM',
        'duration': '75 min',
        'technician': 'Mike',
        'rating': 5.0,
        'feedback': 'Excellent service, very professional!',
        'color': const Color(0xFF27AE60),
        'avatar': '👨‍💼',
        'date': '2025-07-11',
      },
      {
        'customer': 'Lisa Anderson',
        'carModel': 'Tesla Model 3',
        'make': '2023',
        'bookingId': 'BK-097',
        'serviceType': 'Oil Change',
        'completedTime': '10:15 AM',
        'duration': '45 min',
        'technician': 'Tom',
        'rating': 4.8,
        'feedback': 'Quick and efficient service.',
        'color': const Color(0xFF8E44AD),
        'avatar': '👩‍💼',
        'date': '2025-07-11',
      },
      {
        'customer': 'David Kim',
        'carModel': 'Hyundai Elantra',
        'make': '2021',
        'bookingId': 'BK-096',
        'serviceType': 'Oil Change',
        'completedTime': '9:45 AM',
        'duration': '40 min',
        'technician': 'Alex',
        'rating': 4.9,
        'feedback': 'Great attention to detail.',
        'color': const Color(0xFF3498DB),
        'avatar': '👨‍💼',
        'date': '2025-07-10',
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF1ABC9C), Color(0xFF16A085), Color(0xFF27AE60)],
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildCompletedHeader(),
                  const SizedBox(height: 32),
                  _buildCompletedStats(completedServices),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildCompletedCard(completedServices[index]),
              childCount: completedServices.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedHeader() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _sparkleController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _sparkleController.value * 2 * math.pi,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFD700).withOpacity(0.9),
                      const Color(0xFFFFA500).withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Completed",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "Successfully Finished",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedStats(List<Map<String, dynamic>> services) {
    double avgRating = services.isEmpty
        ? 0
        : services.map((s) => s['rating'] as double).reduce((a, b) => a + b) /
              services.length;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Icon(Icons.done_all, color: Color(0xFFFFD700), size: 28),
                const SizedBox(height: 8),
                Text(
                  services.length.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Completed",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFD700), size: 28),
                const SizedBox(height: 8),
                Text(
                  avgRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Avg Rating",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: service['color'].withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Success Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF27AE60).withOpacity(0.1),
                  const Color(0xFF2ECC71).withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF27AE60).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF27AE60),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Service Completed Successfully",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF27AE60),
                  ),
                ),
                const Spacer(),
                Text(
                  service['completedTime'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Customer Info
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            service['color'],
                            service['color'].withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          service['avatar'],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['customer'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "${service['carModel']} (${service['make']})",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFD700),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            service['rating'].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF8C00),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Service Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildDetailItem(
                            Icons.build,
                            "Service",
                            service['serviceType'],
                            service['color'],
                          ),
                          const SizedBox(width: 20),
                          _buildDetailItem(
                            Icons.timer,
                            "Duration",
                            service['duration'],
                            const Color(0xFF3498DB),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildDetailItem(
                            Icons.person,
                            "Technician",
                            service['technician'],
                            const Color(0xFF9B59B6),
                          ),
                          const SizedBox(width: 20),
                          _buildDetailItem(
                            Icons.confirmation_number,
                            "ID",
                            service['bookingId'],
                            const Color(0xFFE74C3C),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Customer Feedback
                if (service['feedback'] != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3498DB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF3498DB).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.format_quote,
                              color: const Color(0xFF3498DB),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Customer Feedback",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3498DB),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          service['feedback'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
