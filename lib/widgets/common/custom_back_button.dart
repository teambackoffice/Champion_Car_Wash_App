import 'package:flutter/material.dart';

/// A reusable, highly clickable back button widget with consistent styling
///
/// Features:
/// - Larger tap target (48x48) for better accessibility
/// - Consistent visual design across the app
/// - Customizable colors and behavior
/// - Better navigation handling
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    this.backgroundColor = Colors.red,
    this.iconColor = Colors.white,
    this.size = 48, // Adjusted size for a sleeker look
    this.onPressed,
    this.isCircular = true,
    super.key,
  });

  /// The color of the button background (default: red)
  final Color backgroundColor;

  /// The color of the icon (default: white)
  final Color iconColor;

  /// The size of the button (default: 48)
  final double size;

  /// Custom callback when button is pressed. If null, uses Navigator.pop
  final VoidCallback? onPressed;

  /// Whether to show the button as a circle (default: true)
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ?? () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(isCircular ? size / 2 : 8),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircular ? null : BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back,
            color: iconColor,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

/// AppBar leading widget wrapper for CustomBackButton
/// This ensures proper centering and spacing in AppBar
class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    this.backgroundColor = Colors.red,
    this.iconColor = Colors.white,
    this.onPressed,
    super.key,
  });

  /// The color of the button background (default: red)
  final Color backgroundColor;

  /// The color of the icon (default: white)
  final Color iconColor;

  /// Custom callback when button is pressed. If null, uses Navigator.pop
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: CustomBackButton(
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        onPressed: onPressed,
        size: 40, // Smaller size for AppBar
      ),
    );
  }
}
