import 'dart:typed_data';

import 'package:flutter/material.dart' as Material;
import 'package:image/image.dart';

import 'package:painter2/painter2.dart';
import 'package:image/image.dart' as Img;

class ImageController {
  PainterController paintController;
  Material.Image thumb;
  Material.Image _origImage;
  Material.Image annotatedImage;
  Uint8List annotatedBytes;

  ImageController(this.paintController) {
    _origImage = paintController.backgroundImage;
    annotatedImage = paintController.backgroundImage;
  }

  void updateAnnotation(Uint8List bytes) {
    annotatedBytes = bytes;
    annotatedImage = Material.Image.memory(bytes);
    thumb = Material.Image.memory(bytes, height: 100, width: 100);
  }
}
