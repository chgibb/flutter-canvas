import 'dart:io' show File;

import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        FloatingActionButton,
        Icon,
        Icons,
        Image,
        MaterialApp,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        Widget,
        runApp;

import 'package:flutter_canvas/image_picker.dart' show pickImageFromCamera;

void main() {
  runApp(MaterialApp(
    home: ImagePickerHomePage(),
  ));
}

class ImagePickerHomePage extends StatefulWidget {
  @override
  _ImagePickerHomePageState createState() => _ImagePickerHomePageState();
}

class _ImagePickerHomePageState extends State<ImagePickerHomePage> {
  File _image;

  Future getImage() async {
    File image = await pickImageFromCamera();

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
