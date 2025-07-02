import 'dart:io';

import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/car_wash.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/oil_change.dart';
import 'package:flutter/material.dart';

class SelectService extends StatefulWidget {
  const SelectService({Key? key}) : super(key: key);

  @override
  State<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  // Controllers for text fields
  final TextEditingController _lastServiceController = TextEditingController();
  final TextEditingController _currentOdometerController = TextEditingController();
  final TextEditingController _nextServiceController = TextEditingController();
  
  // Fuel level
  double fuelLevel = 0.5; // 0.0 to 1.0 (Empty to Full)

  @override
  void dispose() {
    _lastServiceController.dispose();
    _currentOdometerController.dispose();
    _nextServiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Services Section
            _buildServicesSection(),
            
            const SizedBox(height: 24),
            
            // Pricing Section
            _buildPricingSection(),
            
            const SizedBox(height: 24),
            
            // Vehicle Details Section
            _buildVehicleDetailsSection(),
            
            const SizedBox(height: 32),
            
            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      children: [
        _buildServiceItem(
          imagePath: 'assets/carwash.png', // Replace with your actual asset path
          title: 'Car Washing',
          onTap: () => _navigateToCarWashing(),
        ),
        const SizedBox(height: 12),
        _buildServiceItem(
          imagePath: 'assets/oil_change.png', // Replace with your actual asset path
          title: 'Oil Change',
          onTap: () => _navigateToOilChange(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildServiceItem({
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  imagePath,
                  width: 60,
                  height: 60,
                  color: Colors.red, // Optional: to tint the image
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow('Sub Total', '0 AED'),
          const SizedBox(height: 8),
          _buildPriceRow('Service Charge', '0 AED'),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildPriceRow('Total', '0 AED', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Fuel Level
          const Text(
            'Fuel Level',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildFuelLevelIndicator(),
          const SizedBox(height: 20),
          
          // Odometer Readings
          _buildTextField(
            'Last Service Odometer Reading',
            _lastServiceController,
            '00 KM',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Current Odometer Reading',
            _currentOdometerController,
            '00 KM',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            'Next Service',
            _nextServiceController,
            '00 KM',
          ),
        ],
      ),
    );
  }

 Widget _buildFuelLevelIndicator() {
  return Column(
    children: [
      const SizedBox(height: 8),
      Slider(
        value: fuelLevel,
        onChanged: (value) {
          setState(() {
            fuelLevel = value;
          });
        },
        activeColor: Colors.red,
        inactiveColor: Colors.grey[300],
      ),
      // Labels below the slider
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Empty',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Half',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Full',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _handleSubmit();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToCarWashing() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CarWashingScreen(),
      ),
    );
  }

  void _navigateToOilChange() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OilChangeScreen(),
      ),
    );
  }

  void _handleSubmit() {
    // Collect form data
    Map<String, dynamic> formData = {
      'fuelLevel': fuelLevel,
      'lastServiceOdometer': _lastServiceController.text,
      'currentOdometer': _currentOdometerController.text,
      'nextService': _nextServiceController.text,
    };

    // Show confirmation dialog or process the data
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vehicle Details Submitted'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fuel Level: ${(fuelLevel * 100).toInt()}%'),
              if (_currentOdometerController.text.isNotEmpty)
                Text('Current Odometer: ${_currentOdometerController.text}'),
              if (_lastServiceController.text.isNotEmpty)
                Text('Last Service: ${_lastServiceController.text}'),
              if (_nextServiceController.text.isNotEmpty)
                Text('Next Service: ${_nextServiceController.text}'),
            ],
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

    // Here you would typically send the data to your backend
    print('Form Data: $formData');
  }
}