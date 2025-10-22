import 'package:flutter/material.dart';

/// Reusable loading overlay for refresh operations
class RefreshLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String message;
  final Widget child;
  final Color? backgroundColor;
  final Color? indicatorColor;

  const RefreshLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message = 'Loading...',
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Stack(
      children: [
        child,
        
        // Loading overlay
        if (isLoading)
          Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode ? theme.cardColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: indicatorColor ?? const Color(0xFFD32F2F),
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Enhanced loading indicator for list items with shimmer effect
class ListLoadingIndicator extends StatefulWidget {
  final String message;
  final Color? color;
  final bool showShimmer;

  const ListLoadingIndicator({
    super.key,
    this.message = 'Loading...',
    this.color,
    this.showShimmer = true,
  });

  @override
  State<ListLoadingIndicator> createState() => _ListLoadingIndicatorState();
}

class _ListLoadingIndicatorState extends State<ListLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = widget.color ?? const Color(0xFFD32F2F);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enhanced loading animation
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 3,
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Enhanced message with typing effect
          Text(
            widget.message,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Please wait...',
            style: TextStyle(
              color: isDarkMode ? Colors.white54 : Colors.black54,
              fontSize: 14,
            ),
          ),
          
          if (widget.showShimmer) ...[
            const SizedBox(height: 40),
            // Shimmer placeholder cards
            ...List.generate(3, (index) => _buildShimmerCard(context, index)),
          ],
        ],
      ),
    );
  }

  Widget _buildShimmerCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.only(
        bottom: 12,
        left: 20,
        right: 20,
        top: index == 0 ? 0 : 0,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmerBox(40, 40, isCircle: true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(120, 16),
                    const SizedBox(height: 6),
                    _buildShimmerBox(80, 12),
                  ],
                ),
              ),
              _buildShimmerBox(60, 20, borderRadius: 10),
            ],
          ),
          const SizedBox(height: 12),
          _buildShimmerBox(double.infinity, 12),
          const SizedBox(height: 6),
          _buildShimmerBox(200, 12),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, {double borderRadius = 6, bool isCircle = false}) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2.0 * _shimmerController.value, 0.0),
              end: Alignment(1.0 + 2.0 * _shimmerController.value, 0.0),
              colors: [
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Refresh success/error feedback
class RefreshFeedback {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}