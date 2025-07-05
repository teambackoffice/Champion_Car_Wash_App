import 'package:champion_car_wash_app/controller/add_prebooking_controller.dart';
import 'package:champion_car_wash_app/controller/get_services_controller.dart';
import 'package:champion_car_wash_app/modal/add_prebooking_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class PreBookingButton extends StatefulWidget {
  const PreBookingButton({super.key});

  @override
  State<PreBookingButton> createState() => _PreBookingButtonState();
}

class _PreBookingButtonState extends State<PreBookingButton> {
  late ServiceTypeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ServiceTypeController();
    _controller.loadServiceTypes(); // ✅ fetch data here
  }

  final _formKey = GlobalKey<FormState>();
  final List<Service> _selectedServices = []; // List for multiple services
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _regNumberController = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedServices.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one service')),
        );
        return;
      }

      if (_selectedDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a date')));
        return;
      }

      if (_selectedTime == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a time')));
        return;
      }

      // Format time as 24-hour string (HH:MM) for API
      String formattedTime =
          '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      final branch = await FlutterSecureStorage().read(key: "branch");
      try {
        // Print data before sending to API
        final prebookingData = AddPreBookingList(
          customerName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          regNumber: _regNumberController.text.trim(),
          date: _selectedDate!,
          time: formattedTime,
          branch: branch!,
          services: _selectedServices,
        );

        // Print all items for debugging

        await context.read<AddPrebookingController>().addPrebook(
          prebook: prebookingData,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form after successful submission
        _clearForm();

        // Optionally navigate back
        Navigator.pop(context);
      } catch (error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create booking: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _regNumberController.clear();
    setState(() {
      _selectedServices.clear();
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ServiceTypeController>.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Pre Booking',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customer Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _nameController,
                          "Customer Name",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter customer name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _phoneController,
                          "+971 Phone Number here",
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter phone number';
                            }
                            if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          _regNumberController,
                          "Registration Number",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter registration number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Service Selection",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildMultiServiceSelection(),
                        const SizedBox(height: 16),
                        const Text(
                          "Schedule Details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: _inputDecoration("Select Date")
                                  .copyWith(
                                    suffixIcon: const Icon(
                                      Icons.calendar_today,
                                    ),
                                  ),
                              controller: TextEditingController(
                                text: _selectedDate == null
                                    ? ''
                                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _pickTime,
                          child: AbsorbPointer(
                            child: TextFormField(
                              decoration: _inputDecoration("Select Time")
                                  .copyWith(
                                    suffixIcon: const Icon(Icons.access_time),
                                  ),
                              controller: TextEditingController(
                                text: _selectedTime == null
                                    ? ''
                                    : _selectedTime!.format(context),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Consumer<AddPrebookingController>(
                  builder: (context, controller, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _submitBooking,
                      child: controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Book Now",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(hint),
      validator: validator,
    );
  }

  Widget _buildMultiServiceSelection() {
    return Consumer<ServiceTypeController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (controller.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              controller.error ?? 'Error loading services',
              style: TextStyle(color: Colors.red.shade700),
            ),
          );
        }

        final services = controller.serviceTypes;

        if (services.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Text('No services available'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Services (You can choose multiple)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...services.map((serviceType) {
                    final isSelected = _selectedServices.any(
                      (s) => s.service == serviceType.name,
                    );
                    return CheckboxListTile(
                      title: Text(serviceType.name),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            // Convert ServiceType to Service
                            _selectedServices.add(
                              Service(service: serviceType.name),
                            );
                          } else {
                            _selectedServices.removeWhere(
                              (s) => s.service == serviceType.name,
                            );
                          }
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.red,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            ),
            if (_selectedServices.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _selectedServices.map((service) {
                  return Chip(
                    label: Text(service.service),
                    onDeleted: () {
                      setState(() {
                        _selectedServices.removeWhere(
                          (s) => s.service == service.service,
                        );
                      });
                    },
                    backgroundColor: Colors.red.shade50,
                    deleteIconColor: Colors.red,
                  );
                }).toList(),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _regNumberController.dispose();
    super.dispose();
  }
}
