import 'dart:typed_data';

import 'package:flutter/material.dart' as Material;
import 'package:image/image.dart';

import 'package:painter2/painter2.dart';
import 'package:image/image.dart' as Img;

class ImageController {
  PainterController _painterController;
  Img.Image _thumb;
  Material.Image _origImage;
  Material.Image annotatedImage;
  Uint8List annotatedBytes;

  ImageController(this._painterController) {
    _origImage = _painterController.backgroundImage;
    annotatedImage = _painterController.backgroundImage;
  }

  void updateAnnotation(Uint8List bytes) {
    annotatedImage = Material.Image.memory(bytes);
    annotatedBytes = bytes;
    generateThumbnail();
  }

  void generateThumbnail() {
    _thumb = copyResize(Img.Image.fromBytes(100,100, annotatedBytes),width: 10,height: 10);
  }

  PainterController get paintController => _painterController;
  set paintController(PainterController controller){
    _painterController = controller;
  }

  Img.Image get thumb => _thumb;
}
