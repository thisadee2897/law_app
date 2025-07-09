import 'dart:io';
import 'package:flutter/services.dart';

class BatteryOptimizationHelper {
  static const MethodChannel _channel = MethodChannel('battery_optimization');

  /// Check if battery optimization is enabled for the app
  static Future<bool> isBatteryOptimizationEnabled() async {
    if (!Platform.isAndroid) return false;
    
    try {
      final bool isEnabled = await _channel.invokeMethod('isBatteryOptimizationEnabled');
      return isEnabled;
    } on PlatformException catch (e) {
      print('Error checking battery optimization: ${e.message}');
      return false;
    }
  }

  /// Request to disable battery optimization for the app
  static Future<bool> requestDisableBatteryOptimization() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final bool success = await _channel.invokeMethod('requestDisableBatteryOptimization');
      return success;
    } on PlatformException catch (e) {
      print('Error requesting disable battery optimization: ${e.message}');
      return false;
    }
  }

  /// Open battery optimization settings for the app
  static Future<void> openBatteryOptimizationSettings() async {
    if (!Platform.isAndroid) return;
    
    try {
      await _channel.invokeMethod('openBatteryOptimizationSettings');
    } on PlatformException catch (e) {
      print('Error opening battery optimization settings: ${e.message}');
    }
  }
}
