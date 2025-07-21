import 'package:flutter/material.dart';

class ProcessingBookingData {
  final String bookingId;
  final String bookingDate;
  final String bookingTime;
  final String userName;
  final String mobileNo;
  final String email;
  final String vehicleType;
  final String engineModel;
  final List<String> selectedServices;

  ProcessingBookingData({
    required this.bookingId,
    required this.bookingDate,
    required this.bookingTime,
    required this.userName,
    required this.mobileNo,
    required this.email,
    required this.vehicleType,
    required this.engineModel,
    required this.selectedServices,
  });
}

class InspectionItem {
  final String title;
  bool isChecked;

  InspectionItem({required this.title, this.isChecked = false});
}

class CarWashUnderProcessing extends StatelessWidget {
  CarWashUnderProcessing({super.key});

  final List<ProcessingBookingData> processingBookings = [
    ProcessingBookingData(
      bookingId: "RO-2025-06-0035",
      bookingDate: "Jun 25 2025",
      bookingTime: "9:00am",
      userName: "John Doe",
      mobileNo: "+971 99865 25140",
      email: "john@gmail.com",
      vehicleType: "SUV",
      engineModel: "Fortuner",
      selectedServices: ["Super Car Wash", "Foam Wash"],
    ),
    ProcessingBookingData(
      bookingId: "RO-2025-06-0036",
      bookingDate: "Jun 25 2025",
      bookingTime: "10:30am",
      userName: "Sarah Wilson",
      mobileNo: "+971 99865 25141",
      email: "sarah@gmail.com",
      vehicleType: "Sedan",
      engineModel: "Camry",
      selectedServices: ["Interior Cleaning", "Tire Shine"],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: processingBookings.length,
        itemBuilder: (context, index) {
          return WashProcessingBookingCard(booking: processingBookings[index]);
        },
      ),
    );
  }
}

class WashProcessingBookingCard extends StatelessWidget {
  final ProcessingBookingData booking;

  const WashProcessingBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.bookingId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Processing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Booking Info
              _buildDetailRow('Booking Date', booking.bookingDate),
              _buildDetailRow('Booking Time', booking.bookingTime),

              _buildDetailRow('User Name', booking.userName),
              // _buildDetailRow('Mobile No', booking.mobileNo),
              // _buildDetailRow('Email ID', booking.email),
              // _buildDetailRow('Vehicle Type', booking.vehicleType),
              // _buildDetailRow('Engine Model', booking.engineModel),
              const SizedBox(height: 8),
              const Text(
                'Selected Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ...booking.selectedServices.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    service,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showInspectionDialog(context, booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Complete', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showInspectionDialog(
    BuildContext context,
    ProcessingBookingData booking,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InspectionDialog(booking: booking);
      },
    );
  }
}

class InspectionDialog extends StatefulWidget {
  final ProcessingBookingData booking;

  const InspectionDialog({super.key, required this.booking});

  @override
  State<InspectionDialog> createState() => _InspectionDialogState();
}

class _InspectionDialogState extends State<InspectionDialog> {
  final List<InspectionItem> inspectionItems = [
    InspectionItem(title: "Exterior Wash"),
    InspectionItem(title: "Interior Cleaning"),
    InspectionItem(title: "Tire Shine"),
    InspectionItem(title: "Windows & Mirrors"),
    InspectionItem(title: "Vacuuming"),
    InspectionItem(title: "Dashboard Cleaning"),
    InspectionItem(title: "Mat Cleaning"),
    InspectionItem(title: "Door Jambs Wipe"),
  ];

  bool get allItemsChecked => inspectionItems.every((item) => item.isChecked);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Car Wash Checklist - ${widget.booking.bookingId}'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vehicle: ${widget.booking.vehicleType} - ${widget.booking.engineModel}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: inspectionItems.length,
                itemBuilder: (context, index) {
                  final item = inspectionItems[index];
                  return CheckboxListTile(
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14,
                        decoration: item.isChecked
                            ? TextDecoration.lineThrough
                            : null,
                        color: item.isChecked ? Colors.grey : Colors.black87,
                      ),
                    ),
                    value: item.isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        item.isChecked = value ?? false;
                      });
                    },
                    activeColor: Colors.red[800],
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: allItemsChecked
              ? () => _completeInspection(context)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[800],
            foregroundColor: Colors.white,
          ),
          child: const Text('Complete Service'),
        ),
      ],
    );
  }

  void _completeInspection(BuildContext context) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Car wash completed for ${widget.booking.bookingId}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    // ✅ TODO: Add backend completion logic if needed
  }
}
