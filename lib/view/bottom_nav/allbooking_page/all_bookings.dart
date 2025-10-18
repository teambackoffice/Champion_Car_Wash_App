import 'dart:async';
import 'package:champion_car_wash_app/controller/get_allbooking_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllBookingsPage extends StatefulWidget {
  const AllBookingsPage({super.key});

  @override
  _AllBookingsPageState createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  String _searchQuery = '';
  
  // OPTIMIZATION: Debouncing and caching for search
  Timer? _debounceTimer;
  final Map<String, List<dynamic>> _searchCache = {};
  List<dynamic>? _cachedFilteredResults;
  String _lastSearchQuery = '';
  DateTime? _lastSelectedDate;

  @override
  void initState() {
    super.initState();
    // Fetch bookings once widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetAllbookingController>(
        context,
        listen: false,
      ).fetchBookingList();
    });

    // OPTIMIZATION: Listen to search controller changes with debouncing
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: Properly dispose all resources
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchCache.clear();
    super.dispose();
  }

  // OPTIMIZATION: Debounced search with 300ms delay
  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final newQuery = _searchController.text.toLowerCase();
      if (newQuery != _searchQuery) {
        setState(() {
          _searchQuery = newQuery;
          _cachedFilteredResults = null; // Clear cache when search changes
        });
      }
    });
  }

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Clear date filter
  void _clearDateFilter() {
    setState(() {
      _selectedDate = null;
    });
  }

  // OPTIMIZATION: Cached filtering with performance improvements
  List<dynamic> _filterBookings(List<dynamic> bookings) {
    // Check if we can use cached results
    final currentQuery = _searchQuery;
    final currentDate = _selectedDate;
    
    if (_cachedFilteredResults != null && 
        _lastSearchQuery == currentQuery && 
        _lastSelectedDate == currentDate) {
      return _cachedFilteredResults!;
    }
    
    // Create cache key for this filter combination
    final cacheKey = '${currentQuery}_${currentDate?.toIso8601String() ?? 'null'}';
    
    // Check if we have this combination cached
    if (_searchCache.containsKey(cacheKey)) {
      _cachedFilteredResults = _searchCache[cacheKey]!;
      _lastSearchQuery = currentQuery;
      _lastSelectedDate = currentDate;
      return _cachedFilteredResults!;
    }
    
    // Perform filtering
    final filtered = bookings.where((booking) {
      // Search filter - check registration number
      bool matchesSearch =
          currentQuery.isEmpty ||
          booking.registrationNumber.toLowerCase().contains(currentQuery);

      // Date filter - check purchase date
      bool matchesDate = true;
      if (currentDate != null) {
        try {
          // Parse the purchase date from API (adjust format as needed)
          DateTime bookingDate = DateTime.parse(booking.purchaseDate);
          matchesDate =
              DateFormat('yyyy-MM-dd').format(bookingDate) ==
              DateFormat('yyyy-MM-dd').format(currentDate);
        } catch (e) {
          // If date parsing fails, include the booking
          matchesDate = true;
        }
      }

      return matchesSearch && matchesDate;
    }).toList();
    
    // Cache the results (limit cache size to prevent memory issues)
    if (_searchCache.length > 20) {
      _searchCache.clear(); // Clear cache if it gets too large
    }
    _searchCache[cacheKey] = filtered;
    _cachedFilteredResults = filtered;
    _lastSearchQuery = currentQuery;
    _lastSelectedDate = currentDate;
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Pure black-grey background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFF2A2A2A), // Dark grey-black
          elevation: 0,
          title: const Text(
            'All Bookings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Container(
            color: const Color(0xFF2A2A2A), // Dark grey-black
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by Vehicle Number',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[300]),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[300]),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF555555)),
                ),
                filled: true,
                fillColor: const Color(0xFF3D3D3D), // Lighter grey-black
              ),
            ),
          ),

          // 📅 Filter Row
          Container(
            color: const Color(0xFF2A2A2A), // Dark grey-black
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: _selectedDate != null
                            ? LinearGradient(
                                colors: [Colors.red[400]!, Colors.red[600]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: _selectedDate != null ? null : const Color(0xFF3D3D3D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedDate != null
                              ? Colors.red[300]!
                              : const Color(0xFF555555),
                          width: _selectedDate != null ? 2 : 1,
                        ),
                        boxShadow: _selectedDate != null
                            ? [
                                BoxShadow(
                                  color: Colors.red.withAlpha(51),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                            color: _selectedDate != null
                                ? Colors.white
                                : Colors.grey[300],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedDate != null
                                  ? DateFormat(
                                      'd MMMM yyyy',
                                    ).format(_selectedDate!)
                                  : 'Select Date to Filter',
                              style: TextStyle(
                                color: _selectedDate != null
                                    ? Colors.white
                                    : Colors.grey[300],
                                fontWeight: _selectedDate != null
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (_selectedDate != null)
                            GestureDetector(
                              onTap: _clearDateFilter,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(51),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // PERFORMANCE FIX: Use Selector instead of Consumer to reduce rebuilds
                // Only rebuilds when filtered count changes, not on every controller update
                Selector<GetAllbookingController, int>(
                  selector: (_, controller) =>
                      _filterBookings(controller.bookingData).length,
                  builder: (context, count, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.list_alt,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$count',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 📋 Booking List
          Expanded(
            child: Consumer<GetAllbookingController>(
              builder: (context, controller, _) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${controller.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.fetchBookingList(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final filteredBookings = _filterBookings(
                  controller.bookingData,
                );

                if (filteredBookings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.bookingData.isEmpty
                              ? 'No bookings found.'
                              : 'No bookings match your search criteria.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty ||
                            _selectedDate != null) ...[
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _searchController.clear();
                              _clearDateFilter();
                            },
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                // PERFORMANCE FIX: Use extracted BookingCard widget for better performance
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBookings.length,
                  itemBuilder: (context, index) {
                    return _BookingCard(booking: filteredBookings[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// PERFORMANCE FIX: Extracted BookingCard to reduce rebuild surface area
class _BookingCard extends StatelessWidget {
  final dynamic booking;

  const _BookingCard({required this.booking});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'open':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatBookingDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('d MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🚗 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.registrationNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 🧾 Booking Details
            _buildDetailRow('Customer Name', booking.customerName),
            _buildDetailRow('Phone', booking.phone),
            _buildDetailRow(
              'Booking Date',
              _formatBookingDate(booking.purchaseDate),
            ),
            _buildDetailRow('Address', booking.address),

            const SizedBox(height: 8),

            // 🛠️ Services
            const Text(
              'Selected Services',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: booking.services.map<Widget>((service) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '${service.serviceType}'
                    '${service.washType != null ? ' - ${service.washType}' : ''}'
                    '${service.oilBrand != null ? ' (${service.oilBrand})' : ''}',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
