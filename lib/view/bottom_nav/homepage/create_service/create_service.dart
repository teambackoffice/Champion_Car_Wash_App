// Updated CreateServicePage with video path handling

import 'package:camera/camera.dart';
import 'package:champion_car_wash_app/controller/get_all_makes_controller.dart';
import 'package:champion_car_wash_app/controller/get_makes_by_modal_controller.dart';
import 'package:champion_car_wash_app/modal/get_all_makes_modal.dart';
import 'package:champion_car_wash_app/modal/get_make_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/select_service.dart';
import 'package:champion_car_wash_app/widgets/common/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateServicePage extends StatefulWidget {
  final dynamic bookings; // Add this to accept bookings
  final bool isPrebook; // Add this to check if it's a pre-booking
  const CreateServicePage({super.key, this.bookings, required this.isPrebook});

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
  // final TextEditingController _customerNameController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _modalOfYearController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _engineNumberController = TextEditingController();
  final TextEditingController _chassisNumberController =
      TextEditingController();
  // final TextEditingController _registrationNumberController =
  //     TextEditingController();
  late TextEditingController nameController;
  late TextEditingController regNumberController;
  late TextEditingController mobileController;

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

    nameController = TextEditingController(
      text: widget.bookings?.customerName ?? '',
    );
    regNumberController = TextEditingController(
      text: widget.bookings?.regNumber ?? '',
    );
    mobileController = TextEditingController(
      text: widget.bookings?.phone ?? '',
    );

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
      backgroundColor: const Color(0xFF1A1A1A), // Pure black-grey background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: const Color(0xFF2A2A2A), // Dark grey-black
          elevation: 0,
          leading: const AppBarBackButton(),
          title: const Text(
            'Create Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement search functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // Vehicle Details Section
              _buildSectionTitle('Vehicle Details'),
              const SizedBox(height: 16),

              // Make Dropdown
              _buildMakeDropdown(),
              const SizedBox(height: 16),

              // Model Dropdown
              _buildModelDropdown(),
              const SizedBox(height: 16),

              _buildTypeDropdown(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _modalOfYearController,
                hintText: 'Modal Of Year',
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _purchaseDateController,
                hintText: 'Purchase Date',
                suffixIcon: Icons.calendar_today_outlined,
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _engineNumberController,
                hintText: 'Engine Number',
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _chassisNumberController,
                hintText: 'Chassis Number',
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: regNumberController,
                hintText: 'Registration Number',
              ),
              const SizedBox(height: 16),

              // Customer Details Section
              _buildSectionTitle('Customer Details'),
              const SizedBox(height: 16),

              _buildTextField(
                controller: nameController,
                hintText: 'Customer Name',
                readOnly: widget.isPrebook,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: mobileController,
                hintText: '+971 Phone Number here',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _emailController,
                hintText: 'email id',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _addressController,
                hintText: 'Address',
                suffixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),

              _buildTextField(controller: _cityController, hintText: 'City'),

              const SizedBox(height: 24),

              const SizedBox(height: 24),

              // Inspection Needed Checkbox with Video Status
              _buildInspectionSection(),

              const SizedBox(height: 32),

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
                          const SnackBar(
                            content: Text('Please select a car make'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_selectedModel == null || _selectedModel!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
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
                            customerName: nameController,
                            phoneNumber: mobileController,
                            email: _emailController,
                            address: _addressController,
                            city: _cityController,
                            make: _makesController,
                            modal: _modelsController,
                            type: _typeController,
                            purchaseDate: _purchaseDateController,
                            engineNumber: _engineNumberController,
                            chasisNumber: _chassisNumberController,
                            registrationNumber: regNumberController,
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
                        const SnackBar(
                          content: Text('Please fill in all required fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF555555)),
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
                activeColor: Colors.red,
                checkColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
              ),
              const Expanded(
                child: Text(
                  'Inspection Needed',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),

          // Show video status if inspection is needed
          if (_inspectionNeeded) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _videoPath != null
                    ? Colors.green.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _videoPath != null ? Colors.green : Colors.orange,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _videoPath != null ? Icons.check_circle : Icons.videocam,
                    color: _videoPath != null ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _videoPath != null
                          ? 'Video recorded successfully'
                          : 'Tap to record inspection video',
                      style: TextStyle(
                        color: _videoPath != null ? Colors.green : Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (_videoPath == null)
                    TextButton(
                      onPressed: _openVideoCapture,
                      child: const Text(
                        'Record',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  if (_videoPath != null)
                    TextButton(
                      onPressed: _openVideoCapture,
                      child: const Text('Re-record'),
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
      // Check if there's an error message to show error UI or just empty state
      if (_makesController.errorMessage.isNotEmpty) {
        return _buildErrorDropdown('Failed to load makes', () {
          setState(() => _isLoadingMakes = true);
          _loadMakes();
        });
      } else {
        return _buildInfoDropdown('No makes found');
      }
    }

    return DropdownButtonFormField<String>(
      value: _selectedMake,
      hint: Text('Select Make', style: TextStyle(color: Colors.grey[500])),
      style: const TextStyle(color: Colors.white),
      dropdownColor: const Color(0xFF2A2A2A),
      items: _makesController.makes.map((CarMake make) {
        return DropdownMenuItem<String>(
          value: make.name,
          child: Text(make.name, style: const TextStyle(color: Colors.white)),
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
          hint: Text('Select Model', style: TextStyle(color: Colors.grey[500])),
          style: const TextStyle(color: Colors.white),
          dropdownColor: const Color(0xFF2A2A2A),
          items: _modelsController.models.map((CarModel model) {
            return DropdownMenuItem<String>(
              value: model.model,
              child: Text(model.model, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedModel = value;
              if (value != null) {
                final selectedCarModel = _modelsController.models.firstWhere(
                  (model) => model.model == value,
                  orElse: () => CarModel(model: '', carType: ''),
                );
                _selectedType = selectedCarModel.carType;
              }
            });
          },
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

    return DropdownButtonFormField<String>(
      value: _selectedType,
      hint: Text('Select Car Type', style: TextStyle(color: Colors.grey[500])),
      style: const TextStyle(color: Colors.white),
      dropdownColor: const Color(0xFF2A2A2A),
      items: [selectedCarModel.carType].map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedType = value),
      decoration: _dropdownDecoration(),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select car type' : null,
    );
  }

  Widget _buildLoadingDropdown(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        border: Border.all(color: const Color(0xFF555555)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildErrorDropdown(String text, VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        border: Border.all(color: const Color(0xFF555555)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledDropdown(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        border: Border.all(color: const Color(0xFF555555)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildInfoDropdown(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        border: Border.all(color: const Color(0xFF555555)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF555555)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF555555)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.grey[400])
            : null,
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF555555)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF555555)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      // validator: isRequired
      //     ? (value) {
      //         if (value == null || value.isEmpty) {
      //           return 'This field is required';
      //         }
      //         return null;
      //       }
      //     : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!mounted) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _purchaseDateController.text =
            '${picked.day}/${picked.month}/${picked.year}';
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
          title: const Text('Camera Permission Required'),
          content: const Text(
            'Camera access is permanently denied. Please enable camera permission in your device settings to record inspection videos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // This opens the app settings
              },
              child: const Text('Open Settings'),
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    // MEMORY LEAK FIX: Dispose all text editing controllers
    _vehicleNumberController.dispose();
    nameController.dispose();
    mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _modalOfYearController.dispose();
    _cityController.dispose();
    _purchaseDateController.dispose();
    _engineNumberController.dispose();
    _chassisNumberController.dispose();
    regNumberController.dispose();

    // MEMORY LEAK FIX: Dispose custom controllers (ChangeNotifiers)
    _makesController.dispose();
    _modelsController.dispose();
    _typeController.dispose();

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: const Text('Record Inspection Video'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller)),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel button
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),

                // Record/Stop button
                ElevatedButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording ? Colors.red : Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(30),
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
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Icon(Icons.check, color: Colors.white),
                      )
                    : const SizedBox(width: 60),
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
