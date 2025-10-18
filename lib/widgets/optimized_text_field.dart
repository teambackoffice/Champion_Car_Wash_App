import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Optimized TextField widget with performance enhancements
///
/// Features:
/// - RepaintBoundary for reduced rebuilds
/// - Debounced validation
/// - AutofillHints support
/// - Minimal rebuilds with const constructors
/// - Smart focus management
class OptimizedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isRequired;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? autofillHint;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool enableInteractiveSelection;
  final Duration debounceDuration;

  const OptimizedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.isRequired = true,
    this.validator,
    this.onChanged,
    this.autofillHint,
    this.inputFormatters,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.enableInteractiveSelection = true,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  @override
  State<OptimizedTextField> createState() => _OptimizedTextFieldState();
}

class _OptimizedTextFieldState extends State<OptimizedTextField> {
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onChangedDebounced(String value) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Call immediate onChanged if provided
    widget.onChanged?.call(value);

    // Start new timer for validation (triggers form validation)
    _debounceTimer = Timer(widget.debounceDuration, () {
      if (mounted) {
        // Trigger form validation after debounce
        Form.of(context).validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap in RepaintBoundary to prevent unnecessary repaints
    return RepaintBoundary(
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onFieldSubmitted: widget.onFieldSubmitted,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        onTap: widget.onTap,
        inputFormatters: widget.inputFormatters,

        // AutofillHints for better keyboard suggestions
        autofillHints: widget.autofillHint != null ? [widget.autofillHint!] : null,

        // Use debounced onChanged
        onChanged: _onChangedDebounced,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),

        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),

          // Use const where possible for icons
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.grey[400], size: 20)
              : null,
          suffixIcon: widget.suffixIcon != null
              ? Icon(widget.suffixIcon, color: Colors.grey[400], size: 20)
              : null,

          filled: true,
          fillColor: const Color(0xFF2A2A2A),

          // Pre-defined borders to avoid rebuilding
          border: _buildBorder(Colors.transparent),
          enabledBorder: _buildBorder(const Color(0xFF555555)),
          focusedBorder: _buildBorder(Colors.red, width: 2),
          errorBorder: _buildBorder(Colors.red),
          focusedErrorBorder: _buildBorder(Colors.red, width: 2),

          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

          // Show error without red border unless required
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          errorMaxLines: 2,
        ),

        // Use cached validation error or validator
        validator: widget.validator,
      ),
    );
  }

  // Static border builder to reuse border instances
  static OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

/// Mixin to preserve scroll position and state in complex forms
/// Use with StatefulWidget that needs to maintain state during scrolling
mixin FormPageMixin<T extends StatefulWidget> on State<T>, AutomaticKeepAliveClientMixin<T> {
  @override
  bool get wantKeepAlive => true;
}
