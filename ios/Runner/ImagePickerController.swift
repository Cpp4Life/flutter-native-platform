//
//  ImagePickerController.swift
//  Runner
//
//  Created by Dat Truong on 2023-04-12.
//

import UIKit
import Flutter

class ImagePickerController: UIImagePickerController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var handler: ((_ image: UIImage?) -> Void)?
  
    convenience init(sourceType: UIImagePickerController.SourceType, handler: @escaping (_ image: UIImage?) -> Void) {
    self.init()
    self.sourceType = sourceType
    self.delegate = self
    self.handler = handler
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
      handler?(info[.originalImage] as? UIImage)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    handler?(nil)
  }
}

class ImageChannel: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  let channel: FlutterMethodChannel
  unowned let flutterViewController: FlutterViewController
  
  init(flutterViewController: FlutterViewController) {
    
    self.flutterViewController = flutterViewController
    channel = FlutterMethodChannel(name: "dattr.flutter.dev/imagePicker", binaryMessenger: flutterViewController.binaryMessenger)
  }
  
  func setup() {
    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result) -> Void in
      switch call.method {
      case "pickImage":
          let sourceType: UIImagePickerController.SourceType = "camera" == (call.arguments as? String) ? .camera : .photoLibrary
        let imagePicker = self.buildImagePicker(sourceType: sourceType, completion: result)
          self.flutterViewController.present(imagePicker, animated: true, completion: nil)
      default:
          result(FlutterMethodNotImplemented)
      }
    })
  }
  
    func buildImagePicker(sourceType: UIImagePickerController.SourceType, completion: @escaping FlutterResult) -> UIViewController {
    if sourceType == .camera && !UIImagePickerController.isSourceTypeAvailable(.camera) {
      let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
          completion(FlutterError(code: "camera_unavailable", message: "camera not available", details: nil))
      })
      return alert
    } else {
      return ImagePickerController(sourceType: sourceType) { image in
        self.flutterViewController.dismiss(animated: true, completion: nil)
          let image = image
          if ((image) != nil) {
              self.saveToFile(image: image!, completion: completion)
          } else {
              completion(FlutterError(code: "user_cancelled", message: "User did cancel", details: nil))
          }
      }
    }
  }
  
    private func saveToFile(image: UIImage, completion: @escaping FlutterResult ) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            completion(FlutterError(code: "image_encoding_error", message: "Could not read image", details: nil))
            return
      }
      let tempDir = NSTemporaryDirectory()
      let imageName = "image_picker_\(ProcessInfo().globallyUniqueString).jpg"
      let filePath = tempDir.appending(imageName)
      if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
          completion(filePath)
      } else {
          completion(FlutterError(code: "image_save_failed", message: "Could not save image to disk", details: nil))
      }
    }
}
