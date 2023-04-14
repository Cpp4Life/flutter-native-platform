import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'battery_channel.dart';

class NativeBattery extends StatefulWidget {
  static const routeName = '/battery';

  const NativeBattery({super.key});

  @override
  State<NativeBattery> createState() => _NativeBatteryState();
}

class _NativeBatteryState extends State<NativeBattery> {
  String _batteryLevel = 'Unknown status';
  final Battery _battery = BatteryChannel();

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final result = await _battery.getBattery();
      batteryLevel = 'Battery level at $result%';
    } on PlatformException catch (error) {
      batteryLevel = 'Failed to get battery level: ${error.message}';
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  _batteryLevel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32),
                ),
                ElevatedButton(
                  onPressed: _getBatteryLevel,
                  child: const Text(
                    'Get Battery Level',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                // if (defaultTargetPlatform == TargetPlatform.iOS) const iOSNativeView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
