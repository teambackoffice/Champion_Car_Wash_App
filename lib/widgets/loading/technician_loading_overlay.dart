import 'package:flutter/material.dart';

class TechnicianLoadingOverlay extends StatefulWidget {
  final bool isVisible;
  final String message;
  final Color primaryColor;
  final Widget child;

  const TechnicianLoadingOverlay({
    super.key,
    required this.isVisible,
    required this.message,
    required this.primaryColor,
    required this.child,
  });

  @override
  State<TechnicianLoadingOverlay> createState() =>
      _TechnicianLoadingOverlayState();
}

class _TechnicianLoadingOverlayState extends State<TechnicianLoadingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  void didUpdateWidget(TechnicianLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isVisible)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: widget.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  color: widget.primaryColor,
                                  strokeWidth: 4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.message,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please wait...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

// Helper widget for quick implementation
class QuickLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String message;
  final Color color;
  final Widget child;

  const QuickLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.message,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TechnicianLoadingOverlay(
      isVisible: isLoading,
      message: message,
      primaryColor: color,
      child: child,
    );
  }
}
