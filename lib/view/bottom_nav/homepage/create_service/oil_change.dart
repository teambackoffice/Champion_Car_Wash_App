import 'package:champion_car_wash_app/controller/get_oil_brand_contrtoller.dart';
import 'package:champion_car_wash_app/modal/selected_service_modal.dart';
import 'package:champion_car_wash_app/view/bottom_nav/homepage/create_service/oil_type_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OilChangeScreen extends StatefulWidget {
  const OilChangeScreen({super.key});

  @override
  State<OilChangeScreen> createState() => _OilChangeScreenState();
}

class _OilChangeScreenState extends State<OilChangeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GetOilBrandContrtoller>(
        context,
        listen: false,
      ).fetchOilBrandServices();
    });
  }

  int selectedIndex = -1;
  String? selectedOilType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark mode background
      body: SafeArea(
        child: Consumer<GetOilBrandContrtoller>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.oilBrand == null ||
                controller.oilBrand!.message.oilBrands.isEmpty) {
              return const Center(child: Text('No oil brands available'));
            }

            final oillist = controller.oilBrand!.message.oilBrands;

            return Column(
              children: [
                const SizedBox(height: 16),
                _buildHeader(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: oillist.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      final bool isSelected = index == selectedIndex;
                      final oilBrand = oillist[index];

                      return GestureDetector(
                        onTap: () async {
                          final selectedService =
                              await Navigator.push<SelectedService>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OilTypeSelectionScreen(
                                    oilTypes:
                                        controller.oilBrand!.message.oilTypes,
                                    brandName: oilBrand.name,
                                  ),
                                ),
                              );
                          if (selectedService != null) {
                            Navigator.pop(context, selectedService);
                          }
                        },

                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.red.withOpacity(0.1)
                                : const Color(0xFF2A2A2A),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFD82332)
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Oil bottle image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[800],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/oil_change.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[800],
                                        child: const Icon(
                                          Icons.local_gas_station,
                                          size: 40,
                                          color: Color(0xFFD82332),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Oil details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      oilBrand.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${oilBrand.price?.toStringAsFixed(2) ?? '0.00'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFFD82332),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFD82332),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Oil Change Service',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
