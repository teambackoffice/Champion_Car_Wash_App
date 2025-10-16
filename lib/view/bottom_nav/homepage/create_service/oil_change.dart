import 'package:champion_car_wash_app/controller/get_oil_brand_contrtoller.dart';
import 'package:champion_car_wash_app/modal/selected_service_modal.dart';
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
    Provider.of<GetOilBrandContrtoller>(
      context,
      listen: false,
    ).fetchOilBrandServices();
  }

  int selectedIndex = 0;
  String? selectedOilType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
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
                        onTap: () {
                          final oilTypes =
                              controller.oilBrand!.message.oilTypes;

                          if (oilTypes.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No oil types available'),
                              ),
                            );
                            return;
                          }

                          String? tempSelectedOilType;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setDialogState) {
                                  return AlertDialog(
                                    title: const Text('Select Oil Type'),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: oilTypes.length,
                                        itemBuilder: (context, typeIndex) {
                                          final oilType = oilTypes[typeIndex];

                                          return RadioListTile<String>(
                                            title: Text(oilType.name),
                                            value: oilType.name,
                                            groupValue: tempSelectedOilType,
                                            onChanged: (value) {
                                              setDialogState(() {
                                                tempSelectedOilType = value;
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFD82332,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (tempSelectedOilType != null) {
                                            setState(() {
                                              selectedIndex = index;
                                              selectedOilType =
                                                  tempSelectedOilType;
                                            });
                                            Navigator.pop(context);
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Please select an oil type',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text('Select'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFD82332)
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(20),
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
                                  color: Colors.grey[50],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/oil_change.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[100],
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
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (isSelected && selectedOilType != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD82332).withAlpha(26),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          selectedOilType!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFD82332),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Price
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Text(
                                  //   '₹${oilBrand.name}',
                                  //   style: const TextStyle(
                                  //     fontSize: 18,
                                  //     color: Color(0xFFD82332),
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  SizedBox(height: 4),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD82332),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // Get the selected oil brand
                        final selectedOil = oillist[selectedIndex];

                        // Create SelectedService object
                        final selectedService = SelectedService(
                          name: selectedOil.name,
                          details: 'Oil Change Service',
                        );

                        // Return to previous screen with selected service data
                        Navigator.pop(context, selectedService);
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
