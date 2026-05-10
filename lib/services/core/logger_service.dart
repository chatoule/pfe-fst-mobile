import 'package:flutter/foundation.dart';

class LoggerService {
  static void d(String message) {
    if (kDebugMode) {
      print('DEBUG: $message');
    }
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    print('ERROR: $message');
    if (error != null) print('Detail: $error');
    if (stackTrace != null) print(stackTrace);
  }

  static void i(String message) {
    print('INFO: $message');
  }
}
