import 'dart:convert';

import 'package:champion_car_wash_app/controller/get_oil_brand_contrtoller.dart';
import 'package:champion_car_wash_app/controller/oil_subtype_by_brand_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/extra_work_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/inprogress_oil_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/inprogress_status_chnager_controller.dart';
import 'package:champion_car_wash_app/controller/oil_tech/inspection_list_controller.dart';
import 'package:champion_car_wash_app/modal/oil_tech/inprogress_oil_modal.dart';
import 'package:champion_car_wash_app/modal/oil_tech/inspection_list_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description, 'cost': cost};
  }

  // Create from JSON
  factory ExtraWorkItem.fromJson(Map<String, dynamic> json) {
    return ExtraWorkItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      cost: json['cost'].toDouble(),
    );
  }
}

class OilSelection {
  final String brand;
  final String litres;
  final int quantity;

  OilSelection({
    required this.brand,
    required this.litres,
    required this.quantity,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {'brand': brand, 'litres': litres, 'quantity': quantity};
  }

  // Create from JSON
  factory OilSelection.fromJson(Map<String, dynamic> json) {
    return OilSelection(
      brand: json['brand'],
      litres: json['litres'],
      quantity: json['quantity'],
    );
  }
}

class UnderProcessingTab extends StatefulWidget {
  const UnderProcessingTab({super.key});

  @override
  State<UnderProcessingTab> createState() => _UnderProcessingTabState();
}

class _UnderProcessingTabState extends State<UnderProcessingTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InProgressOilController>(
        context,
        listen: false,
      ).fetchInProgressOilServices();
    });
  }

  // Sample data - replace with your actual data source
  final List<ProcessingBookingData> processingBookings = [
    ProcessingBookingData(
      bookingId: 'RO-2025-06-0035',
      bookingDate: 'Jun 25 2025',
      bookingTime: '9:00am',
      userName: 'John Doe',
      mobileNo: '+971 99865 25140',
      email: 'john@gmail.com',
      vehicleType: 'SUV',
      oilbrand: 'Mobil',
      vehicleNo: 'KL55AB8899',
      engineModel: 'Fortuner',
      selectedServices: ['Super Car Wash', 'Oil Change'],
    ),
    ProcessingBookingData(
      bookingId: 'RO-2025-06-0036',
      bookingDate: 'Jun 25 2025',
      bookingTime: '10:30am',
      userName: 'Sarah Wilson',
      mobileNo: '+971 99865 25141',
      email: 'sarah@gmail.com',
      vehicleType: 'Sedan',
      oilbrand: 'Shell',
      vehicleNo: 'KL55AB8899',
      engineModel: 'Camry',
      selectedServices: ['Full Service', 'Tire Rotation'],
    ),
    ProcessingBookingData(
      bookingId: 'RO-2025-06-0037',
      bookingDate: 'Jun 25 2025',
      bookingTime: '11:00am',
      userName: 'Mike Johnson',
      mobileNo: '+971 99865 25142',
      email: 'mike@gmail.com',
      oilbrand: 'Mobil',
      vehicleType: 'Hatchback',
      vehicleNo: 'KL55AB8899',
      engineModel: 'Civic',
      selectedServices: ['Basic Wash', 'Interior Cleaning'],
    ),
  ];

  @override
  void dispose() {
    // MEMORY LEAK FIX: Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<InProgressOilController>(
        builder: (context, inProgressOilController, child) {
          if (inProgressOilController.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.red[800]),
            );
          }
          if (inProgressOilController.error != null) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          
          // Add null check for oilInProgressModal
          if (inProgressOilController.oilInProgressModal == null) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount:
                inProgressOilController.oilInProgressModal!.message.data.length,
            itemBuilder: (context, index) {
              return ProcessingBookingCard(
                booking: inProgressOilController
                    .oilInProgressModal!
                    .message
                    .data[index],
              );
            },
          );
        },
      ),
    );
  }
}

class ProcessingBookingCard extends StatefulWidget {
  final Datum booking;

  const ProcessingBookingCard({super.key, required this.booking});

  @override
  State<ProcessingBookingCard> createState() => _ProcessingBookingCardState();
}

class _ProcessingBookingCardState extends State<ProcessingBookingCard> {
  List<ExtraWorkItem> extraWorkItems = [];
  OilSelection? selectedOil;
  late SharedPreferences _prefs;

  // Common extra work items that technicians might add

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExtraWorkController>(
        context,
        listen: false,
      ).getExtraWorkServices();
    });
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    print('🔍 [LOAD_DATA] Loading saved data for booking: ${widget.booking.serviceId}');
    
    // Load oil selection
    final oilData = _prefs.getString('oil_${widget.booking.serviceId}');
    print('🔍 [LOAD_DATA] Oil data from storage: $oilData');
    
    if (oilData != null) {
      try {
        final oilJson = json.decode(oilData);
        final loadedOil = OilSelection.fromJson(oilJson);
        setState(() {
          selectedOil = loadedOil;
        });
        print('✅ [LOAD_DATA] Oil selection loaded: ${selectedOil!.brand}');
      } catch (e) {
        print('❌ [LOAD_DATA] Error loading oil selection: $e');
      }
    } else {
      print('🔍 [LOAD_DATA] No oil selection found in storage');
    }

    // Load extra work items
    final extraWorkData = _prefs.getString(
      'extra_work_${widget.booking.serviceId}',
    );
    print('🔍 [LOAD_DATA] Extra work data from storage: $extraWorkData');
    
    if (extraWorkData != null) {
      try {
        final List<dynamic> extraWorkJson = json.decode(extraWorkData);
        setState(() {
          extraWorkItems = extraWorkJson
              .map((item) => ExtraWorkItem.fromJson(item))
              .toList();
        });
        print('✅ [LOAD_DATA] Extra work items loaded: ${extraWorkItems.length}');
      } catch (e) {
        print('❌ [LOAD_DATA] Error loading extra work items: $e');
      }
    } else {
      print('🔍 [LOAD_DATA] No extra work items found in storage');
    }
  }

  Future<void> _saveOilSelection(OilSelection oil) async {
    print('🔍 [SAVE_OIL] Saving oil selection for booking: ${widget.booking.serviceId}');
    print('🔍 [SAVE_OIL] Oil details: ${oil.brand}, ${oil.litres}, ${oil.quantity}');
    
    final jsonData = json.encode(oil.toJson());
    await _prefs.setString(
      'oil_${widget.booking.serviceId}',
      jsonData,
    );
    
    print('✅ [SAVE_OIL] Oil selection saved successfully');
  }

  Future<void> _saveExtraWork() async {
    final extraWorkJson = extraWorkItems.map((item) => item.toJson()).toList();
    await _prefs.setString(
      'extra_work_${widget.booking.serviceId}',
      json.encode(extraWorkJson),
    );
  }

  Future<void> _deleteOilSelection() async {
    await _prefs.remove('oil_${widget.booking.serviceId}');
    setState(() {
      selectedOil = null;
    });
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: Clean up resources
    extraWorkItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
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
                    widget.booking.serviceId,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
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
              _buildDetailRow('Reg No', widget.booking.registrationNumber),
              _buildDetailRow(
                'Booking Time',
                DateFormat('dd MMM yyyy').format(
                  DateTime.parse(widget.booking.purchaseDate.toString()),
                ),
              ),
              _buildDetailRow('User Name', widget.booking.customerName!),
              _buildDetailRow(
                'Oil Brand',
                widget.booking.services.first.oilBrand!,
              ),

              // Oil Selection Section
              const SizedBox(height: 8),
              if (selectedOil != null)
                // Show selected oil with delete option
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected Oil Details:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _showOilSelectionDialog(
                                  context,
                                  widget.booking,
                                ),
                                icon: const Icon(Icons.edit, size: 20),
                                style: IconButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  padding: const EdgeInsets.all(4),
                                ),
                                tooltip: 'Edit Oil Selection',
                              ),
                              IconButton(
                                onPressed: _showDeleteOilConfirmation,
                                icon: const Icon(Icons.delete, size: 20),
                                style: IconButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.all(4),
                                ),
                                tooltip: 'Delete Oil Selection',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${selectedOil!.brand} - ${selectedOil!.litres} × ${selectedOil!.quantity} Qty',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                )
              else
                // Show select oil button
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () =>
                        _showOilSelectionDialog(context, widget.booking),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          children: [
                            TextSpan(
                              text: 'Oil Litre: ',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[300] : Colors.grey,
                              ),
                            ),
                            const TextSpan(
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
              Consumer<ExtraWorkController>(
                builder: (context, extraWorkController, child) {
                  // Show selected extra work items (local state)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Extra Work Done',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black87,
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

                      // Display selected extra work items from local state
                      if (extraWorkItems.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'No extra work added yet',
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey[300] : Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
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
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade800),
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
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (item.description.isNotEmpty)
                                          Text(
                                            item.description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
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
                                      _saveExtraWork(); // Save after removal
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

                      if (extraWorkItems.isNotEmpty) const SizedBox(height: 8),
                    ],
                  );
                },
              ),

              // Selected Services
              Text(
                'Selected Services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Services list
              ...widget.booking.services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    service.oilBrand!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Complete button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    print('🔍 [INSPECTION_BUTTON] Inspection button pressed');
                    print('🔍 [INSPECTION_BUTTON] Current selectedOil: ${selectedOil?.brand ?? 'null'}');
                    _showInspectionDialog(context, widget.booking);
                  },
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
                    'Vehicle Inspection',
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

  void _showDeleteOilConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Oil Selection'),
          content: const Text(
            'Are you sure you want to delete the selected oil details?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteOilSelection();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Oil selection deleted'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddExtraWorkDialog() {
    final extraWorkController = Provider.of<ExtraWorkController>(
      context,
      listen: false,
    );
    final apiExtraWork =
        extraWorkController.extraWorkModalClass?.message.extraDetails ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddExtraWorkDialog(
          apiExtraWork:
              apiExtraWork, // Pass API data instead of commonExtraWork
          onAddExtraWork: (item) {
            setState(() {
              extraWorkItems.add(item);
            });
            _saveExtraWork(); // Save after adding
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14, 
                color: isDarkMode ? Colors.grey[300] : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInspectionDialog(BuildContext context, Datum booking) {
    print('🔍 [SHOW_INSPECTION] Showing inspection dialog');
    print('🔍 [SHOW_INSPECTION] selectedOil: ${selectedOil?.brand ?? 'null'}');
    print('🔍 [SHOW_INSPECTION] extraWorkItems: ${extraWorkItems.length}');
    
    // Check if oil selection exists before showing inspection dialog
    if (selectedOil == null) {
      print('❌ [SHOW_INSPECTION] No oil selection found, showing error dialog');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Oil Selection Required'),
            content: const Text(
              'Please select oil details before proceeding with the inspection. '
              'Click "Select Oil Details" button to choose the oil brand and quantity.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    
    print('✅ [SHOW_INSPECTION] Oil selection found, showing inspection dialog');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider(
          create: (context) => OilInprogressStatusServiceController(),
          child: InspectionDialog(
            booking: booking,
            selectedOil: selectedOil!, // Pass the oil selection (non-null)
            extraWorkItems: extraWorkItems, // Pass the extra work items
          ),
        );
      },
    );
  }

  void _showOilSelectionDialog(BuildContext context, Datum booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OilSelectionDialog(
          booking: booking,
          currentSelection: selectedOil,
          onConfirm: (brand, litres, qty) {
            final oilSelection = OilSelection(
              brand: brand,
              litres: litres,
              quantity: qty,
            );
            setState(() {
              selectedOil = oilSelection;
            });
            _saveOilSelection(oilSelection); // Save to SharedPreferences
          },
        );
      },
    );
  }
}

// Oil Selection Dialog
class OilSelectionDialog extends StatefulWidget {
  final Datum booking;
  final OilSelection? currentSelection;
  final void Function(String brand, String litres, int quantity) onConfirm;

  const OilSelectionDialog({
    super.key,
    required this.booking,
    this.currentSelection,
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
    'Mobil ',
    'Shell',
    'Valvoline',
    'Total',
    'Motul',
    'Liqui Moly',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OilsubtypeBybrandController>(
        context,
        listen: false,
      ).fetchOilSubtypesByBrand(widget.booking.services.first.oilBrand!.trim());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetOilBrandContrtoller>(
        context,
        listen: false,
      ).fetchOilBrandServices();
    });

    // Load current selection if editing
    if (widget.currentSelection != null) {
      selectedOilBrand = widget.currentSelection!.brand;
      selectedLitres = widget.currentSelection!.litres;
      quantity = widget.currentSelection!.quantity;
    } else {
      // Normalize oil brand from booking
      final bookingOil = widget.booking.services.first.oilBrand!.trim();

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
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.currentSelection != null
            ? 'Edit Oil Details'
            : 'Select Oil Details',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Oil Brand Selection
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
              Consumer<GetOilBrandContrtoller>(
                builder: (context, brandController, _) {
                  if (brandController.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (brandController.errorMessage != null) {
                    return Text(
                      brandController.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    );
                  }

                  // Sanitize & deduplicate
                  final brandNames = brandController.oilbrand
                      .map((b) => b.name.trim())
                      .toSet()
                      .toList();

                  // Ensure selected value exists
                  if (selectedOilBrand != null &&
                      !brandNames.contains(selectedOilBrand!.trim())) {
                    selectedOilBrand = null;
                  }

                  return DropdownButtonFormField<String>(
                    initialValue: selectedOilBrand,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    hint: const Text(' Select Oil Brand'),
                    items: brandNames.map((name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOilBrand = newValue;
                        selectedLitres = null;
                      });
                      Provider.of<OilsubtypeBybrandController>(
                        context,
                        listen: false,
                      ).fetchOilSubtypesByBrand(newValue ?? '');
                    },
                  );
                },
              ),

              // Litres Selection (from API)
              const Text(
                'Oil Subtypes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Consumer<OilsubtypeBybrandController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.error != null) {
                    return Text(
                      controller.error!,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  final subtypes = controller.oilSubtypes;
                  return DropdownButtonFormField<String>(
                    initialValue: selectedLitres,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    hint: const Text('Select Subtype'),
                    items: subtypes.map((subtype) {
                      return DropdownMenuItem<String>(
                        value: subtype.name,
                        child: Text(subtype.name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLitres = newValue;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Quantity
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
                  widget.onConfirm(
                    selectedOilBrand!,
                    selectedLitres!,
                    quantity,
                  );
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
}

class InspectionDialog extends StatefulWidget {
  final Datum booking;
  final OilSelection selectedOil; // Non-nullable since we check before creating dialog
  final List<ExtraWorkItem> extraWorkItems;

  const InspectionDialog({
    super.key,
    required this.booking,
    required this.selectedOil,
    required this.extraWorkItems,
  });

  @override
  State<InspectionDialog> createState() => _InspectionDialogState();
}

class _InspectionDialogState extends State<InspectionDialog> {
  @override
  void initState() {
    super.initState();
    print('🔍 [INSPECTION_DIALOG] Initializing inspection dialog');
    print('🔍 [INSPECTION_DIALOG] Booking: ${widget.booking.serviceId}');
    print('🔍 [INSPECTION_DIALOG] selectedOil: ${widget.selectedOil.brand ?? 'null'}');
    print('🔍 [INSPECTION_DIALOG] extraWorkItems: ${widget.extraWorkItems.length}');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InspectionListController>(
        context,
        listen: false,
      ).fetchInspectionList('oil change');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionListController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error != null) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(controller.error!),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        }

        final inspectionItems = controller.inspectionItems;

        return AlertDialog(
          title: Text('Inspection Checklist - ${widget.booking.serviceId}'),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicle: ${widget.booking.make} - ${widget.booking.model}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Inspection Checklist',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: inspectionItems.length,
                    itemBuilder: (context, index) {
                      final item = inspectionItems[index];
                      return CheckboxListTile(
                        title: Text(
                          item.questions,
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
                          controller.toggleCheck(index, value ?? false);
                        },
                        activeColor: Colors.red[800],
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.symmetric(),
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
              onPressed: controller.allItemsChecked
                  ? () => _completeInspection(context, inspectionItems)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                foregroundColor: Colors.white,
              ),
              child: const Text('Complete Service'),
            ),
          ],
        );
      },
    );
  }

  void _completeInspection(
    BuildContext context,
    List<Question> inspectionItems,
  ) async {
    print('🔍 [COMPLETE_SERVICE] ========== Starting Service Completion ==========');
    print('🔍 [COMPLETE_SERVICE] Service ID: ${widget.booking.serviceId}');
    print('🔍 [COMPLETE_SERVICE] Inspection items count: ${inspectionItems.length}');
    print('🔍 [COMPLETE_SERVICE] Selected oil: ${widget.selectedOil.brand}');
    
    // Validate inspection items
    if (inspectionItems.isEmpty) {
      print('❌ [COMPLETE_SERVICE] No inspection items found');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No inspection items found. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // Prepare the data for API call
    final selectedOil = widget.selectedOil;
    final extraWorkItems = widget.extraWorkItems;

    print('🔍 [COMPLETE_SERVICE] Oil details:');
    print('🔍 [COMPLETE_SERVICE] - Brand: ${selectedOil.brand}');
    print('🔍 [COMPLETE_SERVICE] - Litres: ${selectedOil.litres}');
    print('🔍 [COMPLETE_SERVICE] - Quantity: ${selectedOil.quantity}');
    print('🔍 [COMPLETE_SERVICE] Extra work items: ${extraWorkItems.length}');

    // Calculate totals with validation
    double extraWorksTotal = extraWorkItems.fold(
      0.0,
      (sum, item) => sum + (item.cost.isFinite ? item.cost : 0.0),
    );
    
    final validQuantity = selectedOil.quantity > 0 ? selectedOil.quantity : 1;
    double oilTotal = 50.0 * validQuantity; // Assuming 50 AED per unit

    print('🔍 [COMPLETE_SERVICE] Calculated totals:');
    print('🔍 [COMPLETE_SERVICE] - Extra works total: $extraWorksTotal');
    print('🔍 [COMPLETE_SERVICE] - Oil total: $oilTotal');
    print('🔍 [COMPLETE_SERVICE] - Valid quantity: $validQuantity');

    // Prepare extra work data for API
    List<Map<String, dynamic>> extraWorkData = extraWorkItems
        .map(
          (item) => {
            'id': item.id,
            'title': item.title,
            'description': item.description,
            'cost': item.cost,
          },
        )
        .toList();

    print('🔍 [COMPLETE_SERVICE] Extra work data prepared: ${extraWorkData.length} items');

    // Prepare inspection answers
    List<Map<String, String>> answers = inspectionItems
        .map(
          (item) => {
            'question': item.questions,
            'answer': item.isChecked ? 'Yes' : 'No',
          },
        )
        .toList();

    print('🔍 [COMPLETE_SERVICE] Inspection answers prepared: ${answers.length} items');
    for (int i = 0; i < answers.length; i++) {
      print('🔍 [COMPLETE_SERVICE] Answer $i: ${answers[i]}');
    }

    // Parse litres safely
    int litresValue;
    try {
      final litresString = selectedOil.litres.replaceAll(RegExp(r'[^0-9]'), '');
      if (litresString.isEmpty) {
        print('⚠️ [COMPLETE_SERVICE] No numeric value in litres, using default 1');
        litresValue = 1;
      } else {
        litresValue = int.parse(litresString);
        print('🔍 [COMPLETE_SERVICE] Parsed litres value: $litresValue');
      }
    } catch (e) {
      print('❌ [COMPLETE_SERVICE] Error parsing litres: $e, using default 1');
      litresValue = 1;
    }

    final priceValue = validQuantity > 0 ? oilTotal / validQuantity : 0.0;
    print('🔍 [COMPLETE_SERVICE] Calculated price per unit: $priceValue');

    try {
      print('🔍 [COMPLETE_SERVICE] Showing loading dialog...');
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ),
      );

      // Call the API
      print('🔍 [COMPLETE_SERVICE] Getting controller...');
      final controller = Provider.of<OilInprogressStatusServiceController>(
        context,
        listen: false,
      );

      print('🔍 [COMPLETE_SERVICE] Submitting oil change details to API...');
      await controller.submitOilChange(
        serviceId: widget.booking.serviceId,
        quantity: validQuantity,
        litres: litresValue,
        price: priceValue,
        subOilType: selectedOil.litres,
        oilTotal: oilTotal,
        extraWork: extraWorkData,
        extraWorksTotal: extraWorksTotal,
        inspectionType: 'Oil Change', // API expects "Oil Change" with capital letters
        answers: answers,
      );

      print('🔍 [COMPLETE_SERVICE] API call completed');

      // Hide loading dialog
      if (mounted) {
        print('🔍 [COMPLETE_SERVICE] Hiding loading dialog...');
        Navigator.of(context).pop();
      }

      // Check response
      if (controller.response != null) {
        // Check if response indicates success or error
        final response = controller.response!;
        final isSuccess = response['success'] != false;
        
        if (isSuccess) {
          print('✅ [COMPLETE_SERVICE] Service completed successfully');
          print('✅ [COMPLETE_SERVICE] Response: $response');
          
          // Close inspection dialog
          if (mounted) {
            Navigator.of(context).pop();
          }

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Service completed successfully for ${widget.booking.serviceId}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          // Refresh the in-progress list
          print('🔍 [COMPLETE_SERVICE] Refreshing in-progress services list...');
          if (mounted) {
            Provider.of<InProgressOilController>(
              context,
              listen: false,
            ).fetchInProgressOilServices();
          }
        } else {
          // API returned an error
          final errorMessage = response['error'] ?? 'Unknown error occurred';
          print('❌ [COMPLETE_SERVICE] Service completion failed: $errorMessage');
          
          // Close inspection dialog
          if (mounted) {
            Navigator.of(context).pop();
          }
          
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 6),
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    _completeInspection(context, inspectionItems);
                  },
                ),
              ),
            );
          }
        }
      } else {
        print('❌ [COMPLETE_SERVICE] Service completion failed - no response from server');
        
        // Close inspection dialog
        if (mounted) {
          Navigator.of(context).pop();
        }
        
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Failed to complete service. No response from server.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  _completeInspection(context, inspectionItems);
                },
              ),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('❌ [COMPLETE_SERVICE] Exception during service completion: $e');
      print('❌ [COMPLETE_SERVICE] Stack trace: $stackTrace');
      
      // Hide loading dialog if still showing
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (popError) {
          print('⚠️ [COMPLETE_SERVICE] Error closing loading dialog: $popError');
        }
      }

      // Show detailed error message
      if (mounted) {
        String errorMessage = 'An error occurred';
        
        if (e.toString().contains('FormatException')) {
          errorMessage = 'Invalid data format. Please check oil selection.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage = 'Network error. Please check your internet connection.';
        } else if (e.toString().contains('TimeoutException')) {
          errorMessage = 'Request timeout. Please try again.';
        } else {
          errorMessage = e.toString();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Error: $errorMessage',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                _completeInspection(context, inspectionItems);
              },
            ),
          ),
        );
      }
    }
    
    print('🔍 [COMPLETE_SERVICE] ========== Service Completion Ended ==========');
  }
}

class AddExtraWorkDialog extends StatefulWidget {
  final List<dynamic> apiExtraWork; // Change type to match API data
  final Function(ExtraWorkItem) onAddExtraWork;

  const AddExtraWorkDialog({
    super.key,
    required this.apiExtraWork,
    required this.onAddExtraWork,
  });

  @override
  State<AddExtraWorkDialog> createState() => _AddExtraWorkDialogState();
}

class _AddExtraWorkDialogState extends State<AddExtraWorkDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredExtraWork = [];

  @override
  void initState() {
    super.initState();
    filteredExtraWork = List.from(widget.apiExtraWork);
    _searchController.addListener(_filterExtraWork);
  }

  void _filterExtraWork() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredExtraWork = widget.apiExtraWork
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Extra Work'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search extra work...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(height: 12),

            // API data selection
            Expanded(
              child: filteredExtraWork.isEmpty
                  ? const Center(
                      child: Text(
                        'No extra work services available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredExtraWork.length,
                      itemBuilder: (context, index) {
                        final apiItem = filteredExtraWork[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              apiItem.name ?? 'Unknown Service',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'AED ${(apiItem.price ?? 0.0).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[800],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                // Convert API item to ExtraWorkItem
                                final extraWorkItem = ExtraWorkItem(
                                  id:
                                      apiItem.name ??
                                      DateTime.now().millisecondsSinceEpoch
                                          .toString(),
                                  title: apiItem.name ?? 'Unknown Service',
                                  description:
                                      'AED ${(apiItem.price ?? 0.0).toStringAsFixed(2)}',
                                  cost: apiItem.price?.toDouble() ?? 0.0,
                                );

                                widget.onAddExtraWork(extraWorkItem);
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${extraWorkItem.title} added to extra work',
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Text('Add'),
                            ),
                          ),
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
      ],
    );
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: Remove listener before disposing controller
    _searchController.removeListener(_filterExtraWork);
    _searchController.dispose();
    super.dispose();
  }
}
