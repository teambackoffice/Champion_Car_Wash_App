import 'package:flutter/foundation.dart';

class InspectionDebugHelper {
  static void logInspectionFlow(String step, Map<String, dynamic> data) {
    if (kDebugMode) {
      print('🔍 [INSPECTION_DEBUG] [$step] ${DateTime.now()}');
      data.forEach((key, value) {
        print('🔍 [INSPECTION_DEBUG] [$step] $key: $value');
      });
      print('🔍 [INSPECTION_DEBUG] [$step] ==================');
    }
  }

  static void logError(String step, dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('❌ [INSPECTION_ERROR] [$step] ${DateTime.now()}');
      print('❌ [INSPECTION_ERROR] [$step] Error: $error');
      if (stackTrace != null) {
        print('❌ [INSPECTION_ERROR] [$step] Stack trace: $stackTrace');
      }
      print('❌ [INSPECTION_ERROR] [$step] ==================');
    }
  }

  static void logSuccess(String step, [String? message]) {
    if (kDebugMode) {
      print('✅ [INSPECTION_SUCCESS] [$step] ${DateTime.now()}');
      if (message != null) {
        print('✅ [INSPECTION_SUCCESS] [$step] $message');
      }
      print('✅ [INSPECTION_SUCCESS] [$step] ==================');
    }
  }
}