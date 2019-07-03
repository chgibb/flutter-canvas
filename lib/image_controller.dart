import 'package:flutter/material.dart' as Material;

import 'package:painter2/painter2.dart';
import 'package:image/image.dart' as Img;

class ImageController {
  PainterController _painterController;
  Img.Image _thumb;
  Material.Image _origImage;
  Material.Image annotatedImage;

  ImageController(this._painterController) {
    _origImage = _painterController.backgroundImage;
    annotatedImage = _painterController.backgroundImage;
  }

  PainterController get paintController => _painterController;
  set paintController(PainterController controller){
    _painterController = controller;
  }

  Img.Image get thumb => _thumb;
}
