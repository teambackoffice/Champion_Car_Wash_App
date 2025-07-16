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

class ExtraWorkItem {
  final String id;
  final String title;
  final String description;
  final double cost;

  ExtraWorkItem({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
  });
}

class UnderProcessingTab extends StatelessWidget {
  UnderProcessingTab({super.key});

  // Sample data - replace with your actual data source
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
      selectedServices: ["Super Car Wash", "Oil Change"],
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
      selectedServices: ["Full Service", "Tire Rotation"],
    ),
    ProcessingBookingData(
      bookingId: "RO-2025-06-0037",
      bookingDate: "Jun 25 2025",
      bookingTime: "11:00am",
      userName: "Mike Johnson",
      mobileNo: "+971 99865 25142",
      email: "mike@gmail.com",
      vehicleType: "Hatchback",
      engineModel: "Civic",
      selectedServices: ["Basic Wash", "Interior Cleaning"],
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
          return ProcessingBookingCard(booking: processingBookings[index]);
        },
      ),
    );
  }
}

class ProcessingBookingCard extends StatelessWidget {
  final ProcessingBookingData booking;

  const ProcessingBookingCard({super.key, required this.booking});

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
              // Header with booking ID and Processing badge
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

              // Car details
              _buildDetailRow('Booking Date', booking.bookingDate),
              _buildDetailRow('Booking Time', booking.bookingTime),
              _buildDetailRow('User Name', booking.userName),
              _buildDetailRow('Mobile No', booking.mobileNo),
              _buildDetailRow('Email ID', booking.email),
              _buildDetailRow('Vehicle Type', booking.vehicleType),
              _buildDetailRow('Engine Model', booking.engineModel),

              const SizedBox(height: 16),

              // Selected Services
              const Text(
                'Selected Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Services list
              ...booking.selectedServices.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    service,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Complete button
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
                    elevation: 0,
                  ),
                  child: const Text(
                    'Complete',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
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
  List<InspectionItem> inspectionItems = [
    InspectionItem(title: "Engine Oil Check"),
    InspectionItem(title: "Brake Fluid Level"),
    InspectionItem(title: "Tire Pressure"),
    InspectionItem(title: "Battery Check"),
    InspectionItem(title: "Lights & Indicators"),
    InspectionItem(title: "Windshield Wipers"),
    InspectionItem(title: "Air Filter"),
  ];

  List<ExtraWorkItem> extraWorkItems = [];

  // Common extra work items that technicians might add
  final List<ExtraWorkItem> commonExtraWork = [
    ExtraWorkItem(
      id: "1",
      title: "Air Filter Replacement",
      description: "Replaced air filter",
      cost: 25.0,
    ),
    ExtraWorkItem(
      id: "2",
      title: "Oil Filter Replacement",
      description: "Replaced oil filter",
      cost: 15.0,
    ),
    ExtraWorkItem(
      id: "3",
      title: "Fuel Filter Replacement",
      description: "Replaced fuel filter",
      cost: 35.0,
    ),
    ExtraWorkItem(
      id: "4",
      title: "Cabin Filter Replacement",
      description: "Replaced cabin air filter",
      cost: 20.0,
    ),
    ExtraWorkItem(
      id: "5",
      title: "Spark Plug Replacement",
      description: "Replaced spark plugs",
      cost: 40.0,
    ),
    ExtraWorkItem(
      id: "6",
      title: "Brake Pad Replacement",
      description: "Replaced brake pads",
      cost: 80.0,
    ),
  ];

  bool get allItemsChecked => inspectionItems.every((item) => item.isChecked);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Inspection Checklist - ${widget.booking.bookingId}'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vehicle: ${widget.booking.vehicleType} - ${widget.booking.engineModel}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Inspection Checklist
                    const Text(
                      'Inspection Checklist',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                              color: item.isChecked
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          value: item.isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              item.isChecked = value ?? false;
                            });
                          },
                          activeColor: Colors.green,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Extra Work Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Extra Work Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showAddExtraWorkDialog,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (extraWorkItems.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const Text(
                          'No extra work added',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: extraWorkItems.length,
                        itemBuilder: (context, index) {
                          final item = extraWorkItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      Text(
                                        'Cost: AED ${item.cost.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      extraWorkItems.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                  iconSize: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    if (extraWorkItems.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Extra Work Cost:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'AED ${extraWorkItems.fold(0.0, (sum, item) => sum + item.cost).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
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
            backgroundColor: Colors.green[600],
            foregroundColor: Colors.white,
          ),
          child: const Text('Complete Service'),
        ),
      ],
    );
  }

  void _showAddExtraWorkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExtraWorkDialog(
          commonExtraWork: commonExtraWork,
          onAddExtraWork: (item) {
            setState(() {
              extraWorkItems.add(item);
            });
          },
        );
      },
    );
  }

  void _completeInspection(BuildContext context) {
    Navigator.of(context).pop();

    // Calculate total extra work cost
    double totalExtraCost = extraWorkItems.fold(
      0.0,
      (sum, item) => sum + item.cost,
    );

    String message = 'Service completed for ${widget.booking.bookingId}';
    if (extraWorkItems.isNotEmpty) {
      message +=
          '\nExtra work: ${extraWorkItems.length} items (\$${totalExtraCost.toStringAsFixed(2)})';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Here you would typically save the extra work data to your database
    // You can access extraWorkItems list to get all the extra work done
    print(
      'Extra work completed: ${extraWorkItems.map((item) => item.title).join(', ')}',
    );
  }
}

class AddExtraWorkDialog extends StatefulWidget {
  final List<ExtraWorkItem> commonExtraWork;
  final Function(ExtraWorkItem) onAddExtraWork;

  const AddExtraWorkDialog({
    super.key,
    required this.commonExtraWork,
    required this.onAddExtraWork,
  });

  @override
  State<AddExtraWorkDialog> createState() => _AddExtraWorkDialogState();
}

class _AddExtraWorkDialogState extends State<AddExtraWorkDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  final bool _isCustomWork = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Extra Work'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),

            // Toggle between common and custom work
            Row(children: [
               
              ],
            ),

            const SizedBox(height: 5),

            if (!_isCustomWork)
              // Common work selection
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.commonExtraWork.length,
                  itemBuilder: (context, index) {
                    final item = widget.commonExtraWork[index];
                    return ListTile(
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('AED ${item.cost.toStringAsFixed(2)}'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[800], // Background color
                          foregroundColor: Colors.white, // Text color
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        onPressed: () {
                          widget.onAddExtraWork(item);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Add'),
                      ),
                    );
                  },
                ),
              )
            else
              // Custom work form
              Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Work Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _costController,
                    decoration: const InputDecoration(
                      labelText: 'Cost (\$)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (_isCustomWork)
          ElevatedButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty &&
                  _costController.text.isNotEmpty) {
                final customWork = ExtraWorkItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  cost: double.tryParse(_costController.text) ?? 0.0,
                );
                widget.onAddExtraWork(customWork);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add Custom Work'),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }
}
