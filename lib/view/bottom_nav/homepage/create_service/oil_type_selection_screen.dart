import 'package:champion_car_wash_app/modal/get_oilbrand_modal.dart';
import 'package:champion_car_wash_app/modal/selected_service_modal.dart';
import 'package:flutter/material.dart';

class OilTypeSelectionScreen extends StatefulWidget {
  final List<OilType> oilTypes;
  final String brandName;

  const OilTypeSelectionScreen(
      {super.key, required this.oilTypes, required this.brandName});

  @override
  State<OilTypeSelectionScreen> createState() => _OilTypeSelectionScreenState();
}

class _OilTypeSelectionScreenState extends State<OilTypeSelectionScreen> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text('Select ${widget.brandName} Type'),
        backgroundColor: const Color(0xFF2A2A2A),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.oilTypes.length,
              itemBuilder: (context, index) {
                final oilType = widget.oilTypes[index];
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 20),
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
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          oilType.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '₹${oilType.price?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFFD82332),
                            fontWeight: FontWeight.bold,
                          ),
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
                onPressed: selectedIndex != -1
                    ? () {
                        final selectedOilType = widget.oilTypes[selectedIndex];
                        final selectedService = SelectedService(
                          name: '${widget.brandName} - ${selectedOilType.name}',
                          price: selectedOilType.price,
                          details: 'Oil Change Service',
                          brand: widget.brandName,
                          type: selectedOilType.name,
                        );
                        Navigator.pop(context, selectedService);
                      }
                    : null,
                child: const Text(
                  'Select',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
