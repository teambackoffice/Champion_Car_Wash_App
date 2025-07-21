import 'package:champion_car_wash_app/controller/create_service_controller.dart';
import 'package:champion_car_wash_app/controller/get_all_makes_controller.dart';
import 'package:champion_car_wash_app/controller/get_makes_by_modal_controller.dart';
import 'package:champion_car_wash_app/controller/get_services_controller.dart';
import 'package:champion_car_wash_app/modal/create_service_modal.dart';
import 'package:champion_car_wash_app/modal/selected_service_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/car_wash.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/oil_change.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/service_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SelectService extends StatefulWidget {
  final TextEditingController customerName;
  final TextEditingController phoneNumber;
  final TextEditingController email;
  final TextEditingController address;
  final TextEditingController city;
  final CarMakesController make;
  final CarModelsController modal;
  final CarModelsController type;
  final TextEditingController purchaseDate;
  final TextEditingController engineNumber;
  final TextEditingController chasisNumber;
  final TextEditingController registrationNumber;
  final bool video;
  final String? videoPath;
  final String? selectedMake;
  final String? selectedModel;
  final String? selectedCarType;

  const SelectService({
    super.key,
    required this.customerName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.city,
    required this.make,
    required this.modal,
    required this.type,
    required this.purchaseDate,
    required this.engineNumber,
    required this.chasisNumber,
    required this.registrationNumber,
    required this.video,
    this.videoPath,
    this.selectedMake,
    this.selectedModel,
    this.selectedCarType,
  });

  @override
  State<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  // Controllers for text fields
  final TextEditingController _lastServiceController = TextEditingController();
  final TextEditingController _currentOdometerController =
      TextEditingController();
  final TextEditingController _nextServiceController = TextEditingController();
  late ServiceTypeController _controller;
  late CarWashController _carWashController; // Add CarWash controller
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Selected services tracking
  SelectedService? selectedCarWash;
  SelectedService? selectedOilChange;

  // Service charge (you can make this dynamic)
  final double serviceCharge = 10.0;

  @override
  void initState() {
    super.initState();
    _controller = ServiceTypeController();
    _carWashController = CarWashController(); // Initialize CarWash controller
    _controller.loadServiceTypes();

    // Debug: Print the received values
    print('DEBUG - Received Make: ${widget.selectedMake}');
    print('DEBUG - Received Model: ${widget.selectedModel}');
    print('DEBUG - Received Car Type: ${widget.selectedCarType}');
  }

  // Fuel level
  double fuelLevel = 0.5;

  @override
  void dispose() {
    _lastServiceController.dispose();
    _currentOdometerController.dispose();
    _nextServiceController.dispose();
    _carWashController.dispose(); // Dispose controller
    super.dispose();
  }

  // Calculate totals
  double get subtotal {
    double total = 0.0;
    if (selectedOilChange != null && selectedOilChange!.price != null) {
      total += selectedOilChange!.price!;
    }
    return total;
  }

  double get totalAmount => subtotal + serviceCharge;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ServiceTypeController>.value(value: _controller),
        ChangeNotifierProvider<CarWashController>.value(
          value: _carWashController,
        ), // Add CarWash provider
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              ),
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

              const SizedBox(height: 16),

              // Selected Services Section
              if (selectedCarWash != null || selectedOilChange != null)
                _buildSelectedServicesSection(),
              const SizedBox(height: 24),

              // Pricing Section
              // _buildPricingSection(),
              const SizedBox(height: 24),

              // Vehicle Details Section
              _buildVehicleDetailsSection(),

              const SizedBox(height: 32),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Rest of your existing widget methods remain the same...
  // [All the _build methods from _buildSelectedServicesSection to _buildTextField]

  Widget _buildSelectedServicesSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Selected Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedCarWash = null;
                    selectedOilChange = null;
                  });
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (selectedCarWash != null) ...[
            _buildSelectedServiceItem(
              'Car Wash',
              selectedCarWash!.name,
              selectedCarWash!.price!,
              () {
                setState(() {
                  selectedCarWash = null;
                });
              },
            ),
            const SizedBox(height: 8),
          ],
          if (selectedOilChange != null) ...[
            _buildSelectedServiceItem(
              'Oil Change',
              selectedOilChange!.name,
              selectedOilChange!.price ?? 0.0,
              () {
                setState(() {
                  selectedOilChange = null;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedServiceItem(
    String category,
    String serviceName,
    double price,
    VoidCallback onRemove,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Consumer<ServiceTypeController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError) {
          return Center(child: Text(controller.error ?? 'Unknown error'));
        }

        final services = controller.serviceTypes;
        final serviceConfigMap = getServiceConfig(context);

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            final config = serviceConfigMap[service.name];

            return Column(
              children: [
                _buildServiceItem(
                  imagePath: config?.imagePath ?? 'assets/icons/default.png',
                  title: service.name,
                  onTap: config?.onTap ?? () {},
                ),
                if (index < services.length - 1) const SizedBox(height: 12),
              ],
            );
          },
        );
      },
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(imagePath, width: 60, height: 60),
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
          _buildPriceRow('Sub Total', '₹${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),

          const Divider(),
          const SizedBox(height: 8),
          _buildPriceRow(
            'Total',
            '₹${subtotal.toStringAsFixed(2)}',
            isTotal: true,
          ),
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

          // Debug section - remove this in production
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
          _buildTextField('Next Service', _nextServiceController, '00 KM'),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // Updated Submit Button with API call
  Widget _buildSubmitButton() {
    return Consumer<CarWashController>(
      builder: (context, carWashController, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed:
                (selectedCarWash != null || selectedOilChange != null) &&
                    !carWashController.isLoading
                ? () => _submitService(carWashController)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: carWashController.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  // Helper methods to get selected values from CreateServicePage
  String _getSelectedMake() {
    return widget.selectedMake ?? '';
  }

  String _getSelectedModel() {
    return widget.selectedModel ?? '';
  }

  String _getSelectedCarType() {
    return widget.selectedCarType ?? '';
  }

  // Format date to YYYY-MM-DD format
  String _formatDateForAPI(String dateText) {
    if (dateText.isEmpty) return '';

    try {
      // Assuming the input date might be in various formats
      DateTime date;

      // Try parsing common date formats
      if (dateText.contains('/')) {
        // Handle MM/DD/YYYY or DD/MM/YYYY format
        final parts = dateText.split('/');
        if (parts.length == 3) {
          date = DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[0]), // month (assuming MM/DD/YYYY)
            int.parse(parts[1]), // day
          );
        } else {
          return dateText; // Return as is if can't parse
        }
      } else if (dateText.contains('-')) {
        // Already in YYYY-MM-DD format or similar
        date = DateTime.parse(dateText);
      } else {
        return dateText; // Return as is if can't determine format
      }

      // Format to YYYY-MM-DD
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      // If parsing fails, return original text
      return dateText;
    }
  }

  // Method to handle service submission
  Future<void> _submitService(CarWashController carWashController) async {
    try {
      // Validate required fields
      if (_validateForm()) {
        // Get branch from secure storage
        String branch = await _secureStorage.read(key: 'branch') ?? 'Qatar';

        // Create services list
        List<ServiceItem> services = [];

        if (selectedCarWash != null) {
          services.add(
            ServiceItem(
              serviceType: 'Car Wash',
              washType: selectedCarWash!.name,
              price: selectedCarWash!.price,
            ),
          );
        }

        if (selectedOilChange != null) {
          services.add(
            ServiceItem(
              serviceType: 'Oil Change',
              oilBrand: selectedOilChange!.name,
              // price: selectedOilChange!.price,
            ),
          );
        }

        // Create service model
        final serviceModel = CreateServiceModal(
          customerName: widget.customerName.text,
          phone: widget.phoneNumber.text,
          email: widget.email.text,
          address: widget.address.text,
          city: widget.city.text,
          branch: branch,
          make: _getSelectedMake(),
          model: _getSelectedModel(),
          carType: _getSelectedCarType(),
          purchaseDate: _formatDateForAPI(widget.purchaseDate.text),
          engineNumber: widget.engineNumber.text,
          chasisNumber: widget.chasisNumber.text,
          registrationNumber: widget.registrationNumber.text,
          fuelLevel: (fuelLevel * 100).toStringAsFixed(
            0,
          ), // Convert to percentage
          lastServiceOdometer: _lastServiceController.text.isEmpty
              ? '0'
              : _lastServiceController.text,
          currentOdometerReading: _currentOdometerController.text.isEmpty
              ? '0'
              : _currentOdometerController.text,
          nextServiceOdometer: _nextServiceController.text.isEmpty
              ? '0'
              : _nextServiceController.text,
          services: services,
          videoPath: widget.videoPath,
          serviceTotal: subtotal.toString(),
        );

        // Call API
        await carWashController.createService(serviceModel);

        // Handle response
        if (carWashController.isSuccess) {
          // Show success message
          _showSuccessDialog(services);
        } else if (carWashController.isError) {
          // Show error message
          _showErrorDialog(
            carWashController.errorMessage ?? 'Unknown error occurred',
          );
        }
      }
    } catch (e) {
      _showErrorDialog('An unexpected error occurred: $e');
    }
  }

  // Form validation
  bool _validateForm() {
    if (widget.customerName.text.isEmpty) {
      _showErrorDialog('Customer name is required');
      return false;
    }

    if (widget.phoneNumber.text.isEmpty) {
      _showErrorDialog('Phone number is required');
      return false;
    }

    if (widget.email.text.isEmpty) {
      _showErrorDialog('Email is required');
      return false;
    }

    if (selectedCarWash == null && selectedOilChange == null) {
      _showErrorDialog('Please select at least one service');
      return false;
    }

    return true;
  }

  // Show success dialog
  void _showSuccessDialog(List<ServiceItem> services) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Success',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              'Service created successfully !',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceSuccessScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        );
      },
    );
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Navigate to CarWash screen and wait for result
  Future<void> _navigateToCarWashing() async {
    final result = await Navigator.push<SelectedService>(
      context,
      MaterialPageRoute(builder: (context) => const CarWashScreen()),
    );

    print('DEBUG - CarWash result: $result'); // <-- ADD THIS
    if (result != null) {
      print(
        'DEBUG - CarWash name: ${result.name}, price: ${result.price}',
      ); // <-- ADD THIS
      setState(() {
        selectedCarWash = result;
      });
    }
  }

  Future<void> _navigateToOilChange() async {
    final result = await Navigator.push<SelectedService>(
      context,
      MaterialPageRoute(builder: (context) => const OilChangeScreen()),
    );

    print('DEBUG - OilChange result: $result'); // <-- ADD THIS
    if (result != null) {
      print(
        'DEBUG - OilChange name: ${result.name}, price: ${result.price}',
      ); // <-- ADD THIS
      setState(() {
        selectedOilChange = result;
      });
    }
  }

  Map<String, ServiceUIConfig> getServiceConfig(BuildContext context) {
    return {
      'Car Wash': ServiceUIConfig(
        imagePath: 'assets/carwash.png',
        onTap: _navigateToCarWashing,
      ),
      'Oil Change': ServiceUIConfig(
        imagePath: 'assets/oil_change.png',
        onTap: _navigateToOilChange,
      ),
    };
  }
}

class ServiceUIConfig {
  final String imagePath;
  final VoidCallback onTap;

  ServiceUIConfig({required this.imagePath, required this.onTap});
}
