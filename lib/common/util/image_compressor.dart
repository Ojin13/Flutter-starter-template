import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  static Future<Uint8List?> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(file.absolute.path,
        minHeight: 1920, minWidth: 1080, quality: 50, format: CompressFormat.webp, keepExif: false);

    return result;
  }
}
