import 'dart:io';
import 'package:flutter/services.dart';

abstract final class WindowChrome {
  static const _channel = MethodChannel('aiva/window');

  static Future<void> startDragging() => _invoke('startDragging');
  static Future<void> doubleClick() => _invoke('doubleClick');

  static Future<void> _invoke(String method) async {
    if (!Platform.isMacOS) return;
    try {
      await _channel.invokeMethod<void>(method);
    } on MissingPluginException {
      // Widget tests do not have a native window.
    }
  }
}
