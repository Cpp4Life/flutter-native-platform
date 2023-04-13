import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ImageSource { photos, camera }

String _stringImageSource(ImageSource imageSource) {
  switch (imageSource) {
    case ImageSource.photos:
      return 'photos';
    case ImageSource.camera:
      return 'camera';
  }
}

abstract class ImagePicker {
  Future<File?> pickImage({required ImageSource source});
}

class ImagePickerChannel implements ImagePicker {
  static const platform = MethodChannel('dattr.flutter.dev/imagePicker');

  @override
  Future<File?> pickImage({required ImageSource source}) async {
    var stringImageSource = _stringImageSource(source);
    var result = await platform.invokeMethod('pickImage', stringImageSource);
    if (result is String) {
      return File(result);
    } else if (result is FlutterError) {
      throw result;
    }
    return null;
  }
}
