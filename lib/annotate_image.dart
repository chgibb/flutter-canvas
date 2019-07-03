import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_canvas/image_controller.dart';

import 'package:painter2/painter2.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  _AnnotateImageState(this._controller);

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
        ),
        IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              setState(() {
                _finished = true;
              });
              Uint8List bytes = await _controller.paintController.exportAsPNGBytes();
              _controller.updateAnnotation(bytes);
              Navigator.pop(context);
            }),
      ];
    }
    return Scaffold(
      appBar: AppBar(
          title: Text('Painter2 Example'),
          actions: actions,
          bottom: PreferredSize(
            child: DrawBar(_controller.paintController),
            preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
          )),
      body: Center(
          child: AspectRatio(aspectRatio: 1.0, child: Painter(_controller.paintController))),
    );
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              child: Slider(
            value: _controller.thickness,
            onChanged: (value) => setState(() {
                  _controller.thickness = value;
                }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.white,
          ));
        })),
        ColorPickerButton(_controller, false),
        ColorPickerButton(_controller, true),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_iconData, color: _color),
      tooltip:
          widget._background ? 'Change background color' : 'Change draw color',
      onPressed: () => _pickColor(),
    );
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text('Pick color'),
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) => pickerColor = c,
                      )));
            }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._background
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}
