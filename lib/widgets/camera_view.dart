import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key, required this.onImage, required this.onInputImage})
      : super(key: key);

  final Function(Uint8List image) onImage;
  final Function(InputImage inputImage) onInputImage;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  File? _image;
  ImagePicker? _imagePicker;

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xff2E2E2E),
            ),
          ),
          child: _image != null
              ? Image.file(
                  _image!,
                  fit: BoxFit.cover,
                )
              : const Center(
                  child: Icon(
                    Icons.camera_alt,
                    size: 55,
                    color: Color(0xff2E2E2E),
                  ),
                ),
        ),

        // SizedBox
        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: _getImage,
              child: const Text(
                "Pick Image",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Future _getImage() async {
    setState(() {
      _image = null;
    });
    final pickedFile = await _imagePicker?.pickImage(
      source: ImageSource.camera,
      maxWidth: 400,
      maxHeight: 400,
      // imageQuality: 50,
    );
    if (pickedFile != null) {
      _setPickedFile(pickedFile);
    }
    setState(() {});
  }

  Future _setPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
    });

    Uint8List imageBytes = _image!.readAsBytesSync();
    widget.onImage(imageBytes);

    InputImage inputImage = InputImage.fromFilePath(path);
    widget.onInputImage(inputImage);
  }
}
