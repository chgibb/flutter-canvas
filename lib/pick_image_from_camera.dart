import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> pickImageFromCamera() async {
  var image =  await ImagePicker.pickImage(source: ImageSource.camera);

  return image;
}
