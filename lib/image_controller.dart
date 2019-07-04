import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' as Material;

import 'package:painter2/painter2.dart';

class ImageController {
  PainterController paintController;
  Material.Image thumb;
  Material.Image _origImage;
  Material.Image annotatedImage;
  Uint8List annotatedBytes;

  ImageController(this.paintController) {
    _origImage = paintController.backgroundImage;
    annotatedImage = paintController.backgroundImage;
    paintController.drawColor = Color.fromARGB(255, 255, 0, 0);
  }

  void updateAnnotation(Uint8List bytes) {
    annotatedBytes = bytes;
    annotatedImage = Material.Image.memory(bytes);
    thumb = Material.Image.memory(bytes, height: 100, width: 100);
  }
}
