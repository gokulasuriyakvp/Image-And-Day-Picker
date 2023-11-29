import 'package:flutter/material.dart';
import 'package:fluttter_image_day_pickers/page_view_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'appdata.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  int _selectedIndex = 0;

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null) return;

    final imageTemp = File(image.path);

    print(imageTemp);

    setState(() {
      _image = imageTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            itemBuilder: (context) =>
                [PopupMenuItem(value: 1, child: Text('Share'))],
            onSelected: (value) {
              if (value == 1) {
                _share();
              }
            },
          )
        ],
        backgroundColor: Colors.blue,
        title: Text('Image Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Text('No image selected.') : Image.file(_image!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Pick Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Pick Image from Camera'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PageViewImage(),
                ));
                print('Display image from Directory');
              },
              child: Text('Directory'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _share() async {
    if (_image == null) {
      // Handle the case where no image is selected
      return;
    }

    // Choose a custom directory for storing the image
    final customDirectory = await getApplicationDocumentsDirectory();
    print(customDirectory);
    final path = '${customDirectory.path}/download.jpg';

    // Copy the selected image to the custom directory
    await _image!.copy(path);

    // Perform the sharing operation
    await Share.shareFiles([path], text: 'Image shared');
  }

// Future<void> _share() async {
//   final ByteData imageByte = await rootBundle.load(appdatalist[_selectedIndex].image);
//   final tempDir = await getTemporaryDirectory();
//   final path = '${tempDir.path}/download.jpg';
//   print(path);
//   File(path).writeAsBytesSync(imageByte.buffer.asUint8List(), flush: true);
//   await Share.shareFiles([path], text: 'Image shared');
// }
}
