import 'package:flutter/material.dart';

/// A reusable, highly clickable back button widget with consistent styling
///
/// Features:
/// - Larger tap target (48x48) for better accessibility
/// - Consistent visual design across the app
/// - Customizable colors and behavior
/// - Better navigation handling
class CustomBackButton extends StatelessWidget {
  /// The color of the button background (default: red)
  final Color backgroundColor;

  /// The color of the icon (default: white)
  final Color iconColor;

  /// The size of the button (default: 40)
  final double size;

  /// Custom callback when button is pressed. If null, uses Navigator.pop
  final VoidCallback? onPressed;

  /// Whether to show the button as a circle (default: true)
  final bool isCircular;

  const CustomBackButton({
    super.key,
    this.backgroundColor = Colors.red,
    this.iconColor = Colors.white,
    this.size = 40,
    this.onPressed,
    this.isCircular = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed ?? () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(isCircular ? size / 2 : 8),
        // Larger tap target for better accessibility
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircular ? null : BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: iconColor,
            size: size * 0.45, // Icon size proportional to button size
          ),
        ),
      ),
    );
  }
}

/// AppBar leading widget wrapper for CustomBackButton
/// This ensures proper centering and spacing in AppBar
class AppBarBackButton extends StatelessWidget {
  /// The color of the button background (default: red)
  final Color backgroundColor;

  /// The color of the icon (default: white)
  final Color iconColor;

  /// Custom callback when button is pressed. If null, uses Navigator.pop
  final VoidCallback? onPressed;

  const AppBarBackButton({
    super.key,
    this.backgroundColor = Colors.red,
    this.iconColor = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomBackButton(
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        onPressed: onPressed,
      ),
    );
  }
}
