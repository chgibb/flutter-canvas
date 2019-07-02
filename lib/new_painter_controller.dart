import 'dart:io';

import 'package:flutter/material.dart';
import 'package:painter2/painter2.dart';

PainterController newController([File image = null]) {
  PainterController controller = PainterController();
  controller.thickness = 5.0;
  controller.backgroundColor = Colors.white;

  if (image != null) {
    controller.backgroundImage = Image.file(image);
  }
  return controller;
}
