import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_canvas/image_controller.dart';

import 'package:painter2/painter2.dart';

import 'new_painter_controller.dart';

class AnnotateImage extends StatefulWidget {
  final ImageController controller;

  AnnotateImage(this.controller);

  @override
  _AnnotateImageState createState() => new _AnnotateImageState(controller);
}

class _AnnotateImageState extends State<AnnotateImage> {
  bool _finished;
  bool _annotating;
  ImageController _controller;

  _AnnotateImageState(this._controller) {
    _annotating = false;
  }

  @override
  void initState() {
    super.initState();
    _finished = false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
                _finished = false;
                _controller.paintController = newPainterController();
              }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              setState(() {
                _finished = true;
              });
              Uint8List bytes =
                  await _controller.paintController.exportAsPNGBytes();
              _controller.updateAnnotation(bytes);
              Navigator.pop(context);
            }),
      ];
    }

    Widget leftButton;

    if (_annotating) {
      leftButton = Opacity(
        opacity: 0.6,
        child: FloatingActionButton.extended(
          heroTag: "left",
          label: Text("Undo"),
          onPressed: () {
            _controller.paintController.undo();
          },
        ),
      );
    } else {
      leftButton = Opacity(
        opacity: 0.6,
        child: FloatingActionButton.extended(
          heroTag: "left",
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          label: Text("Retake"),
        ),
      );
    }

    Widget middleButton;

    if (!_annotating) {
      middleButton = Opacity(
          opacity: 0.6,
          child: FloatingActionButton(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.white,
            heroTag: "middle",
            child: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _annotating = true;
                _controller.paintController.canPaint = true;
              });
            },
          ));
    } else {
      middleButton = Opacity(
          opacity: 0.6,
          child: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            heroTag: "middle",
            child: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _annotating = false;
                _controller.paintController.canPaint = false;
              });
            },
          ));
    }

    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new SizedBox.expand(
              child: Painter(_controller.paintController),
            ),
          ],
        ),
        floatingActionButton: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            leftButton,
            middleButton,
            Opacity(
              opacity: 0.6,
              child: FloatingActionButton.extended(
                  heroTag: "right",
                  label: Text("Done"),
                  backgroundColor: Colors.blue,
                  onPressed: () async {
                    setState(() {
                      _finished = true;
                    });
                    Uint8List bytes =
                        await _controller.paintController.exportAsPNGBytes();
                    _controller.updateAnnotation(bytes);
                    Navigator.pop(context);
                  }),
            ),
          ],
        ));
  }
}
