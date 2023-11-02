import 'package:attendance_register/res/components/loading_widget.dart';
import 'package:attendance_register/view_model/image_view_model.dart';
import 'package:attendance_register/views/edit_extracted_text_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScanPage extends StatefulWidget {
  const ImageScanPage({Key? key}) : super(key: key);

  @override
  State<ImageScanPage> createState() => _ImageScanPageState();
}

class _ImageScanPageState extends State<ImageScanPage> {
  String scannedText = "";
  XFile? imageFile;

  bool textScanning = false;
  bool isAttendanceLoading = false;

  Size? screenSize;
  TextEditingController scannedTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Logbook Image"),
        elevation: 5,
        backgroundColor: ThemeData().primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Center(
          child: Stack(
            children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                imageSelectionWidget(
                    ImageSource.gallery, Icons.image, "Gallery"),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                imageSelectionWidget(
                    ImageSource.camera, Icons.camera_alt, "Camera"),
              ],
            ),
            if (textScanning)
              const LoadingWidget(description: "Extracting text from the image")
          ],
        )),
      ),
    );
  }

  Widget imageSelectionWidget(ImageSource imageSource, IconData buttonIcon, String buttonText) {
    return Container(
      height: MediaQuery.of(context).size.height /3,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeData().primaryColorLight,
          shadowColor: Colors.grey[100],
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)),
        ),
        onPressed: () async {
          XFile? pickedImage = await ImagePickerViewModel.getImage(imageSource);
          setState(() {
            textScanning = true;
          });
          if (pickedImage != null) {
            String extractedText = await ImagePickerViewModel.getRecognisedText(pickedImage) ?? "";
            setState(() {
              textScanning = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditExtractedTextPage(
                      imageFile: pickedImage, extractedText: extractedText
                  )
              ),
            );
          } else {
            setState(() {
              textScanning = false;
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                buttonIcon,
                size: 30,
                color: ThemeData().primaryColorDark,
              ),
              Text(
                buttonText,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              )
            ],
          ),
        ),
      )
    );
  }
}
