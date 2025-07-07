// Updated CreateServicePage with video path handling

import 'package:camera/camera.dart';
import 'package:champion_car_wash_app/controller/get_all_makes_controller.dart';
import 'package:champion_car_wash_app/controller/get_makes_by_modal_controller.dart';
import 'package:champion_car_wash_app/modal/get_all_makes_modal.dart';
import 'package:champion_car_wash_app/modal/get_make_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/select_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateServicePage extends StatefulWidget {
  const CreateServicePage({super.key});

  @override
  _CreateServicePageState createState() => _CreateServicePageState();
}

class _CreateServicePageState extends State<CreateServicePage> {
  final _formKey = GlobalKey<FormState>();
  final CarMakesController _makesController = CarMakesController();
  final CarModelsController _modelsController = CarModelsController();
  final CarModelsController _typeController = CarModelsController();

  // Controllers
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();
  final TextEditingController _chassisNumberController =
      TextEditingController();
  final TextEditingController _registrationNumberController =
      TextEditingController();

  // Dropdown values
  String? _selectedMake;
  String? _selectedModel;
  String? _selectedType;

  // Checkbox and video
  bool _inspectionNeeded = false;
  String? _videoPath; // Add this to store video path

  // Loading states
  bool _isLoadingMakes = true;

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
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
              size: 16,
            ),
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
                      isRequired: false,
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

              _buildTextField(controller: _cityController, hintText: 'City'),

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

              // Inspection Needed Checkbox with Video Status
              _buildInspectionSection(),

              SizedBox(height: 32),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate form before navigation
                    if (_formKey.currentState?.validate() ?? false) {
                      // Additional validation for dropdowns
                      if (_selectedMake == null || _selectedMake!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a car make'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_selectedModel == null || _selectedModel!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a car model'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Get the selected car type from the selected model
                      String? selectedCarType = _selectedType;
                      if (selectedCarType == null || selectedCarType.isEmpty) {
                        // Try to get car type from the selected model
                        final selectedCarModel = _modelsController.models
                            .firstWhere(
                              (model) => model.model == _selectedModel,
                              orElse: () => CarModel(model: '', carType: ''),
                            );
                        selectedCarType = selectedCarModel.carType;
                      }

                      // Debug print to check values before navigation
                      print('DEBUG - Before Navigation:');
                      print('Selected Make: $_selectedMake');
                      print('Selected Model: $_selectedModel');
                      print('Selected Type: $selectedCarType');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectService(
                            customerName: _customerNameController,
                            phoneNumber: _phoneController,
                            email: _emailController,
                            address: _addressController,
                            city: _cityController,
                            make: _makesController,
                            modal: _modelsController,
                            type: _typeController,
                            purchaseDate: _purchaseDateController,
                            engineNumber: _engineNumberController,
                            chasisNumber: _chassisNumberController,
                            registrationNumber: _registrationNumberController,
                            video: _inspectionNeeded,
                            videoPath: _videoPath,
                            selectedMake: _selectedMake,
                            selectedModel: _selectedModel,
                            selectedCarType: selectedCarType,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all required fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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

  // Updated inspection section with video status display
  Widget _buildInspectionSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _inspectionNeeded,
                onChanged: (value) {
                  setState(() {
                    _inspectionNeeded = value ?? false;
                    if (!_inspectionNeeded) {
                      _videoPath = null; // Clear video path if unchecked
                    }
                  });
                  if (_inspectionNeeded) {
                    _openVideoCapture();
                  }
                },
                activeColor: Colors.blue,
              ),
              Expanded(
                child: Text(
                  'Inspection Needed',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),

          // Show video status if inspection is needed
          if (_inspectionNeeded) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _videoPath != null
                    ? Colors.green[50]
                    : Colors.orange[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _videoPath != null
                      ? Colors.green[300]!
                      : Colors.orange[300]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _videoPath != null ? Icons.check_circle : Icons.videocam,
                    color: _videoPath != null ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _videoPath != null
                          ? 'Video recorded successfully'
                          : 'Tap to record inspection video',
                      style: TextStyle(
                        color: _videoPath != null
                            ? Colors.green[700]
                            : Colors.orange[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (_videoPath == null)
                    TextButton(
                      onPressed: _openVideoCapture,
                      child: Text('Record'),
                    ),
                  if (_videoPath != null)
                    TextButton(
                      onPressed: _openVideoCapture,
                      child: Text('Re-record'),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Rest of your existing widget methods...
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
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select a make' : null,
    );
  }

  Widget _buildModelDropdown() {
    if (_selectedMake == null || _selectedMake!.isEmpty) {
      return _buildDisabledDropdown('Select make first');
    }

    return AnimatedBuilder(
      animation: _modelsController,
      builder: (context, child) {
        if (_modelsController.isLoading) {
          return _buildLoadingDropdown('Loading models...');
        }

        if (_modelsController.models.isEmpty &&
            _modelsController.errorMessage.isNotEmpty) {
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
          validator: (value) =>
              value == null || value.isEmpty ? 'Please select a model' : null,
        );
      },
    );
  }

  Widget _buildTypeDropdown() {
    if (_selectedModel == null || _selectedModel!.isEmpty) {
      return _buildDisabledDropdown('Select model first');
    }

    final selectedCarModel = _modelsController.models.firstWhere(
      (model) => model.model == _selectedModel,
      orElse: () => CarModel(model: '', carType: ''),
    );

    if (selectedCarModel.carType.isEmpty) {
      return _buildDisabledDropdown('No car type available');
    }

    // Auto-set the car type when model is selected
    if (_selectedType == null || _selectedType != selectedCarModel.carType) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedType = selectedCarModel.carType;
        });
      });
    }

    return DropdownButtonFormField<String>(
      value: _selectedType,
      hint: Text('Select Car Type', style: TextStyle(color: Colors.grey[400])),
      items: [selectedCarModel.carType].map((type) {
        return DropdownMenuItem<String>(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) => setState(() => _selectedType = value),
      decoration: _dropdownDecoration(),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select car type' : null,
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
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.red)),
          ),
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
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey[400])
            : null,
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
      validator: isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            }
          : null,
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
        _purchaseDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // Updated video capture method with better permission handling
  void _openVideoCapture() async {
    try {
      // Check if camera permission is already granted
      PermissionStatus cameraStatus = await Permission.camera.status;

      if (cameraStatus.isDenied) {
        // Request permission
        cameraStatus = await Permission.camera.request();
      }

      if (cameraStatus.isGranted) {
        final cameras = await availableCameras();

        if (cameras.isNotEmpty) {
          // Navigate to video capture and wait for result
          final String? videoPath = await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCaptureScreen(camera: cameras.first),
            ),
          );

          // Update video path if video was recorded
          if (videoPath != null && videoPath.isNotEmpty) {
            setState(() {
              _videoPath = videoPath;
            });
          }
        } else {
          _showErrorMessage('No cameras available on this device');
        }
      } else if (cameraStatus.isPermanentlyDenied) {
        // Show dialog to go to settings
        _showPermissionDialog();
      } else {
        _showErrorMessage('Camera permission is required for video capture');
        setState(() => _inspectionNeeded = false);
      }
    } catch (e) {
      print('Error opening camera: $e');
      _showErrorMessage('Error opening camera: ${e.toString()}');
      setState(() => _inspectionNeeded = false);
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Camera Permission Required'),
          content: Text(
            'Camera access is permanently denied. Please enable camera permission in your device settings to record inspection videos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // This opens the app settings
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
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

// Updated VideoCaptureScreen that returns video path
class VideoCaptureScreen extends StatefulWidget {
  final CameraDescription camera;

  const VideoCaptureScreen({super.key, required this.camera});

  @override
  _VideoCaptureScreenState createState() => _VideoCaptureScreenState();
}

class _VideoCaptureScreenState extends State<VideoCaptureScreen> {
  late CameraController _controller;
  bool _isRecording = false;
  String? _videoPath;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Record Inspection Video'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller)),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                  child: Icon(Icons.close, color: Colors.white),
                ),

                // Record/Stop button
                ElevatedButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording ? Colors.red : Colors.white,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(30),
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                    color: _isRecording ? Colors.white : Colors.red,
                    size: 40,
                  ),
                ),

                // Done button (only show if video recorded)
                _videoPath != null
                    ? ElevatedButton(
                        onPressed: () => Navigator.pop(context, _videoPath),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                        ),
                        child: Icon(Icons.check, color: Colors.white),
                      )
                    : SizedBox(width: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      await _controller.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final XFile videoFile = await _controller.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _videoPath = videoFile.path;
      });
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
