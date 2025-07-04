import 'package:camera/camera.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/select_service.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/service_success.dart';
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
  
  // Loading state
  bool _isLoadingMakes = true;
  
  // Static data for other dropdowns
  final List<String> _models = ['Camry', 'Civic', 'F-150', 'X3', 'C-Class', 'A4'];
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
              
              // Make Dropdown with API data
              _buildMakeDropdown(),
              SizedBox(height: 16),
              
              _buildDropdown(
                value: _selectedModel,
                hintText: 'Select Model',
                items: _models,
                onChanged: (value) => setState(() => _selectedModel = value),
              ),
              SizedBox(height: 16),
              
              _buildDropdown(
                value: _selectedType,
                hintText: 'Select Type',
                items: _types,
                onChanged: (value) => setState(() => _selectedType = value),
              ),
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
            Text('Loading makes...', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    if (_makesController.makes.isEmpty) {
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
            Text('Failed to load makes', style: TextStyle(color: Colors.red)),
            Spacer(),
            TextButton(
              onPressed: () {
                setState(() => _isLoadingMakes = true);
                _loadMakes();
              },
              child: Text('Retry'),
            ),
          ],
        ),
      );
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
      onChanged: (value) => setState(() => _selectedMake = value),
      decoration: InputDecoration(
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
          return 'Please select a make';
        }
        return null;
      },
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
      decoration: InputDecoration(
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
          return 'Please select an option';
        }
        return null;
      },
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoCaptureScreen(camera: cameras.first),
            ),
          );
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

// Video Capture Screen (unchanged)
class VideoCaptureScreen extends StatefulWidget {
  final CameraDescription camera;

  const VideoCaptureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _VideoCaptureScreenState createState() => _VideoCaptureScreenState();
}

class _VideoCaptureScreenState extends State<VideoCaptureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Capture'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: () => Navigator.pop(context),
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.close),
                      ),
                      FloatingActionButton(
                        onPressed: _toggleRecording,
                        backgroundColor: _isRecording ? Colors.red : Colors.white,
                        child: Icon(
                          _isRecording ? Icons.stop : Icons.videocam,
                          color: _isRecording ? Colors.white : Colors.red,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: _isRecording ? null : () => _switchCamera(),
                        backgroundColor: Colors.white,
                        child: Icon(Icons.switch_camera, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                if (_isRecording)
                  Positioned(
                    top: 50,
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Colors.white, size: 12),
                          SizedBox(width: 8),
                          Text('REC', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _toggleRecording() async {
    try {
      if (_isRecording) {
        final video = await _controller.stopVideoRecording();
        setState(() => _isRecording = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video saved: ${video.path}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        await _controller.startVideoRecording();
        setState(() => _isRecording = true);
      }
    } catch (e) {
      print('Error during video recording: $e');
    }
  }

  void _switchCamera() async {
    final cameras = await availableCameras();
    if (cameras.length > 1) {
      final newCamera = cameras.firstWhere(
        (camera) => camera != widget.camera,
        orElse: () => cameras.first,
      );
      
      await _controller.dispose();
      _controller = CameraController(newCamera, ResolutionPreset.high);
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}