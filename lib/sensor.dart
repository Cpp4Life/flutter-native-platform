import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePressure extends StatefulWidget {
  static const routeName = '/pressure';

  const NativePressure({super.key});

  @override
  State<NativePressure> createState() => _NativePressureState();
}

class _NativePressureState extends State<NativePressure> {
  static const pressureChannel = MethodChannel('dattr.flutter.dev/pressure');
  static const pressureEventChannel = EventChannel('dattr.flutter.dev/pressure-event');

  String _sensorAvailable = 'Unknown status';
  double _pressureReading = 0;
  late StreamSubscription pressureSubscription;

  Future<void> _checkAvailability() async {
    String sensorAvailable;
    try {
      var available = await pressureChannel.invokeMethod('isSensorAvailable');
      sensorAvailable = available.toString();
    } on PlatformException catch (error) {
      sensorAvailable = 'Failed to get pressure status: ${error.message}';
    }
    setState(() {
      _sensorAvailable = sensorAvailable;
    });
  }

  _startReading() {
    pressureSubscription = pressureEventChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        _pressureReading = event;
      });
    });
  }

  _stopReading() {
    setState(() {
      _pressureReading = 0;
    });
    pressureSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pressure'),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sensor Available? $_sensorAvailable',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
              ),
              ElevatedButton(
                onPressed: _checkAvailability,
                child: const Text(
                  'Check Sensor Available',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              if (_pressureReading != 0)
                Text(
                  'Sensor Reading : $_pressureReading hPa',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32),
                ),
              if (_sensorAvailable == 'true' && _pressureReading == 0)
                ElevatedButton(
                  onPressed: () => _startReading(),
                  child: const Text(
                    'Start Reading',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              if (_pressureReading != 0)
                ElevatedButton(
                  onPressed: () => _stopReading(),
                  child: const Text(
                    'Stop Reading',
                    style: TextStyle(fontSize: 24),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
