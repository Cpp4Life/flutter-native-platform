import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeBattery extends StatefulWidget {
  static const routeName = '/battery';

  const NativeBattery({super.key});

  @override
  State<NativeBattery> createState() => _NativeBatteryState();
}

class _NativeBatteryState extends State<NativeBattery> {
  static const batteryChannel = MethodChannel('dattr.flutter.dev/battery');

  String _batteryLevel = 'Unknown status';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await batteryChannel.invokeMethod('getBatteryLevel');
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
