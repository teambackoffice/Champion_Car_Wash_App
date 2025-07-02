import 'package:champion_car_wash_app/view/bottom_nav/homepage/service_completed/completed.dart';
import 'package:flutter/material.dart';

class ServiceCompletedScreen extends StatefulWidget {
  @override
  _ServiceCompletedScreenState createState() => _ServiceCompletedScreenState();
}

class _ServiceCompletedScreenState extends State<ServiceCompletedScreen> 
    with TickerProviderStateMixin {
  
  // Tab controller for managing tabs
  late TabController _controller;
  
  // Animation controllers for smooth transitions
  late AnimationController _animationControllerOn;
  late AnimationController _animationControllerOff;
  
  // Color animations
  late Animation _colorTweenBackgroundOn;
  late Animation _colorTweenBackgroundOff;
  late Animation _colorTweenForegroundOn;
  late Animation _colorTweenForegroundOff;
  
  // Current and previous tab indices
  int _currentIndex = 0;
  int _prevControllerIndex = 0;
  
  // Animation values
  double _aniValue = 0.0;
  double _prevAniValue = 0.0;
  
  // Tab labels
  List<String> _tabLabels = ['Completed', 'Payment Due'];
  
  // Colors for active/inactive states
  Color _foregroundOn = Colors.black87;
  // Color _foregroundOff = Colors.red;
  Color _backgroundOn = Colors.white;
  Color _backgroundOff = Colors.transparent;
  
  // Keys for tab positioning
  List _keys = [];
  
  // Track if button was tapped
  bool _buttonTap = false;

  @override
  void initState() {
    super.initState();
    
    // Create keys for each tab
    for (int index = 0; index < _tabLabels.length; index++) {
      _keys.add(GlobalKey());
    }
    
    // Initialize tab controller
    _controller = TabController(vsync: this, length: _tabLabels.length);
    _controller.animation!.addListener(_handleTabAnimation);
    _controller.addListener(_handleTabChange);
    
    // Initialize animation controllers
    _animationControllerOff = AnimationController(
      vsync: this, 
      duration: Duration(milliseconds: 75)
    );
    _animationControllerOff.value = 1.0;
    _colorTweenBackgroundOff = ColorTween(
      begin: _backgroundOn, 
      end: _backgroundOff
    ).animate(_animationControllerOff);
    _colorTweenForegroundOff = ColorTween(
      begin: _foregroundOn, 
    ).animate(_animationControllerOff);
    
    _animationControllerOn = AnimationController(
      vsync: this, 
      duration: Duration(milliseconds: 150)
    );
    _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn = ColorTween(
      begin: _backgroundOff, 
      end: _backgroundOn
    ).animate(_animationControllerOn);
    _colorTweenForegroundOn = ColorTween(
    
      end: _foregroundOn
    ).animate(_animationControllerOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationControllerOn.dispose();
    _animationControllerOff.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back_ios_new_outlined)),
                      SizedBox(width: 50,),
                      Text(
                        _currentIndex == 0 ? 'Service Completed' : 'Payment Due',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Customer by Vehicle Number',
                        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Animated Tab Bar with Buttons
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(_tabLabels.length, (index) {
                  return Expanded(
                    child: Padding(
                      key: _keys[index],
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedBuilder(
                        animation: _colorTweenBackgroundOn,
                        builder: (context, child) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _buttonTap = true;
                              _controller.animateTo(index);
                              _setCurrentIndex(index);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _getBackgroundColor(index),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _currentIndex == index 
                                    ? Colors.red 
                                    : Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _tabLabels[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: _currentIndex == index 
                                      ? FontWeight.w600 
                                      : FontWeight.w500,
                                  color: _getForegroundColor(index),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Tab Content with Animation
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  CompletedTab(),
                  PaymentDueTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Animation handling methods
  _handleTabAnimation() {
    _aniValue = _controller.animation!.value;
    
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      _setCurrentIndex(_aniValue.round());
    }
    
    _prevAniValue = _aniValue;
  }
  
  _handleTabChange() {
    if (_buttonTap) _setCurrentIndex(_controller.index);
    
    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;
    
    _prevControllerIndex = _controller.index;
  }
  
  _setCurrentIndex(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _triggerAnimation();
    }
  }
  
  _triggerAnimation() {
    _animationControllerOn.reset();
    _animationControllerOff.reset();
    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }
  
  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenBackgroundOff.value;
    } else {
      return _backgroundOff;
    }
  }
  
  _getForegroundColor(int index) {
    if (index == _currentIndex) {
      return _colorTweenForegroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenForegroundOff.value;
    } else {
      return Colors.black54; // Default color for inactive tabs
    }
  }
}

enum ServiceStatus { completed, paymentPending }