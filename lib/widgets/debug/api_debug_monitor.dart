import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Debug widget to monitor API calls and refresh actions
/// Only shows in debug mode
class ApiDebugMonitor extends StatefulWidget {
  final Widget child;
  
  const ApiDebugMonitor({
    super.key,
    required this.child,
  });

  @override
  State<ApiDebugMonitor> createState() => _ApiDebugMonitorState();
}

class _ApiDebugMonitorState extends State<ApiDebugMonitor> {
  bool _showDebugInfo = false;
  final List<String> _debugLogs = [];
  
  @override
  void initState() {
    super.initState();
    
    // Listen to debug prints (in debug mode only)
    if (kDebugMode) {
      // This is a simplified approach - in production you'd use a proper logging system
      _startListeningToLogs();
    }
  }
  
  void _startListeningToLogs() {
    // This is a placeholder - you'd implement proper log listening here
    // For now, we'll just show the toggle button
  }
  
  void _addLog(String log) {
    if (mounted) {
      setState(() {
        _debugLogs.insert(0, '${DateTime.now().toIso8601String()}: $log');
        if (_debugLogs.length > 50) {
          _debugLogs.removeLast();
        }
      });
    }
  }
  
  void _clearLogs() {
    setState(() {
      _debugLogs.clear();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        // Debug overlay (only in debug mode)
        if (kDebugMode) ...[
          // Debug toggle button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: FloatingActionButton.small(
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _showDebugInfo = !_showDebugInfo;
                });
              },
              backgroundColor: _showDebugInfo ? Colors.red : Colors.grey,
              child: Icon(
                _showDebugInfo ? Icons.bug_report : Icons.bug_report_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          
          // Debug info panel
          if (_showDebugInfo)
            Positioned(
              top: MediaQuery.of(context).padding.top + 70,
              right: 10,
              left: 10,
              bottom: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bug_report, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          const Text(
                            'API Debug Monitor',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _clearLogs,
                            icon: const Icon(Icons.clear, color: Colors.white, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    
                    // Logs
                    Expanded(
                      child: _debugLogs.isEmpty
                          ? const Center(
                              child: Text(
                                'No API calls detected\nPull to refresh to see logs',
                                style: TextStyle(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _debugLogs.length,
                              itemBuilder: (context, index) {
                                final log = _debugLogs[index];
                                Color logColor = Colors.white70;
                                
                                if (log.contains('✅')) {
                                  logColor = Colors.green;
                                } else if (log.contains('❌')) {
                                  logColor = Colors.red;
                                } else if (log.contains('🔄')) {
                                  logColor = Colors.blue;
                                } else if (log.contains('📊') || log.contains('📋')) {
                                  logColor = Colors.orange;
                                }
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    log,
                                    style: TextStyle(
                                      color: logColor,
                                      fontSize: 10,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    
                    // Instructions
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Pull down on any screen to test refresh APIs\nCheck console for detailed logs',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }
}

// Extension to check if we're in debug mode
extension DebugMode on Widget {
  bool get kDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}