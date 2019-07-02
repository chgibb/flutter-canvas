import 'dart:io' show File;

import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        Divider,
        FloatingActionButton,
        Icon,
        Icons,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:flutter/widgets.dart';

import 'package:flutter_canvas/image_picker.dart' show pickImageFromCamera;
import 'package:flutter_canvas/new_painter_controller.dart';
import 'package:painter2/painter2.dart';

class ImagePickerHomePage extends StatefulWidget {
  @override
  _ImagePickerHomePageState createState() => _ImagePickerHomePageState();
}

class _ImagePickerHomePageState extends State<ImagePickerHomePage> {
  List<PainterController> _images = new List();
  Future getImage() async {
    File image = await pickImageFromCamera();

    setState(() {
      _images.add(newController(image));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: _images != null ? _images.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: _images[index].backgroundImage,
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      // child: _image == null ? Text('No image selected.') : Image.file(_image),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
