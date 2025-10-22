import 'package:flutter/material.dart';

/// Focus Manager for optimizing keyboard and focus behavior in forms
///
/// Benefits:
/// - Prevents unnecessary keyboard opens/closes
/// - Smooth transitions between fields
/// - Better UX with proper focus management
/// - Memory management for FocusNodes
class FormFocusManager {
  final List<FocusNode> _focusNodes = [];
  final List<VoidCallback> _listeners = [];

  /// Create a new FocusNode and track it
  FocusNode createFocusNode() {
    final node = FocusNode();
    _focusNodes.add(node);
    return node;
  }

  /// Create multiple FocusNodes at once
  List<FocusNode> createFocusNodes(int count) {
    return List.generate(count, (_) => createFocusNode());
  }

  /// Move focus to next field
  void nextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Move focus to previous field
  void previousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Unfocus all fields (close keyboard)
  void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Request focus on a specific field
  void requestFocus(BuildContext context, FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  /// Add listener to all focus nodes
  void addListenerToAll(VoidCallback listener) {
    _listeners.add(listener);
    for (var node in _focusNodes) {
      node.addListener(listener);
    }
  }

  /// Dispose all focus nodes
  void dispose() {
    // Remove listeners first
    for (var node in _focusNodes) {
      for (var listener in _listeners) {
        node.removeListener(listener);
      }
      node.dispose();
    }
    _focusNodes.clear();
    _listeners.clear();
  }

  /// Check if any field has focus
  bool get hasFocus => _focusNodes.any((node) => node.hasFocus);

  /// Get the currently focused node
  FocusNode? get focusedNode => _focusNodes.firstWhere(
    (node) => node.hasFocus,
    orElse: () => _focusNodes.first,
  );
}

/// Mixin for forms that need focus management
mixin FocusManagementMixin<T extends StatefulWidget> on State<T> {
  late final FormFocusManager focusManager;

  @override
  void initState() {
    super.initState();
    focusManager = FormFocusManager();
  }

  @override
  void dispose() {
    focusManager.dispose();
    super.dispose();
  }

  /// Helper to unfocus when tapping outside
  void unfocusOnTapOutside() {
    GestureDetector(
      onTap: () => focusManager.unfocus(context),
      behavior: HitTestBehavior.opaque,
    );
  }
}

/// Widget to handle tap-to-unfocus behavior
class UnfocusOnTap extends StatelessWidget {
  final Widget child;

  const UnfocusOnTap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
