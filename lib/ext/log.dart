import 'package:flutter/foundation.dart';

class Log {
  static const String _defaultTag = 'wishing';

  static void conf(String message) {
    i(message, tag: 'conf');
  }

  static void d(String message, {String? tag}) {
    if (!kDebugMode) return;
    _print('DEBUG', message, tag);
  }

  static void i(String message, {String? tag}) {
    if (!kDebugMode) return;
    _print('INFO', message, tag);
  }

  static void w(String message, {String? tag}) {
    if (!kDebugMode) return;
    _print('WARN', message, tag);
  }

  static void e(String message, {String? tag}) {
    if (!kDebugMode) return;
    _print('ERROR', message, tag);
  }

  static void _print(String level, String message, String? tag) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}.'
        '${now.millisecond.toString().padLeft(3, '0')}';

    final tagStr = tag != null ? '$_defaultTag/$tag' : _defaultTag;
    debugPrint('$timeStr $level/$tagStr: $message');
  }
}
