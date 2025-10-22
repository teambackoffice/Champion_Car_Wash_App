import 'package:flutter/material.dart';

/// Helper class for theme-aware colors and styles
class ThemeHelper {
  /// Get primary text color based on theme
  static Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.white 
        : Colors.black87;
  }

  /// Get secondary text color based on theme
  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.grey[300]! 
        : Colors.grey;
  }

  /// Get muted text color based on theme
  static Color getMutedTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.grey[400]! 
        : Colors.grey[600]!;
  }

  /// Get card background color based on theme
  static Color getCardBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Theme.of(context).cardColor 
        : Colors.white;
  }

  /// Get overlay background color based on theme
  static Color getOverlayBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.grey.withValues(alpha: 0.3)
        : Colors.grey.withValues(alpha: 0.1);
  }

  /// Check if current theme is dark
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get theme-aware text style for primary text
  static TextStyle getPrimaryTextStyle(BuildContext context, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: getPrimaryTextColor(context),
    );
  }

  /// Get theme-aware text style for secondary text
  static TextStyle getSecondaryTextStyle(BuildContext context, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: getSecondaryTextColor(context),
    );
  }

  /// Get theme-aware text style for muted text
  static TextStyle getMutedTextStyle(BuildContext context, {
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: getMutedTextColor(context),
    );
  }
}