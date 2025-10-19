import 'package:champion_car_wash_app/controller/create_service_controller.dart';
import 'package:champion_car_wash_app/controller/get_all_makes_controller.dart';
import 'package:champion_car_wash_app/controller/get_carwash_controller.dart';
import 'package:champion_car_wash_app/controller/get_makes_by_modal_controller.dart';
import 'package:champion_car_wash_app/controller/get_oil_brand_contrtoller.dart';
import 'package:champion_car_wash_app/controller/get_services_controller.dart';
import 'package:champion_car_wash_app/modal/create_service_modal.dart';
import 'package:champion_car_wash_app/modal/get_carwash_modal.dart';
import 'package:champion_car_wash_app/modal/get_services_modal.dart';
import 'package:champion_car_wash_app/modal/selected_service_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/car_wash.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/oil_change.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/service_success.dart';
import 'package:champion_car_wash_app/widgets/common/custom_back_button.dart';
import 'package:flutter/foundation.dart';
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
  late CarwashServiceController _washTypeController; // Add wash type controller
  late GetOilBrandContrtoller _oilBrandController; // Add oil brand controller
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Selected services tracking
  List<SelectedService> selectedServices = [];

  // Service charge (you can make this dynamic)
  final double serviceCharge = 10.0;

  @override
  void initState() {
    super.initState();
    _controller = ServiceTypeController();
    _carWashController = CarWashController(); // Initialize CarWash controller
    _washTypeController =
        CarwashServiceController(); // Initialize wash type controller
    _oilBrandController =
        GetOilBrandContrtoller(); // Initialize oil brand controller
    _controller.loadServiceTypes();
    _washTypeController.fetchCarwashServices(); // Load wash types
    _oilBrandController.fetchOilBrandServices(); // Load oil brands

    // Debug: Print the received values
    if (kDebugMode) {
      debugPrint('DEBUG - Received Make: ${widget.selectedMake}');
      debugPrint('DEBUG - Received Model: ${widget.selectedModel}');
      debugPrint('DEBUG - Received Car Type: ${widget.selectedCarType}');
    }
  }

  // Fuel level
  double fuelLevel = 0.5;

  @override
  void dispose() {
    // MEMORY LEAK FIX: Dispose all TextEditingControllers
    _lastServiceController.dispose();
    _currentOdometerController.dispose();
    _nextServiceController.dispose();

    // MEMORY LEAK FIX: Dispose all ChangeNotifier controllers
    _controller.dispose(); // ServiceTypeController - CRITICAL FIX
    _carWashController.dispose(); // CarWashController
    _washTypeController.dispose(); // CarwashServiceController
    _oilBrandController.dispose(); // GetOilBrandContrtoller

    super.dispose();
  }

  // Calculate totals
  double get subtotal {
    double total = 0.0;
    for (var service in selectedServices) {
      total += service.price ?? 0.0;
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
        ChangeNotifierProvider<CarwashServiceController>.value(
          value: _washTypeController,
        ), // Add wash type provider
        ChangeNotifierProvider<GetOilBrandContrtoller>.value(
          value: _oilBrandController,
        ), // Add oil brand provider
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            backgroundColor: const Color(0xFF2A2A2A),
            elevation: 0,
            leading: const AppBarBackButton(),
            title: const Text(
              'Services',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
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
              if (selectedServices.isNotEmpty) _buildSelectedServicesSection(),
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

  Widget _buildSelectedServicesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
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
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedServices.clear();
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
          ...selectedServices.map(
            (service) => _buildSelectedServiceItem(
              service.details ?? 'N/A',
              service.name,
              service.price ?? 0.0,
              () {
                setState(() {
                  selectedServices.remove(service);
                });
              },
            ),
          ),
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
        color: Colors.green.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withAlpha(77)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
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
                    color: Colors.white,
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
    return Consumer3<
      ServiceTypeController,
      CarwashServiceController,
      GetOilBrandContrtoller
    >(
      builder:
          (context, serviceController, washController, oilController, child) {
            // Show loading if any controller is loading
            if (serviceController.isLoading ||
                washController.isLoading ||
                oilController.isLoading) {
              return SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFD82332),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getLoadingMessage(
                        serviceController,
                        washController,
                        oilController,
                      ),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (serviceController.hasError) {
              return Center(
                child: Text(serviceController.error ?? 'Unknown error'),
              );
            }

            final services = serviceController.serviceTypes;
            final serviceConfigMap = getServiceConfig(context);

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                final configKey = serviceConfigMap.keys.firstWhere(
                  (key) => service.name.contains(key),
                  orElse: () => '',
                );
                final config = serviceConfigMap[configKey];

                return Column(
                  children: [
                    _buildServiceItem(
                      imagePath: config?.imagePath ?? 'assets/carwash.png',
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
      shadowColor: Colors.black.withAlpha(51),
      color: const Color(0xFF2A2A2A),
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
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Debug section - remove this in production
          const Text(
            'Fuel Level',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFF3D3D3D),
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

  Widget _buildSubmitButton() {
    return Consumer<CarWashController>(
      builder: (context, carWashController, child) {
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed:
                selectedServices.isNotEmpty && !carWashController.isLoading
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

  Future<void> _submitService(CarWashController carWashController) async {
    try {
      // Validate required fields
      if (_validateForm()) {
        // Get branch from secure storage
        String? branch = await _secureStorage.read(key: 'branch');
        if (branch == null || branch == 'Not Assigned') {
          branch = 'Qatar';
        }

        // Create services list
        List<ServiceItem> services = [];

        for (var service in selectedServices) {
          // Find matching service type from API
          ServiceType? validServiceType = _controller.getServiceTypeByName(
            service.name,
          );

          if (validServiceType != null) {
            // Use the exact service type name from API
            if (service.details == 'Car Wash Service') {
              // Find matching wash type from API
              WashType? validWashType = _washTypeController.washTypes
                  .where(
                    (washType) =>
                        washType.name.toLowerCase().contains(
                          service.name.toLowerCase(),
                        ) ||
                        service.name.toLowerCase().contains(
                          washType.name.toLowerCase(),
                        ),
                  )
                  .firstOrNull;

              // If no match found, try to find closest match
              validWashType ??= _washTypeController.washTypes
                  .where(
                    (washType) => washType.name.toLowerCase().contains('wash'),
                  )
                  .firstOrNull;

              // Use the first available wash type if still no match
              validWashType ??= _washTypeController.washTypes.isNotEmpty
                  ? _washTypeController.washTypes.first
                  : null;

              services.add(
                ServiceItem(
                  serviceType: validServiceType.name,
                  washType: validWashType?.name ?? service.name.toLowerCase(),
                  price: service.price,
                ),
              );
            } else if (service.details == 'Oil Change Service') {
              services.add(
                ServiceItem(
                  serviceType: validServiceType.name,
                  oilBrand: service.brand,
                  oilType: service.type,
                  price: service.price,
                ),
              );
            } else {
              // For other service types, use the API service type name
              services.add(
                ServiceItem(
                  serviceType: validServiceType.name,
                  price: service.price,
                ),
              );
            }
          } else {
            // Service type not found in API - try to find closest match
            ServiceType? closestMatch;
            if (service.details == 'Car Wash Service') {
              try {
                closestMatch = _controller.serviceTypes.firstWhere(
                  (apiService) =>
                      apiService.name.toLowerCase().contains('wash'),
                );
              } catch (e) {
                closestMatch = _controller.serviceTypes.isNotEmpty
                    ? _controller.serviceTypes.first
                    : null;
              }
            } else if (service.details == 'Oil Change Service') {
              try {
                closestMatch = _controller.serviceTypes.firstWhere(
                  (apiService) => apiService.name.toLowerCase().contains('oil'),
                );
              } catch (e) {
                closestMatch = _controller.serviceTypes.isNotEmpty
                    ? _controller.serviceTypes.first
                    : null;
              }
            }

            if (closestMatch != null) {
              if (kDebugMode) {
                debugPrint(
                  'Warning: Service "${service.name}" not found, using closest match: "${closestMatch.name}"',
                );
              }
              services.add(
                ServiceItem(
                  serviceType: closestMatch.name,
                  washType: service.details == 'Car Wash Service'
                      ? (_washTypeController.washTypes.isNotEmpty
                            ? _washTypeController.washTypes.first.name
                            : service.name.toLowerCase())
                      : null,
                  oilBrand: service.details == 'Oil Change Service'
                      ? service.brand
                      : null,
                  oilType: service.details == 'Oil Change Service'
                      ? service.type
                      : null,
                  price: service.price,
                ),
              );
            } else {
              if (kDebugMode) {
                debugPrint(
                  'Error: No valid service types available from API and no match found for: ${service.name}',
                );
              }
            }
          }
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
          _showSuccessDialog(services, branch);
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

    if (selectedServices.isEmpty) {
      _showErrorDialog('Please select at least one service');
      return false;
    }

    return true;
  }

  // Show success dialog
  void _showSuccessDialog(List<ServiceItem> services, String locationName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text(
                'Success',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Service created successfully !',
              style: TextStyle(fontSize: 16, color: Colors.white),
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
                      builder: (context) => ServiceSuccessScreen(
                        customerName: widget.customerName.text,
                        make: _getSelectedMake(),
                        model: _getSelectedModel(),
                        purchaseDate: widget.purchaseDate.text,
                        engineNumber: widget.engineNumber.text,
                        serviceType: selectedServices
                            .map((e) => e.name)
                            .join(', '),
                        washType: selectedServices
                            .map((e) => e.name)
                            .join(', '),
                        price: subtotal,
                        locationName: locationName,
                      ),
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
          backgroundColor: const Color(0xFF2A2A2A),
          title: const Text('Error', style: TextStyle(color: Colors.white)),
          content: Text(message, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToCarWashing() async {
    // Use actual wash types from the wash types API
    final carWashServices = _washTypeController.washTypes;

    final result = await Navigator.push<List<SelectedService>>(
      context,
      MaterialPageRoute(
        builder: (context) => CarWashScreen(carWashServices: carWashServices),
      ),
    );

    if (result != null) {
      setState(() {
        selectedServices.removeWhere(
          (element) => element.details == 'Car Wash Service',
        );
        selectedServices.addAll(result);
      });
    }
  }

  Future<void> _navigateToOilChange() async {
    final result = await Navigator.push<SelectedService>(
      context,
      MaterialPageRoute(builder: (context) => const OilChangeScreen()),
    );

    if (result != null) {
      setState(() {
        selectedServices.removeWhere(
          (element) => element.details == 'Oil Change Service',
        );
        selectedServices.add(result);
      });
    }
  }

  String _getLoadingMessage(
    ServiceTypeController serviceController,
    CarwashServiceController washController,
    GetOilBrandContrtoller oilController,
  ) {
    final loadingItems = <String>[];

    if (serviceController.isLoading) {
      loadingItems.add('Service Types');
    }
    if (washController.isLoading) {
      loadingItems.add('Wash Types');
    }
    if (oilController.isLoading) {
      loadingItems.add('Oil Brands');
    }

    if (loadingItems.isEmpty) {
      return 'Loading...';
    } else if (loadingItems.length == 1) {
      return 'Loading ${loadingItems.first}...';
    } else {
      return 'Loading ${loadingItems.join(', ')}...';
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
