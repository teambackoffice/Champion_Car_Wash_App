import 'package:flutter/material.dart';

class OilChangeOption {
  final String brandName;
  final String oilType;
  final String price;
  final String imagePath;
  final bool stock;

  OilChangeOption({
    required this.brandName,
    required this.oilType,
    required this.price,
    required this.imagePath,
    required this.stock,
  });
}

class OilChangeScreen extends StatefulWidget {
  const OilChangeScreen({Key? key}) : super(key: key);

  @override
  State<OilChangeScreen> createState() => _OilChangeScreenState();
}

class _OilChangeScreenState extends State<OilChangeScreen> {
  final List<OilChangeOption> options = [
    OilChangeOption(
      brandName: 'Castrol GTX',
      oilType: 'Conventional',
      price: '120 AED',
      imagePath: 'assets/castrol.jpg',
      stock: true
    ),
    OilChangeOption(
      brandName: 'Mobil 1',
      oilType: 'Full Synthetic',
      price: '280 AED',
      imagePath: 'assets/mobil.jpg',
      stock: false
    ),
    OilChangeOption(
      brandName: 'Shell Helix',
      oilType: 'Semi-Synthetic',
      price: '200 AED',
      imagePath: 'assets/shell_helix.jpg',
      stock: true
    ),
    OilChangeOption(
      brandName: 'Valvoline MaxLife',
      oilType: 'High Mileage',
      price: '180 AED',
      imagePath: 'assets/valvoline_maxlife.jpg',
      stock: false
    ),
    OilChangeOption(
      brandName: 'Total Quartz',
      oilType: 'Full Synthetic',
      price: '250 AED',
      imagePath: 'assets/otal_quartz.webp',
      stock: true
    ),
    OilChangeOption(
      brandName: 'Liqui Moly',
      oilType: 'Premium Synthetic',
      price: '320 AED',
      imagePath: 'assets/liqui_moly.jpg',
      stock: true
    ),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  return _buildOilCard(options[index], index);
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
                    // Handle continue logic - you can navigate to booking screen
                    print('Selected: ${options[selectedIndex].brandName}');
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
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
              child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white,size: 18,),
            ),
          ),
          const Spacer(),
          const Text(
            'Oil Change Service',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildOilCard(OilChangeOption option, int index) {
    final bool isSelected = index == selectedIndex;
    final bool isOutOfStock = !option.stock;

    return GestureDetector(
      onTap: option.stock ? () {
        setState(() {
          selectedIndex = index;
        });
      } : null,
      child: Opacity(
        opacity: isOutOfStock ? 0.6 : 1.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isOutOfStock ? Colors.grey[100] : Colors.white,
            border: Border.all(
              color: isSelected && option.stock ? const Color(0xFFD82332) : 
                     isOutOfStock ? Colors.grey[300]! : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isOutOfStock ? [] : [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  // Oil bottle image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isOutOfStock ? Colors.grey[200] : Colors.grey[50],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ColorFiltered(
                        colorFilter: isOutOfStock 
                            ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                            : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                        child: Image.asset(
                          option.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[100],
                              child: Icon(
                                Icons.local_gas_station,
                                size: 40,
                                color: isOutOfStock ? Colors.grey[400] : const Color(0xFFD82332),
                              ),
                            );
                          },
                        ),
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
                          option.brandName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isOutOfStock ? Colors.grey[600] : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          option.oilType,
                          style: TextStyle(
                            fontSize: 14,
                            color: isOutOfStock ? Colors.grey[500] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isOutOfStock)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.red[200]!, width: 1),
                            ),
                            child: Text(
                              'Out of Stock',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        option.price,
                        style: TextStyle(
                          fontSize: 18,
                          color: isOutOfStock ? Colors.grey[500] : const Color(0xFFD82332),
                          fontWeight: FontWeight.bold,
                          decoration: isOutOfStock ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ],
              ),
              // Overlay for out of stock items
              if (isOutOfStock)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}