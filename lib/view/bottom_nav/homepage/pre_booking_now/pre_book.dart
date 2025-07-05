import 'package:champion_car_wash_app/controller/get_services_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreBookingButton extends StatefulWidget {
  const PreBookingButton({super.key});

  @override
  State<PreBookingButton> createState() => _PreBookingButtonState();
}

class _PreBookingButtonState extends State<PreBookingButton> {
  late ServiceTypeController _controller;
   void initState() {
    super.initState();
    _controller = ServiceTypeController();
    _controller.loadServiceTypes(); // ✅ fetch data here
  }
  final _formKey = GlobalKey<FormState>();
  String? _selectedService;
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
          title: const Text('Pre Booking', style: TextStyle(color: Colors.black)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Customer Details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(_nameController, "Customer Name"),
                    const SizedBox(height: 10),
                    _buildTextField(_phoneController, "+971 Phone Number here", keyboardType: TextInputType.phone),
                    const SizedBox(height: 10),
                   _buildServiceDropdown(),
                    const SizedBox(height: 10),
                    _buildTextField(_regNumberController, "Registration Number"),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: _inputDecoration("Select Date").copyWith(
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          controller: TextEditingController(
                            text: _selectedDate == null
                                ? ''
                                : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _pickTime,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: _inputDecoration("Select Time").copyWith(
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
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle booking logic
                    }
                  },
                  child: const Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 16)),
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
        borderRadius: BorderRadius.circular(10)
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
        
       
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
       
      ),
      // contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(hint),
    );
  }
  Widget _buildServiceDropdown() {
  return Consumer<ServiceTypeController>(
    builder: (context, controller, child) {
      if (controller.isLoading) {
        return const CircularProgressIndicator(); // Show loading
      }

      if (controller.hasError) {
        return Text(controller.error ?? 'Error loading services'); // Show error
      }

      final services = controller.serviceTypes;

      return DropdownButtonFormField<String>(
        decoration: _inputDecoration("Select Service"),
        value: _selectedService,
        items: services
            .map((service) => DropdownMenuItem<String>(
                  value: service.name,
                  child: Text(service.name),
                ))
            .toList(),
        onChanged: (val) => setState(() => _selectedService = val),
      );
    },
  );
}

}
