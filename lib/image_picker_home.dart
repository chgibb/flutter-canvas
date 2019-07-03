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
        MaterialPageRoute,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        Widget;

import 'package:flutter/widgets.dart'
    show
        BuildContext,
        Center,
        EdgeInsets,
        GestureDetector,
        Icon,
        ListView,
        Navigator,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:flutter_canvas/image_controller.dart';

import 'package:flutter_canvas/pick_image_from_camera.dart'
    show pickImageFromCamera;
import 'package:flutter_canvas/new_painter_controller.dart'
    show newPainterController;
import 'package:flutter_canvas/annotate_image.dart';

class ImagePickerHomePage extends StatefulWidget {
  @override
  _ImagePickerHomePageState createState() => _ImagePickerHomePageState();
}

class _ImagePickerHomePageState extends State<ImagePickerHomePage> {
  List<ImageController> _images = new List();
  Future getImage() async {
    File image = await pickImageFromCamera();

    setState(() {
      _images.add(ImageController(newPainterController(image)));
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnnotateImage(_images[_images.length - 1])));
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
          return GestureDetector(
            child: Center(
              child: _images[index].thumb != null ? _images[index].thumb : _images[index].annotatedImage,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnnotateImage(_images[index])));
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
