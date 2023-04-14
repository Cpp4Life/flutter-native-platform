import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class Battery {
  Future<int?> getBattery();
}

class BatteryChannel implements Battery {
  static const batteryChannel = MethodChannel('dattr.flutter.dev/battery');

  @override
  Future<int?> getBattery() async {
    final int result = await batteryChannel.invokeMethod('getBatteryLevel');
    if (result is Int) {
      return result;
    } else if (result is FlutterError) {
      throw result;
    }
    return null;
  }
}
