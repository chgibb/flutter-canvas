import 'dart:typed_data';

import 'package:flutter/material.dart' as Material;
import 'package:image/image.dart';

import 'package:painter2/painter2.dart';
import 'package:image/image.dart' as Img;

class ImageController {
  PainterController paintController;
  Img.Image _thumb;
  Material.Image _origImage;
  Material.Image annotatedImage;
  Uint8List annotatedBytes;

  ImageController(this.paintController) {
    _origImage = paintController.backgroundImage;
    annotatedImage = paintController.backgroundImage;
  }

  void updateAnnotation(Uint8List bytes) {
    annotatedImage = Material.Image.memory(bytes);
    annotatedBytes = bytes;
    generateThumbnail();
  }

  void generateThumbnail() {
    _thumb = copyResize(Img.Image.fromBytes(100,100, annotatedBytes),width: 10,height: 10);
  }

  Img.Image get thumb => _thumb;
}
