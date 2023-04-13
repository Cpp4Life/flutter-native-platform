import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      
      // first example
      let batteryChannel = FlutterMethodChannel(name: "dattr.flutter.dev/battery", binaryMessenger: controller.binaryMessenger)
      
      batteryChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "getBatteryLevel":
              self.receiveBatteryLevel(result: result)
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      
      // second example
      let pressureChannel = FlutterMethodChannel(name: "dattr.flutter.dev/pressure", binaryMessenger: controller.binaryMessenger)
      
      pressureChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "isSensorAvailable":
              result(CMAltimeter.isRelativeAltitudeAvailable())
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      
      let pressureStreamHanlder = PressureStreamHandler()
      let pressureEventChannel = FlutterEventChannel(
        name: "dattr.flutter.dev/pressure-event",
        binaryMessenger: controller.binaryMessenger
      )
      pressureEventChannel.setStreamHandler(pressureStreamHanlder)
      
      // third example
      let imageChannel = ImageChannel(flutterViewController: controller)
      imageChannel.setup()
      
      //
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Battery level not available",
                               details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }
}
