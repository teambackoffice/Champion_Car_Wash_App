import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/payment_due/create_invoice.dart';
import 'package:flutter/material.dart';

class UnderProcessScreen extends StatefulWidget {
  const UnderProcessScreen({super.key});

  @override
  _UnderProcessScreenState createState() => _UnderProcessScreenState();
}

class _UnderProcessScreenState extends State<UnderProcessScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Status options for dropdowns
  final List<String> _statusOptions = ['Select Status', 'Started', 'Complete'];

  // Selected status for each service
  String _oilChangeStatus1 = 'Select Status';
  String _carWashStatus1 = 'Select Status';
  String _oilChangeStatus2 = 'Started';
  String _carWashStatus2 = 'Select Status';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 16,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'Under Processing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(),
              SizedBox(height: 20),
              _buildBookingCard(
                registrationNumber: 'RO-2025-06-0039',
                bookingDate: 'Jun 25 2025',
                bookingTime: '12:00pm',
                regNumber: 'R-2025-AJ-0039',
                status: 'Under Processing',
                statusColor: Colors.red,
                oilChangeStatus: _oilChangeStatus1,
                carWashStatus: _carWashStatus1,
                onOilChangeChanged: (value) {
                  setState(() {
                    _oilChangeStatus1 = value!;
                  });
                },
                onCarWashChanged: (value) {
                  setState(() {
                    _carWashStatus1 = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              _buildBookingCard(
                registrationNumber: 'RO-2025-06-0039',
                bookingDate: 'Jun 25 2025',
                bookingTime: '12:00pm',
                regNumber: 'R-2025-AJ-0039',
                status: 'Processing',
                statusColor: Colors.orange,
                oilChangeStatus: _oilChangeStatus2,
                carWashStatus: _carWashStatus2,
                onOilChangeChanged: (value) {
                  setState(() {
                    _oilChangeStatus2 = value!;
                  });
                },
                onCarWashChanged: (value) {
                  setState(() {
                    _carWashStatus2 = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Customer by Vehicle Number',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required String registrationNumber,
    required String bookingDate,
    required String bookingTime,
    required String regNumber,
    required String status,
    required Color statusColor,
    required String oilChangeStatus,
    required String carWashStatus,
    required ValueChanged<String?> onOilChangeChanged,
    required ValueChanged<String?> onCarWashChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          // Header with registration number and status
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  registrationNumber,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (status != 'Under Processing')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Booking details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildDetailRow('Booking Date', bookingDate),
                SizedBox(height: 8),
                _buildDetailRow('Booking Time', bookingTime),
                SizedBox(height: 8),
                _buildDetailRow('Registration Number', regNumber),
                SizedBox(height: 16),
              ],
            ),
          ),

          // Selected Services
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Services',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                _buildServiceRow(
                  'Oil Change',
                  oilChangeStatus,
                  onOilChangeChanged,
                ),
                SizedBox(height: 12),
                _buildServiceRow(
                  'Super Car Wash',
                  carWashStatus,
                  onCarWashChanged,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),

          // Continue button
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle continue action
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateInvoicePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE8A5A5),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceRow(
    String serviceName,
    String selectedStatus,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          serviceName,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButton<String>(
            value: selectedStatus,
            onChanged: onChanged,
            underline: SizedBox(),
            items: _statusOptions.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    color: status == 'Select Status'
                        ? Colors.grey[600]
                        : Colors.black87,
                  ),
                ),
              );
            }).toList(),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
