// Updated CreateServicePage with Models Integration

import 'package:camera/camera.dart';
import 'package:champion_car_wash_app/controller/get_makes_by_modal_controller.dart';
import 'package:champion_car_wash_app/modal/get_make_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/select_service.dart';
import 'package:champion_car_wash_app/modal/get_all_makes_modal.dart';
import 'package:champion_car_wash_app/controller/get_all_makes_controller.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateServicePage extends StatefulWidget {
  @override
  _CreateServicePageState createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final _formKey = GlobalKey<FormState>();
  final CarMakesController _makesController = CarMakesController();
  final CarModelsController _modelsController = CarModelsController();
  final CarModelsController _typeController = CarModelsController();
  
  // Controllers
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();
  final TextEditingController _chassisNumberController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  
  // Dropdown values
  String? _selectedMake;
  String? _selectedModel;
  String? _selectedType;
  
  // Checkbox
  bool _inspectionNeeded = false;
  
  // Loading states
  bool _isLoadingMakes = true;
  
  // Static data for types
  final List<String> _types = ['Sedan', 'SUV', 'Hatchback', 'Truck', 'Coupe'];

  @override
  void initState() {
    super.initState();
    _loadMakes();
  }

  Future<void> _loadMakes() async {
    await _makesController.fetchMakes();
    setState(() => _isLoadingMakes = false);
  }

  void _onMakeChanged(String? make) {
    setState(() {
      _selectedMake = make;
      _selectedModel = null; // Clear selected model when make changes
    });
    
    if (make != null && make.isNotEmpty) {
      _modelsController.fetchModelsByMake(make);
    } else {
      _modelsController.clearData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Number with Search
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      controller: _vehicleNumberController,
                      hintText: 'Vehicle Number',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement search functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Search'),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Customer Details Section
              _buildSectionTitle('Customer Details'),
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _customerNameController,
                hintText: 'Customer Name',
              ),
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _phoneController,
                hintText: '+971 Phone Number here',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _emailController,
                hintText: 'email id',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _addressController,
                hintText: 'Address',
                suffixIcon: Icons.location_on_outlined,
              ),
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _cityController,
                hintText: 'City',
              ),
              
              SizedBox(height: 24),
              
              // Vehicle Details Section
              _buildSectionTitle('Vehicle Details'),
              SizedBox(height: 16),
              
              // Make Dropdown
              _buildMakeDropdown(),
              SizedBox(height: 16),
              
              // Model Dropdown
              _buildModelDropdown(),
              SizedBox(height: 16),

                _buildTypeDropdown(),
              SizedBox(height: 16),
              
             
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _purchaseDateController,
                hintText: 'Purchase Date',
                suffixIcon: Icons.calendar_today_outlined,
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _engineNumberController,
                hintText: 'Engine Number',
              ),
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _chassisNumberController,
                hintText: 'Chassis Number',
              ),
              SizedBox(height: 16),
              
              _buildTextField(
                controller: _registrationNumberController,
                hintText: 'Registration Number',
              ),
              
              SizedBox(height: 24),
              
              // Inspection Needed Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _inspectionNeeded,
                    onChanged: (value) {
                      setState(() => _inspectionNeeded = value ?? false);
                      if (_inspectionNeeded) {
                        _openVideoCapture();
                      }
                    },
                    activeColor: Colors.blue,
                  ),
                  Text(
                    'Inspection Needed',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectService()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMakeDropdown() {
    if (_isLoadingMakes) {
      return _buildLoadingDropdown('Loading makes...');
    }

    if (_makesController.makes.isEmpty) {
      return _buildErrorDropdown('Failed to load makes', () {
        setState(() => _isLoadingMakes = true);
        _loadMakes();
      });
    }

    return DropdownButtonFormField<String>(
      value: _selectedMake,
      hint: Text('Select Make', style: TextStyle(color: Colors.grey[400])),
      items: _makesController.makes.map((CarMake make) {
        return DropdownMenuItem<String>(
          value: make.name,
          child: Text(make.name),
        );
      }).toList(),
      onChanged: _onMakeChanged,
      decoration: _dropdownDecoration(),
      validator: (value) => value == null || value.isEmpty ? 'Please select a make' : null,
    );
  }

  Widget _buildModelDropdown() {
    // If no make is selected, show disabled dropdown
    if (_selectedMake == null || _selectedMake!.isEmpty) {
      return _buildDisabledDropdown('Select make first');
    }

    return AnimatedBuilder(
      animation: _modelsController,
      builder: (context, child) {
        if (_modelsController.isLoading) {
          return _buildLoadingDropdown('Loading models...');
        }

        if (_modelsController.models.isEmpty && _modelsController.errorMessage.isNotEmpty) {
          return _buildErrorDropdown('Failed to load models', () {
            _modelsController.fetchModelsByMake(_selectedMake!);
          });
        }

        if (_modelsController.models.isEmpty) {
          return _buildDisabledDropdown('No models available');
        }

        return DropdownButtonFormField<String>(
          value: _selectedModel,
          hint: Text('Select Model', style: TextStyle(color: Colors.grey[400])),
          items: _modelsController.models.map((CarModel model) {
            return DropdownMenuItem<String>(
              value: model.model,
              child: Text(model.model),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedModel = value),
          decoration: _dropdownDecoration(),
          validator: (value) => value == null || value.isEmpty ? 'Please select a model' : null,
        );
      },
    );
  }
  Widget _buildTypeDropdown() {
  // If no model is selected, show disabled dropdown
  if (_selectedModel == null || _selectedModel!.isEmpty) {
    return _buildDisabledDropdown('Select model first');
  }

  // Find car type from selected model
  final selectedCarModel = _modelsController.models.firstWhere(
    (model) => model.model == _selectedModel,
    orElse: () => CarModel(model: '', carType: ''),
  );

  if (selectedCarModel.carType.isEmpty) {
    return _buildDisabledDropdown('No car type available');
  }

  return DropdownButtonFormField<String>(
    value: _selectedType ?? selectedCarModel.carType,
    hint: Text('Select Car Type', style: TextStyle(color: Colors.grey[400])),
    items: [selectedCarModel.carType].map((type) {
      return DropdownMenuItem<String>(
        value: type,
        child: Text(type),
      );
    }).toList(),
    onChanged: (value) => setState(() => _selectedType = value),
    decoration: _dropdownDecoration(),
    validator: (value) => value == null || value.isEmpty ? 'Please select car type' : null,
  );
}


  Widget _buildLoadingDropdown(String text) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildErrorDropdown(String text, VoidCallback onRetry) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20),
          SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Colors.red))),
          TextButton(onPressed: onRetry, child: Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildDisabledDropdown(String text) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[400], size: 20),
          SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
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
        borderSide: BorderSide(color: Colors.blue),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey[400]) : null,
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
          borderSide: BorderSide(color: Colors.blue),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hintText, style: TextStyle(color: Colors.grey[400])),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: _dropdownDecoration(),
      validator: (value) => value == null || value.isEmpty ? 'Please select an option' : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _purchaseDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _openVideoCapture() async {
    try {
      final permission = await Permission.camera.request();
      
      if (permission.isGranted) {
        final cameras = await availableCameras();
        
        if (cameras.isNotEmpty) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => VideoCaptureScreen(camera: cameras.first),
          //   ),
          // );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera permission is required for video capture'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _inspectionNeeded = false);
      }
    } catch (e) {
      print('Error opening camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening camera'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _inspectionNeeded = false);
    }
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _customerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _purchaseDateController.dispose();
    _engineNumberController.dispose();
    _chassisNumberController.dispose();
    _registrationNumberController.dispose();
    super.dispose();
  }
}