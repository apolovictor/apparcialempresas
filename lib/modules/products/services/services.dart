import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<MemoryImage> convertXFileToMemoryImage(XFile img) async {
  return MemoryImage((await img.readAsBytes()));
}
