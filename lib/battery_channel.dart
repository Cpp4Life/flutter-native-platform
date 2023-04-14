import 'package:flutter/services.dart';

abstract class Battery {
  Future<int> getBattery();
}

class BatteryChannel implements Battery {
  static const batteryChannel = MethodChannel('dattr.flutter.dev/battery');

  @override
  Future<int> getBattery() async {
    try {
      final int result = await batteryChannel.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException {
      rethrow;
    }
  }
}
