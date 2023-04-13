import 'dart:io';

import 'package:flutter/material.dart';

import 'image_picker_channel.dart';

class NativeCamera extends StatefulWidget {
  static const routeName = '/camera';

  const NativeCamera({super.key});

  @override
  State<NativeCamera> createState() => _NativeCameraState();
}

class _NativeCameraState extends State<NativeCamera> {
  final ImagePicker _imagePicker = ImagePickerChannel();
  File? _imageFile;

  Future<void> captureImage(ImageSource imageSource) async {
    try {
      final imageFile = await _imagePicker.pickImage(source: imageSource);
      print(imageFile);
      setState(() {
        _imageFile = imageFile;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      print(_imageFile);
      return Image.file(_imageFile!);
    } else {
      return const Text(
        'Take an image to start',
        style: TextStyle(fontSize: 18.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _buildImage(),
            ),
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(height: 80.0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(
                key: const Key('retake'),
                text: 'Photos',
                onPressed: () => captureImage(ImageSource.photos),
              ),
              _buildActionButton(
                key: const Key('upload'),
                text: 'Camera',
                onPressed: () => captureImage(ImageSource.camera),
              ),
            ]));
  }

  Widget _buildActionButton(
      {required Key key, required String text, required VoidCallback onPressed}) {
    return Expanded(
      child: TextButton(
        key: key,
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
