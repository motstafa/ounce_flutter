import 'dart:io'; // Import this for File class
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';


class ImageService {
  static Future<XFile?> compressImage(XFile imageFile) async {
    try {
      final filePath = imageFile.path;
      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        filePath,
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result != null) {
        final compressedSize = await result.length();
        if (compressedSize > 2048 * 1024) {
          return await FlutterImageCompress.compressAndGetFile(
            filePath,
            filePath,
            quality: 70,
            minWidth: 800,
            minHeight: 800,
          );
        }
        return result;
      }
      return null;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  static Future<XFile?> pickAndCompressImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      final originalFile = File(pickedImage.path);
      final originalSize = await originalFile.length();

      if (originalSize > 2048 * 1024) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        final compressedFile = await compressImage(pickedImage);
        Navigator.of(context).pop();

        return compressedFile != null ? XFile(compressedFile.path) : null;
      }
      return pickedImage;
    }
    return null;
  }
}