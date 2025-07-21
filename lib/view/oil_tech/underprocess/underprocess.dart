import 'package:flutter/material.dart';

class ProcessingBookingData {
  final String bookingId;
  final String bookingDate;
  final String bookingTime;
  final String userName;
  final String mobileNo;
  final String email;
  final String vehicleType;
  final String oilbrand;
  final String vehicleNo;

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
    required this.oilbrand,
    required this.vehicleNo,
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
      oilbrand: 'Mobil',
      vehicleNo: 'KL55AB8899',
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
      oilbrand: 'Shell',
      vehicleNo: 'KL55AB8899',
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
      oilbrand: 'Mobil',
      vehicleType: "Hatchback",
      vehicleNo: 'KL55AB8899',
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

class ProcessingBookingCard extends StatefulWidget {
  final ProcessingBookingData booking;

  const ProcessingBookingCard({super.key, required this.booking});

  @override
  State<ProcessingBookingCard> createState() => _ProcessingBookingCardState();
}

class _ProcessingBookingCardState extends State<ProcessingBookingCard> {
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

  String? selectedLitres;
  int? selectedQty;
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
                    widget.booking.bookingId,
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
              _buildDetailRow('Reg No', widget.booking.vehicleNo),
              _buildDetailRow('Booking Time', widget.booking.bookingTime),
              _buildDetailRow('User Name', widget.booking.userName),
              _buildDetailRow('Oil Brand', widget.booking.oilbrand),

              // Select Oil Litres button
              const SizedBox(height: 8),
              // Show selected value using _buildDetailRow if selected, else show tap-to-select link
              selectedLitres != null && selectedQty != null
                  ? _buildDetailRow(
                      'Oil Litre',
                      '$selectedLitres × $selectedQty Qty',
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () =>
                            _showOilSelectionDialog(context, widget.booking),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'Oil Litre: ',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextSpan(
                                  text: 'Select Oil & Quantity',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // const SizedBox(height: 8),
                  if (extraWorkItems.isEmpty)
                    SizedBox()
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[50],
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(color: Colors.grey[300]!),
                  //   ),
                  //   child: const Text(
                  //     'No extra work added',
                  //     style: TextStyle(color: Colors.grey, fontSize: 14),
                  //   ),
                  // )
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    // Text(
                                    //   'Cost: AED ${item.cost.toStringAsFixed(2)}',
                                    //   style: const TextStyle(
                                    //     fontSize: 12,
                                    //     color: Colors.green,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
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
                    // const SizedBox(height: 12),
                    //   Container(
                    //     padding: const EdgeInsets.all(12),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(8),
                    //       border: Border.all(color: Colors.red[200]!),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         const Text(
                    //           'Total Extra Work Cost:',
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w600,
                    //             color: Colors.black87,
                    //           ),
                    //         ),
                    //         Text(
                    //           'AED ${extraWorkItems.fold(0.0, (sum, item) => sum + item.cost).toStringAsFixed(2)}',
                    //           style: const TextStyle(
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w600,
                    //             color: Colors.green,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ],
                    SizedBox(),
                  ],
                ],
              ),

              const SizedBox(height: 5),

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
              ...widget.booking.selectedServices.map(
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
                  onPressed: () =>
                      _showInspectionDialog(context, widget.booking),
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

  void _showOilSelectionDialog(
    BuildContext context,
    ProcessingBookingData booking,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OilSelectionDialog(
          booking: booking,
          onConfirm: (litres, qty) {
            setState(() {
              selectedLitres = litres;
              selectedQty = qty;
            });
          },
        );
      },
    );
  }
}

// Oil Selection Dialog
class OilSelectionDialog extends StatefulWidget {
  final ProcessingBookingData booking;
  final void Function(String litres, int quantity) onConfirm;

  const OilSelectionDialog({
    super.key,
    required this.booking,
    required this.onConfirm,
  });

  @override
  State<OilSelectionDialog> createState() => _OilSelectionDialogState();
}

class _OilSelectionDialogState extends State<OilSelectionDialog> {
  String? selectedOilBrand;
  String? selectedLitres;
  int quantity = 1;

  final List<String> oilBrands = [
    'Castrol',
    'Mobil 1',
    'Shell',
    'Valvoline',
    'Total',
    'Motul',
    'Liqui Moly',
  ];

  final List<String> litreOptions = [
    '0.5L',
    '1L',
    '2L',
    '3L',
    '4L',
    '5L',
    '10L',
  ];

  @override
  void initState() {
    super.initState();

    // Normalize oil brand from booking
    final bookingOil = widget.booking.oilbrand.trim();

    // Check if it's exactly in the list
    if (oilBrands.contains(bookingOil)) {
      selectedOilBrand = bookingOil;
    } else {
      // Optional: try matching loosely (case-insensitive contains)
      try {
        selectedOilBrand = oilBrands.firstWhere(
          (brand) => brand.toLowerCase().contains(bookingOil.toLowerCase()),
        );
      } catch (e) {
        selectedOilBrand = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Oil Details',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Oil Brand Selection
            const Text(
              'Oil Brand',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedOilBrand,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              hint: const Text('Select Oil Brand'),
              items: oilBrands.map((String brand) {
                return DropdownMenuItem<String>(
                  value: brand,
                  child: Text(brand),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOilBrand = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Litres Selection
            const Text(
              'Oil Litres',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedLitres,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              hint: const Text('Select Litres'),
              items: litreOptions.map((String litres) {
                return DropdownMenuItem<String>(
                  value: litres,
                  child: Text(litres),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLitres = newValue;
                });
              },
            ),
            const SizedBox(height: 16),

            // Quantity Selection
            const Text(
              'Quantity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: quantity > 1
                      ? () {
                          setState(() {
                            quantity--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  quantity.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: selectedOilBrand != null && selectedLitres != null
              ? () {
                  widget.onConfirm(selectedLitres!, quantity);
                  Navigator.of(context).pop();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  void _handleOilSelection() {
    // Handle the oil selection logic here
    print('Selected Oil Brand: $selectedOilBrand');
    print('Selected Litres: $selectedLitres');
    print('Quantity: $quantity');

    // You can add your logic here to save the selection
    // For example, update the booking data or call an API
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

  bool get allItemsChecked => inspectionItems.every((item) => item.isChecked);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Inspection Checklist - ${widget.booking.bookingId}'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
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

  void _completeInspection(BuildContext context) {
    Navigator.of(context).pop();

    String message = 'Inspection completed for ${widget.booking.bookingId} ✅';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // You can handle saving inspection completion to DB here if needed
    print(
      'Inspection completed: ${inspectionItems.map((e) => e.title).join(', ')}',
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
