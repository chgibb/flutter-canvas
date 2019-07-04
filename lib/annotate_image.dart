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
  ImageController _controller;

  _AnnotateImageState(this._controller) {
    //Rebuild when the user annotates
    _controller.paintController.addListener(() {
      setState(() {
        if(_controller.paintController.canUndo{
          _controller.paintController.undo();
        }
      });
    });
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
        /*IconButton(
          icon: Icon(Icons.undo),
          tooltip: 'Undo',
          onPressed: () {
            if (_controller.paintController.canUndo) _controller.paintController.undo();
          },
        ),
        IconButton(
          icon: Icon(Icons.redo),
          tooltip: 'Redo',
          onPressed: () {
            if (_controller.paintController.canRedo) _controller.paintController.redo();
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: 'Clear',
          onPressed: () => _controller.paintController.clear(),
        ),*/
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

    if (_controller.paintController.canUndo) {
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
            Opacity(
                opacity: 0.6,
                child: FloatingActionButton(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.white,
                  heroTag: "middle",
                  child: Icon(Icons.edit),
                )),
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
