import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import '../res/components/show_toast_widget.dart';

class ImagePickerViewModel{
  static Future<XFile?> getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        return pickedImage;
      }
    } catch (e) {
      showToastMessage(
          "Please Try again, Something went wrong!!!",
          Colors.red,
      );
    }
    return null;
  }

  static Future<String?> getRecognisedText(XFile image) async {
    String scannedText = "";
    try {
      final inputImage = InputImage.fromFilePath(image.path);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      RecognizedText recognisedText = await textDetector.processImage(inputImage);
      await textDetector.close();
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          scannedText = "$scannedText${line.text}";
        }
      }
    } catch(e) {
      showToastMessage(
        "Please Try again, Something went wrong!!!",
        Colors.red,
      );
    }
    return scannedText;
  }

}