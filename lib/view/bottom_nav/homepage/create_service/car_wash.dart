import 'package:flutter/material.dart';

class CarWashOption {
  final String title;
  final String price;
  final String imagePath;

  CarWashOption({
    required this.title,
    required this.price,
    required this.imagePath,
  });
}

class CarWashScreen extends StatefulWidget {
  const CarWashScreen({Key? key}) : super(key: key);

  @override
  State<CarWashScreen> createState() => _CarWashScreenState();
}

class _CarWashScreenState extends State<CarWashScreen> {
  final List<CarWashOption> options = [
    CarWashOption(
      title: 'Basic Car Wash',
      price: '100 AED',
      imagePath: 'assets/bodywash2.jpg',
    ),
    CarWashOption(
      title: 'Super Car Wash',
      price: '200 AED',
      imagePath: 'assets/steam-car-wash.jpg',
    ),
    CarWashOption(
      title: 'Steam Wash',
      price: '250 AED',
      imagePath: 'assets/superWash.jpg',
    ),
    CarWashOption(
      title: 'VIP Wash',
      price: '400 AED',
      imagePath: 'assets/bodyWash1.jpg',
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
                  return _buildWashCard(options[index], index);
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
                    // Handle continue logic
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16,color: Colors.white),
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
              padding: const EdgeInsets.all(5),
              child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
            ),
          ),
          const Spacer(),
          const Text(
            'Car Washing',
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

  Widget _buildWashCard(CarWashOption option, int index) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFD82332) : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                option.imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  option.price,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFD82332),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
